#!/bin/bash

source helpers.sh

InstallPrograms() {
    declare -a INSTALAR_POR_GERENCIADOR=("$@")
    CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$PWD/Downloads/"

    # Criar as listas dos programas que vão ser instalados
    VSCODE_EXTENSIONS=()
    INSTALAR_POR_GERENCIADOR=()
    LISTA_NOMES_PROGRAMAS_INSTALADOS=()
    DOWNLOAD_PROGRAMAS_EXTERNOS=()
    INSTALL_DOCKER=1
    INSTALL_DOCKER_COMPOSE=1
    INSTALL_SPOTIFY=1
    INSTALL_OBS=1

    le_tmp_files() {
        readarray -t VSCODE_EXTENSIONS < $caminho_vscode_tmp_file
        readarray -t INSTALAR_POR_GERENCIADOR < $caminho_instalar_por_gerenciador_file
        readarray -t LISTA_NOMES_PROGRAMAS_INSTALADOS < $caminho_nomes_programas_instalados_file
        readarray -t DOWNLOAD_PROGRAMAS_EXTERNOS < $caminho_programas_externos

        INSTALL_DOCKER=$(<$caminho_docker_file)
        INSTALL_DOCKER_COMPOSE=$(<$caminho_docker_compose_file)
        INSTALL_SPOTIFY=$(<$caminho_spotify_file)
        INSTALL_OBS=$(<$caminho_obs_file)
    }

    instala_os_pacostes_gerenciador_de_pacotes() {
        pwc "blue" "instalando programas via gerenciador de pacotes"
        # ---------------- Instala programas que podem ser instalados pelo gerenciador de pacotes ------------------
        for program_name in ${INSTALAR_POR_GERENCIADOR[@]}; do
            # Verifica se o programa já está instalado
            if ! vertifica_programa_instalado "$program_name"; then
                pwc "blue" "   ---> [instalando] $program_name"
                sudo apt-get install "$program_name" -y > /dev/null 2> Logs/erro_$program_name.txt
            else
                pwc "green" "   [✔] - $program_name"
            fi
        done
        pwc "green" "Instalação dos programas de gerenciador finalizado"
        # ----------------------------------------------------------------------------------------------------------
    }

    donwload_todos_programas_externos() {
        pwc "blue" "fazendo download de todos os programas externos"
        for program_url in "${DOWNLOAD_PROGRAMAS_EXTERNOS[@]}"; do
            string_aleatoria=$(date +%s | sha256sum | head -c 10)
            wget -c -q --show-progress -P $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS -O "$CAMINHO_PASTA_DOWNLOADS_PROGRAMAS$string_aleatoria".deb "${program_url}"
        done
        pwc "green" "todos os downloads foram finalizados"
    }

    instala_todos_os_programs_baixados() {
        pwc "blue" "instalando todos os programas baixados"
        sudo dpkg -i $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS*.deb
    }

    instala_programas_flatpack() {
        if [ "$INSTALL_OBS" -eq 0 ]; then
            pwc "BLUE" "Instalando OBS"
            flatpak install --progress flathub com.obsproject.Studio -y > /dev/null 2> Logs/erro_obs.txt
            pwc "green" "OBS Instalado"
        fi
    }

    instala_programas_snap() {
        if [ "$INSTALL_SPOTIFY" -eq 0 ]; then
            pwc "BLUE" "Instalando spotify"
            snap install spotify 2> Logs/erro_spotify.txt
            pwc "green" "Spotify instalado"
        fi
    }
    
    instala_docker() {
        if [ "$INSTALL_DOCKER" -eq 0 ]; then
            pwc "blue" "------ INICIANDO INSTALAÇÃO DO DOCKER ------"
            pwc "blue" "Removendo versão antiga do docker"
            {
                sudo apt-get remove docker docker-engine docker.io containerd runc
            } || {
                pwc "green" "Não existe versões anteriores para serem removidas"
            }
            sudo apt-get update &>/dev/null
            pwc "blue" "Instalando os pacotes necessários"
            sudo apt-get install ca-certificates curl gnupg lsb-release -y > /dev/null 2> Logs/erro_docker.txt

            sudo curl -fsSL https://get.docker.com | bash
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            pwc "green" "Instalação do Docker Finalizada!"
            pwc "green" "--------------------------------------------"
        fi
    }

    instala_docker_compose() {
        if [ "$INSTALL_DOCKER_COMPOSE" -eq 0 ]; then
            pwc "green" "------ INICIANDO INSTALAÇÃO DO DOCKER COMPOSE ------"

            pwc "green" "Download do Docker Compose"
            sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose > /dev/null 2> Logs/erro_docker_compose.txt

            pwc "green" "Setando permição para o Docker compose"
            sudo chmod +x /usr/local/bin/docker-compose

            pwc "green" "Instalação do Docker Compose Finalizada!"

            pwc "green" "----------------------------------------------------"
        fi
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
    cria_pasta_download
    donwload_todos_programas_externos
    instala_todos_os_programs_baixados
    update_system
    instala_programas_flatpack
    instala_programas_snap
    update_system
    instala_docker
    instala_docker_compose
    atualiza_tudo_e_limpa_o_sistema
}