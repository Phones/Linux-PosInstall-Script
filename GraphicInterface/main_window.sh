#!/bin/bash

MainWindow() {
    # Resposta do usuario
    declare -a resposta=()
    # Construir a lista de opções para o Zenity
    local lista_opcoes=""
    # Caminho para o ícone do programa
    icone_do_programa="Icons/config_linux_icon.png"
    # Array com as opções disponíveis
    declare -a opcoes=(
        "git"
        "wget"
        "g++"
        "python3"
        "python3-pip"
        "python-is-python3"
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

    contruir_lista_opcao() {
        for opcao in "${opcoes[@]}"; do
            lista_opcoes+="TRUE $opcao "
        done
    }

    exibir_janela() {
        # Exibir a janela com as caixas de seleção e obter as opções selecionadas
        resposta=$(
            zenity --list \
            --checklist \
            --column "" \
            --column "Opções" \
            --separator=" " \
            --width=400 \
            --height=600 \
            --title "Selecione as opções" \
            --text "Selecione as opções desejadas:" \
            $lista_opcoes
        )
    }

    lista_de_opcoes_selecionadas() {
        declare -a opcoes_selecionadas=()
        # Verificar se o usuário selecionou alguma opção
        if [ $? -eq 0 ]; then
            # Exibir as opções selecionadas
            for opcao in $resposta; do
                opcoes_selecionadas+=("$opcao")
            done
        else
            echo "Nenhuma opção selecionada."
        fi

        # Retornar a lista de opções selecionadas
        echo "${opcoes_selecionadas[@]}"
    }

    contruir_lista_opcao
    exibir_janela
    lista_de_opcoes_selecionadas
}
