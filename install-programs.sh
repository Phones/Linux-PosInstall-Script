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

pwc "green" "atualizando o sistema"

apt-get update -y

apt-get upgrade -y

# -------------------------------------------------------------
