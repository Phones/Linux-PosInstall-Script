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
    "docker"
    "docker-compose"
    "obsidian"
)

INSTALAR_POR_GERENCIADOR=(
    git
    wget
    g++
    python3
    python3-pip
    python-is-python3
)

VSCODE_EXTENSIONS=(
    dracula-theme.theme-dracula
    foxundermoon.shell-format
    ms-python.python
    ms-python.vscode-pylance
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.cpptools
    natqe.reload
    PKief.material-icon-theme
    truman.autocomplate-shell
)