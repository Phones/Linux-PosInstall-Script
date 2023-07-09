#!/bin/bash

# ------ Cores ------
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$PWD/Downloads"
caminho_vscode_tmp_file="/tmp/vscode_extensions.txt"
caminho_instalar_por_gerenciador_file="/tmp/instalar_por_gerenciador.txt"
caminho_nomes_programas_instalados_file="/tmp/nomes_programas_instalados.txt"
caminho_programas_externos="/tmp/programas_externos.txt"
caminho_docker_file="/tmp/programas_externos.txt"
caminho_docker_compose_file="/tmp/programas_externos.txt"
caminho_spotify_file="/tmp/programas_externos.txt"
caminho_obs_file="/tmp/programas_externos.txt"

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
  pwc "blue" "atualizando o sistema"
  sudo apt-get update -y &>/dev/null
  sudo apt-get upgrade -y &>/dev/null
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

vertifica_programa_instalado() {
  local programa="$1"

  # Verificar se o programa está instalado
  if which "$programa" >/dev/null 2>&1; then
      return 0  # Retorna 0 (true) se o programa estiver instalado
  else
      return 1  # Retorna 1 (false) se o programa não estiver instalado
  fi
}

cria_pasta_download() {
  pwc "blue" "criando e acessando pasta de downloads dos programas externos"
  mkdir $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS
}

atualiza_tudo_e_limpa_o_sistema() {
  sudo apt update && sudo apt dist-upgrade -y
  flatpak update
  sudo apt autoclean
  sudo apt autoremove -y
  rm -rf $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS
}

delete_tmp_files() {
  rm -rf $caminho_vscode_tmp_file $caminho_instalar_por_gerenciador_file $caminho_nomes_programas_instalados_file
}

