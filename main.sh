#!/bin/bash

find /home/paulo/Linux-PosInstall-Script -type f -name "*.sh" -exec chmod +x {} \;

source GraphicInterface/main_window.sh
source listas_dados.sh
source install_programs.sh


# Chamar a função da janela principal
opcoes_selecionadas=$(MainWindow)
imcrementa_variavel_progresso 5

# Iniciar o diálogo do Zenity com uma barra de progresso
(
    # Monta as informações das listas
    CreateListsOfPrograms $opcoes_selecionadas

    # Instala os programas
    InstallPrograms

) | zenity --progress --title="Progresso" --text="Processando..." --auto-close

# Exibir uma mensagem quando o código terminar
zenity --info --title="Concluído" --text="O código foi concluído com sucesso!"


pwc "green" "[✔]-- script de instalação finalizado --[✔]"
