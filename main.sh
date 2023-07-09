#!/bin/bash

find /home/paulo/Linux-PosInstall-Script -type f -name "*.sh" -exec chmod +x {} \;

source GraphicInterface/main_window.sh
source listas_dados.sh
source install_programs.sh


# Chamar a função da janela principal
opcoes_selecionadas=$(MainWindow)

# Monta as informações das listas
CreateListsOfPrograms $opcoes_selecionadas

# Instala os programas
InstallPrograms

pwc "green" "[✔]-- script de instalação finalizado --[✔]"
