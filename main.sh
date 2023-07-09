#!/bin/bash

find /home/paulo/Linux-PosInstall-Script -type f -name "*.sh" -exec chmod +x {} \;

source GraphicInterface/main_window.sh
source listas_dados.sh

# Criar as listas dos programas que vão ser instalados
VSCODE_EXTENSIONS=()
INSTALAR_POR_GERENCIADOR=()
LISTA_NOMES_PROGRAMAS_INSTALADOS=()

# Chamar a função da janela principal
opcoes_selecionadas=$(MainWindow)

# Monta as informações das listas
CreateListsOfPrograms $opcoes_selecionadas

readarray -t VSCODE_EXTENSIONS < $caminho_vscode_tmp_file
readarray -t INSTALAR_POR_GERENCIADOR < $caminho_instalar_por_gerenciador_file
readarray -t LISTA_NOMES_PROGRAMAS_INSTALADOS < $caminho_nomes_programas_instalados_file

delete_tmp_files

echo "-----------------------"
# Exibir o conteúdo do array
for elemento in "${INSTALAR_POR_GERENCIADOR[@]}"; do
    echo "$elemento"
done


# # Imprime a lista de opções selecionadas
# echo teste1

# echo teste

# # ------------------------------------------------------------

# # ------------------  print with color -----------------------
# function pwc()
# {
#     text_color=${1^^}
#     text=${2^^}

#     echo -e "\e${!text_color} ${text} ${NC}"
# }

# # ------------------- Atualização do sistema ------------------

# function update_system()
# {
#     pwc "blue" "atualizando o sistema"
#     sudo apt-get update -y
#     sudo apt-get upgrade -y
# }

# # -------------------------------------------------------------

# update_system

# # ---------------- Instala programas que podem ser instalados pelo gerenciador de pacotes ------------------

# pwc "blue" "instalando programas via gerenciador de pacotes"
# for program_name in ${INSTALAR_POR_GERENCIADOR[@]}; do
#     # Verifica se o programa já está instalado
#     if ! dpkg -l | grep -q $program_name; then
#         pwc "blue" "   ---> [instalando] $program_name"
#         sudo apt-get install "$program_name" -y
#     else
#         pwc "green" "   [✔] - $program_name"
#     fi
# done
# pwc "green" "Instalação dos programas de gerenciador finalizado"
