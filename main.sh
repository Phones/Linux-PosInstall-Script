#!/bin/bash

find /home/paulo/Linux-PosInstall-Script -type f -name "*.sh" -exec chmod +x {} \;

source GraphicInterface/main_window.sh
source listas_dados.sh
source install_programs.sh

# Solicita senha para o usuario
password=$(zenity --password --title="Digite a senha do usuário")

# Seta a senha no stdin, para que seja possivel ler a senha da entrada principa, sem solicitar ela novamente
echo $password | sudo -Sv

pwc "BLUE" "Atualizando pacotes"
echo $password | sudo -S apt-get update > /dev/null 2> Logs/log_update0.txt

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

) 3>&1 1>&2 | zenity --progress --title="Progresso" --text="Processando..." --auto-close

pwc "green" "[✔]-- script de instalação finalizado --[✔]"

# Exibir uma mensagem quando o código terminar
zenity --info --title="Concluído" --text="O código foi concluído com sucesso!"
