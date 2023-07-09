#!/bin/bash

caminho_vscode_tmp_file="/tmp/vscode_extensions.txt"
caminho_instalar_por_gerenciador_file="/tmp/instalar_por_gerenciador.txt"
caminho_nomes_programas_instalados_file="/tmp/nomes_programas_instalados.txt"

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
    sudo apt-get update -y
    sudo apt-get upgrade -y
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

delete_tmp_files() {
    rm -rf $caminho_vscode_tmp_file $caminho_instalar_por_gerenciador_file $caminho_nomes_programas_instalados_file
}

