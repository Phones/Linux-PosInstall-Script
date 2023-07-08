#!/bin/bash

find /home/paulo/Linux-PosInstall-Script -type f -name "*.sh" -exec chmod +x {} \;

source GraphicInterface/main_window.sh

# Chamar a função da janela principal
opcoes_selecionadas=$(MainWindow)

# Imprime a lista de opções selecionadas
echo $opcoes_selecionadas



