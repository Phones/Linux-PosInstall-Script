#!/bin/bash

# ------ Cores ------
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$PWD/Downloads/"
caminho_vscode_tmp_file="/tmp/vscode_extensions.txt"
caminho_instalar_por_gerenciador_file="/tmp/instalar_por_gerenciador.txt"
caminho_nomes_programas_externos_file="/tmp/nomes_programas_externos.txt"
caminho_programas_externos="/tmp/download_programas_externos.txt"
caminho_docker_file="/tmp/docker_file.txt"
caminho_docker_compose_file="/tmp/docker_compose_file.txt"
caminho_spotify_file="/tmp/spotify_file.txt"
caminho_obs_file="/tmp/obs_file.txt"
caminho_extensoes_vscode_file="/tmp/extensoes_vscode_file.txt"
# Progresso do codigo de instalação
progresso_instalacao=0
# Definir o valor máximo para a barra de progresso
total=100
# Defini a variavel que vai armazeenar a senha inserida para o usuario
password="admin"

# ------------------  print with color -----------------------
function pwc()
{
  text_color=${1^^}
  text=${2^^}

  echo -e "\e${!text_color} ${text} ${NC}"
}
# ------------------------------------------------------------

# ------------------- Atualização do sistema ------------------
function update_system()
{
  echo $password
  pwc "blue" "atualizando o sistema"
  echo "$password" | sudo -S apt-get update -y > /dev/null 2> Logs/log_update.txt
  echo "$password" | sudo -S apt-get upgrade -y > /dev/null 2> Logs/log_upgrade.txt
}
# -------------------------------------------------------------

verificarArray() {
  local array=("$@")

  if [[ -n "${array[0]}" ]]; then
    echo "A variável é um array."
  else
    echo "A variável não é um array."
  fi
}

verificarStringNaLista() {
  local programa="$1"
  shift 1  # Remover o primeiro argumento (programa) da lista de argumentos

  for programa_selecionado in "$@"; do
      if [ "$programa_selecionado" = "$programa" ]; then
          return 0  # Retorna 0 (true) se a string estiver na lista
      fi
  done

  return 1  # Retorna 1 (false) se a string não estiver na lista
}

vertifica_programa_instalado_com_dpkg() {
  local programa="$1"

  # Verificar se o programa está instalado
  if dpkg -l | grep -q $programa; then
      return 0  # Retorna 0 (true) se o programa estiver instalado
  else
      return 1  # Retorna 1 (false) se o programa não estiver instalado
  fi
}

vertifica_programa_instalado_com_which() {
  if which "$1" >/dev/null 2>&1; then
    return 0  # Program exists
  else
    return 1  # Program does not exist
  fi
}

vertifica_programa_instalado_com_flatpak() {
  if flatpak list | grep -q "$1"; then
    return 0  # OBS está instalado
  else
    return 1  # OBS não está instalado
  fi
}

vertifica_programa_instalado_com_snap() {
  if snap list | grep -q "$1"; then
    return 0  # O programa está instalado pelo Snap
  else
    return 1  # O programa não está instalado pelo Snap
  fi
}

cria_pasta_download() {
  pwc "blue" "criando e acessando pasta de downloads dos programas externos"
  mkdir $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS
}

atualiza_tudo_e_limpa_o_sistema() {
  echo "$password" | sudo -S apt update -y> /dev/null 2> Logs/log_update_final.txt
  echo "$password" | sudo -S apt dist-upgrade -y > /dev/null 2> Logs/log_dist_upgrade.txt
  echo "$password" | sudo -S apt install -fy > /dev/null 2> Logs/log_instalar_depencias_faltando.txt
  echo "$password" | sudo -S flatpak update > /dev/null 2> Logs/log_flatpak_update.txt
  echo "$password" | sudo -S apt autoclean > /dev/null 2> Logs/log_autoclean.txt
  echo "$password" | sudo -S apt autoremove -y > /dev/null 2> Logs/log_autoremove.txt
  rm -rf $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS
}

imcrementa_variavel_progresso() {
  progresso_instalacao=$((progresso_instalacao + $1))
  echo $(($progresso_instalacao * 100 / total)) >&3
}

retorna_nome_da_extensao() {
  nome_diretorio_sem_versao=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  # Nome completo da pasta
  diretorios_encontrados=$(compgen -d "$HOME/.vscode/extensions/$nome_diretorio_sem_versao")
  # Pega o nome da extensao
  nome_extensao=$(grep -Po '"displayName":\s*"\K[^"]+' $diretorios_encontrados/package.json)
  # Retorna o nome da extensao coletado
  echo $nome_extensao
}

delete_tmp_files() {
  rm -rf $caminho_vscode_tmp_file $caminho_instalar_por_gerenciador_file $caminho_nomes_programas_externos_file
}

