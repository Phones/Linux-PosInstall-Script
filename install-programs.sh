#!/bin/bash

# ------ Cores ------
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
# -------------------

# ------ URL's ------
GOOGLE_CHROME_URL=''
# -------------------

# ------------------  print with color -----------------------
function pwc()
{
    text_color=${1^^}
    text=${2^^}

    echo -e "\e${!text_color} ${text} ${NC}"
}

# ------------------- Atualização do sistema ------------------


pwc "blue" "atualizando o sistema"

apt-get update -y

apt-get upgrade -y

# -------------------------------------------------------------

# ------------------ Programas que podem ser instalados pelo gerenciador de pacotes ----------------------
INSTALAR_POR_GERENCIADOR=(
    git
    wget
    g++
    python3
    python3-pip
    python-is-python3
    nano
)

pwc "blue" "instalando programas via gerenciador de pacotes"
for program_name in ${INSTALAR_POR_GERENCIADOR[@]}; do
    # Verifica se o programa já está instalado
    if ! dpkg -l | grep -q $program_name; then
        pwc "blue" "   ---> [instalando] $program_name"
        apt-get install "$program_name" -y
    else
        pwc "green" "   [✔] - $program_name"
    fi
done
pwc "green" "Instalação dos programas de gerenciador finalizado"

# ----------------------------------------------------------------------------------------------------------



