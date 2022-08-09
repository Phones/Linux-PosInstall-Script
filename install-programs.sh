#!/bin/bash

# ------ Cores ------
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
# -------------------

# ---------------------- Variaveis --------------------------
CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$HOME/Downloads/Programas"

LISTA_NOMES_PROGRAMAS_INSTALADOS=(
    "git"
    "python3"
    "python-is-python3"
    "python3-pip"
    "snapd"
    "spotify"
    "google"
    "vscode"
    "discord"
    "steam"
    "OBS"
)

INSTALAR_POR_GERENCIADOR=(
    git
    wget
    g++
    python3
    python3-pip
    python-is-python3
    nano
    snapd
    steam-installer
    steam-devices
    steam:i386
)

# ------------------------------------------------------------

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
    sudo apt-get update -y
    sudo apt-get upgrade -y
}

# -------------------------------------------------------------

update_system

# ---------------- Instala programas que podem ser instalados pelo gerenciador de pacotes ------------------

pwc "blue" "instalando programas via gerenciador de pacotes"
for program_name in ${INSTALAR_POR_GERENCIADOR[@]}; do
    # Verifica se o programa já está instalado
    if ! dpkg -l | grep -q $program_name; then
        pwc "blue" "   ---> [instalando] $program_name"
        sudo apt-get install "$program_name" -y
    else
        pwc "green" "   [✔] - $program_name"
    fi
done
pwc "green" "Instalação dos programas de gerenciador finalizado"

# ----------------------------------------------------------------------------------------------------------

update_system

# -------------- Faz a instalação dos programas que precisam ser baixados externamente ---------------------
pwc "blue" "criando e acessando pasta de downloads dos programas externos"
mkdir $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS

DOWNLOAD_PROGRAMAS_EXTERNOS=(
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    "https://az764295.vo.msecnd.net/stable/da76f93349a72022ca4670c1b84860304616aaa2/code_1.70.0-1659589288_amd64.deb"
    "https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.deb"
)

pwc "blue" "fazendo download de todos os programas externos"
for program_url in ${DOWNLOAD_PROGRAMAS_EXTERNOS[@]}; do
    wget -c "${program_url}"
done

pwc "green" "todos os downloads foram finalizados"

pwc "blue" "instalando todos os programas baixados"
dpkg -i $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS/*.deb

# ----------------------------------------------------------------------------------------------------------

# ----------------- Instalação de programas via flatpack --------------
flatpak install flathub com.obsproject.Studio -y
# ---------------------------------------------------------------------

# ----------------- Instalação dos pacotes por snap -------------------
snap install spotify
# ---------------------------------------------------------------------

# ---------------------------- Atualiza o sistema e executa os comandos de limpeza -------------------------
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
rm -rf $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS
# ----------------------------------------------------------------------------------------------------------


pwc "green" "programas instalados"
for program_name in ${LISTA_NOMES_PROGRAMAS_EXTERNOS[@]}; do
    pwc "green" "   [✔] - $program_name"
done

print "green" "[✔] script de instalação finalizado [✔]"