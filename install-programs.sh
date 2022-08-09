#!/bin/bash

# ------ Cores ------
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
# -------------------

# ------------------  print with color -----------------------
function pwc()
{
    text_color=${1^^}
    text=${2^^}

    echo -e "\e${!text_color} ${text} ${NC}"
}

# ------------------- Atualização do sistema ------------------

function update_system()
{
    pwc "blue" "atualizando o sistema"
    apt-get update -y
    apt-get upgrade -y
}

# -------------------------------------------------------------

update_system

# ------------------ Programas que podem ser instalados pelo gerenciador de pacotes ----------------------
INSTALAR_POR_GERENCIADOR=(
    git
    wget
    g++
    python3
    python3-pip
    python-is-python3
    nano
    snapd
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

# -------------- Faz a instalação dos programas que precisam ser baixados externamente ---------------------
pwc "blue" "criando e acessando pasta de downloads dos programas externos"
mkdir /home/paulohenrique/Downloads/Programas

cd /home/paulohenrique/Downloads/Programas/

DOWNLOAD_PROGRAMAS_EXTERNOS=(
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    "https://az764295.vo.msecnd.net/stable/da76f93349a72022ca4670c1b84860304616aaa2/code_1.70.0-1659589288_amd64.deb"
    "https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.deb"
)

LISTA_NOMES_PROGRAMAS_EXTERNOS=(
    "google"
    "vscode"
    "discord"
)

pwc "blue" "fazendo download de todos os programas externos"
for program_url in ${DOWNLOAD_PROGRAMAS_EXTERNOS[@]}; do
    wget -c "${program_url}"
done

pwc "green" "todos os downloads foram finalizados"

pwc "blue" "instalando todos os programas baixados"
dpkg -i .deb

pwc "green" "programas externos instalados"
for program_name in ${LISTA_NOMES_PROGRAMAS_EXTERNOS[@]}; do
    pwc "green" "   [✔] - $program_name"
done


# ----------------------------------------------------------------------------------------------------------

