#!/bin/bash

source helpers.sh

CreateListsOfPrograms() {
    # Pega a lista de opções que o usuario selecionou
    declare -a opcoes_selecionadas=("$@")

    declare -A links_download
    links_download["google"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    links_download["vscode"]="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    links_download["discord"]="https://discord.com/api/download?platform=linux&format=deb"
    links_download["obsidian"]="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.3.5/obsidian_1.3.5_amd64.deb"

    local INSTALL_DOCKER=1
    local INSTALL_DOCKER_COMPOSE=1
    local INSTALL_SPOTIFY=1
    local INSTALL_OBS=1
    declare -a DOWNLOAD_PROGRAMAS_EXTERNOS=()
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
            "snapd"
        )
        
        for programa in "${INSTALAR_POR_GERENCIADOR_AUXILIAR[@]}"; do
            if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
                INSTALAR_POR_GERENCIADOR+=("$programa")
                LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
            fi
        done
    }

    cria_lista_instalar_programas_externos() {
        declare -a DOWNLOAD_PROGRAMAS_EXTERNOS_AUXILIAR=(
            "google"
            "vscode"
            "discord"
            "obsidian"
        )

        for programa in "${DOWNLOAD_PROGRAMAS_EXTERNOS_AUXILIAR[@]}"; do
            if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
                DOWNLOAD_PROGRAMAS_EXTERNOS+=("${links_download[$programa]}")
                LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
            fi
        done
    }

    verifica_instalar_docker() {
        local programa="docker"

        if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
            INSTALL_DOCKER=0
            LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
        fi
    }

    verifica_instalar_docker_compose() {
        local programa="docker-compose"

        if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
            INSTALL_DOCKER_COMPOSE=0
            LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
        fi
    }

    verifica_instalar_obs() {
        local programa="OBS"

        if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
            INSTALL_OBS=0
            LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
        fi
    }

    verifica_instalar_spotify() {
        local programa="spotify"

        if verificarStringNaLista "$programa" "${opcoes_selecionadas[@]}"; then
            INSTALL_SPOTIFY=0
            LISTA_NOMES_PROGRAMAS_INSTALADOS+=("$programa")
        fi
    }
    cria_lista_instalar_por_gerenciador
    cria_lista_instalar_programas_externos
    verifica_instalar_docker
    verifica_instalar_docker_compose
    verifica_instalar_obs
    verifica_instalar_spotify

    {
        printf "%s\n" "${INSTALAR_POR_GERENCIADOR[@]}"
    } > $caminho_instalar_por_gerenciador_file

    {
        printf "%s\n" "${LISTA_NOMES_PROGRAMAS_INSTALADOS[@]}"
    } > $caminho_nomes_programas_instalados_file

    {
        printf "%s\n" "${VSCODE_EXTENSIONS[@]}"
    } > $caminho_vscode_tmp_file

    printf "%s\n" "${DOWNLOAD_PROGRAMAS_EXTERNOS[@]}" > $caminho_programas_externos
    # ------------------------------------------------------------
    {
        printf "%s\n" "$INSTALL_DOCKER"
    } > $caminho_docker_file

    {
        printf "%s\n" "$INSTALL_DOCKER_COMPOSE"
    } > $caminho_docker_compose_file

    {
        printf "%s\n" "$INSTALL_SPOTIFY"
    } > $caminho_spotify_file

    {
        printf "%s\n" "$INSTALL_OBS"
    } > $caminho_obs_file
}
