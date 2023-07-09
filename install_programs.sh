#!/bin/bash

source helpers.sh

InstallPrograms() {
    declare -a INSTALAR_POR_GERENCIADOR=("$@")

    # Criar as listas dos programas que vão ser instalados
    VSCODE_EXTENSIONS=()
    INSTALAR_POR_GERENCIADOR=()
    LISTA_NOMES_PROGRAMAS_INSTALADOS=()

    le_tmp_files() {
        readarray -t VSCODE_EXTENSIONS < $caminho_vscode_tmp_file
        readarray -t INSTALAR_POR_GERENCIADOR < $caminho_instalar_por_gerenciador_file
        readarray -t LISTA_NOMES_PROGRAMAS_INSTALADOS < $caminho_nomes_programas_instalados_file
    }

    instala_os_pacostes_gerenciador_de_pacotes() {
        pwc "blue" "instalando programas via gerenciador de pacotes"
        # ---------------- Instala programas que podem ser instalados pelo gerenciador de pacotes ------------------
        for program_name in ${INSTALAR_POR_GERENCIADOR[@]}; do
            # Verifica se o programa já está instalado
            if ! dpkg -l | grep -q $program_name; then
                pwc "blue" "   ---> [instalando] $program_name"
                sudo apt-get install "$program_name" -y
            else
                pwc "green" "   [✔] - $program_name"
            fi
        done
        pwc "green" "Instalação dos programas de gerenciador finalizado"
        # ----------------------------------------------------------------------------------------------------------
    }

    update_system
    le_tmp_files
    delete_tmp_files
    instala_os_pacostes_gerenciador_de_pacotes
}