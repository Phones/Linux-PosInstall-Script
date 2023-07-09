#!/bin/bash

source helpers.sh

CreateListsOfPrograms() {
    # Pega a lista de opções que o usuario selecionou
    declare -a opcoes_selecionadas=("$@")
 
    # Declara o tipo de instalação do programa
    declare -A dicionario_tipo_instalacao

    dicionario["git"]="G"
    dicionario["wget"]="G"
    dicionario["g++"]="G"
    dicionario["python3"]="G"
    dicionario["python3-pip"]="G"
    dicionario["python-is-python3"]="G"
    # dicionario["snapd"]="valor1"
    # dicionario["spotify"]="valor2"
    # dicionario["google"]="valor3"
    # dicionario["vscode"]="valor1"
    # dicionario["discord"]="valor2"
    # dicionario["steam"]="valor3"
    # dicionario["OBS"]="valor1"
    # dicionario["docker"]="valor2"
    # dicionario["docker-compose"]="valor3"
    # dicionario["obsidian"]="valor1"

    # ------ Cores ------
    BLUE='\033[0;34m'
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m'
    # -------------------

    # ---------------------- Variaveis --------------------------
    CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$HOME/Downloads/Programas"

#     LISTA_NOMES_PROGRAMAS_INSTALADOS=(
#         "git"
#         "python3"
#         "python-is-python3"
#         "python3-pip"
#         "snapd"
#         "spotify"
#         "google"
#         "vscode"
#         "discord"
#         "steam"
#         "OBS"
#         "docker"
#         "docker-compose"
#         "obsidian"
#     )
#
    declare -a INSTALAR_POR_GERENCIADOR=()
    declare -a LISTA_NOMES_PROGRAMAS_INSTALADOS=()
    declare -a VSCODE_EXTENSIONS=(
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

    cria_lista_instalar_por_gerenciador()
    {
        declare -a INSTALAR_POR_GERENCIADOR_AUXILIAR=(
            "git"
            "wget"
            "g++"
            "python3"
            "python3-pip"
            "python-is-python3"
        )
        
        for programa in "${INSTALAR_POR_GERENCIADOR_AUXILIAR[@]}"; do
            if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
                INSTALAR_POR_GERENCIADOR+=("$programa")
                LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
            fi
        done
    }

    cria_lista_instalar_por_gerenciador
    {
        printf "%s\n" "${INSTALAR_POR_GERENCIADOR[@]}"
    } > /tmp/instalar_por_gerenciador.txt

    {
        printf "%s\n" "${LISTA_NOMES_PROGRAMAS_INSTALADOS[@]}"
    } > /tmp/nomes_programas_instalados.txt

    {
        printf "%s\n" "${VSCODE_EXTENSIONS[@]}"
    } > /tmp/vscode_extensions.txt
}
