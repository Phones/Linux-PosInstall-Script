#!/bin/bash

find /home/paulo/Linux-PosInstall-Script -type f -name "*.sh" -exec chmod +x {} \;

source GraphicInterface/main_window.sh
source listas_dados.sh
source install_programs.sh

sudo apt-get update > /dev/null 2> Logs/log_update0.txt

# Chamar a função da janela principal
opcoes_selecionadas=$(MainWindow)

# Iniciar o diálogo do Zenity com uma barra de progresso
(
    # inicia a barra aqui (progresso update)
    imcrementa_variavel_progresso 1
    sleep 0.1

    # inicia a barra aqui (progresso mainwindow)
    imcrementa_variavel_progresso 1
    sleep 0.1

    # Monta as informações das listas
    CreateListsOfPrograms $opcoes_selecionadas

    # Instala os programas
    InstallPrograms

) | zenity --progress --title="Progresso" --text="Processando..." --auto-close

# Exibir uma mensagem quando o código terminar
zenity --info --title="Concluído" --text="O código foi concluído com sucesso!"


pwc "green" "[✔]-- script de instalação finalizado --[✔]"
