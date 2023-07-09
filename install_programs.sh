#!/bin/bash

source helpers.sh

InstallPrograms() {
    declare -a INSTALAR_POR_GERENCIADOR=("$@")
    CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$PWD/Downloads"

    # Criar as listas dos programas que vão ser instalados
    VSCODE_EXTENSIONS=()
    INSTALAR_POR_GERENCIADOR=()
    LISTA_NOMES_PROGRAMAS_INSTALADOS=()
    DOWNLOAD_PROGRAMAS_EXTERNOS=(
        "https://discord.com/api/download?platform=linux&format=deb"
        "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
        "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.3.5/obsidian_1.3.5_amd64.deb"
    )

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
            if ! vertifica_programa_instalado "$program_name"; then
                pwc "blue" "   ---> [instalando] $program_name"
                sudo apt-get install "$program_name" -y
            else
                pwc "green" "   [✔] - $program_name"
            fi
        done
        pwc "green" "Instalação dos programas de gerenciador finalizado"
        # ----------------------------------------------------------------------------------------------------------
    }

    donwload_todos_programas_externos() {
        pwc "blue" "fazendo download de todos os programas externos"
        for program_url in ${DOWNLOAD_PROGRAMAS_EXTERNOS[@]}; do
            wget -c "${program_url}"
        done
        pwc "green" "todos os downloads foram finalizados"
    }

    instala_todos_os_programs_baixados() {
        pwc "blue" "instalando todos os programas baixados"
        dpkg -i $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS/*.deb
    }

    instala_programas_flatpack() {
        flatpak install flathub com.obsproject.Studio -y
    }

    instala_programas_snap() {
        snap install spotify
    }
    
    instala_docker() {
        pwc "blue" "------ INICIANDO INSTALAÇÃO DO DOCKER ------"
        pwc "blue" "Removendo versão antiga do docker"
        {
        	sudo apt-get remove docker docker-engine docker.io containerd runc
        } || {
        	pwc "green" "Não existe versões anteriores para serem removidas"
        }
        sudo apt-get update
        pwc "blue" "Instalando os pacotes necessários"
        sudo apt-get install ca-certificates curl gnupg lsb-release -y

        sudo usermod -aG docker $USER
        curl -fsSL https://get.docker.com | bash
        sudo systemctl enable docker
        pwc "green" "Instalação do Docker Finalizada!"
        pwc "green" "--------------------------------------------"
    }

    instala_docker_compose() {
        pwc "green" "------ INICIANDO INSTALAÇÃO DO DOCKER COMPOSE ------"

        pwc "green" "Download do Docker Compose"
        curl -L "https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

        pwc "green" "Setando permição para o Docker compose"
        chmod +x /usr/local/bin/docker-compose

        pwc "green" "Instalação do Docker Compose Finalizada!"

        pwc "green" "----------------------------------------------------"
    }

    imprime_os_programas_instalados() {
        pwc "green" "programas instalados"
        for program_name in ${LISTA_NOMES_PROGRAMAS_EXTERNOS[@]}; do
            pwc "green" "   [✔] - $program_name"
        done
    }

    update_system
    le_tmp_files
    delete_tmp_files
    instala_os_pacostes_gerenciador_de_pacotes
    update_system
    donwload_todos_programas_externos
    instala_todos_os_programs_baixados
    instala_programas_flatpack
    instala_programas_snap
    update_system
    instala_docker
    instala_docker_compose
}