#!/bin/bash

source helpers.sh

InstallPrograms() {
    CAMINHO_PASTA_DOWNLOADS_PROGRAMAS="$PWD/Downloads/"

    # Criar as listas dos programas que vão ser instalados
    VSCODE_EXTENSIONS=()
    INSTALAR_POR_GERENCIADOR=()
    NOMES_PROGRAMAS_EXTERNOS=()
    DOWNLOAD_PROGRAMAS_EXTERNOS=()
    INSTALL_DOCKER=1
    INSTALL_DOCKER_COMPOSE=1
    INSTALL_SPOTIFY=1
    INSTALL_OBS=1
    INSTALL_EXTENSOES_VSCODE=1

    le_tmp_files() {
        readarray -t VSCODE_EXTENSIONS < $caminho_vscode_tmp_file
        readarray -t INSTALAR_POR_GERENCIADOR < $caminho_instalar_por_gerenciador_file
        readarray -t NOMES_PROGRAMAS_EXTERNOS < $caminho_nomes_programas_externos_file
        readarray -t DOWNLOAD_PROGRAMAS_EXTERNOS < $caminho_programas_externos

        INSTALL_DOCKER=$(<$caminho_docker_file)
        INSTALL_DOCKER_COMPOSE=$(<$caminho_docker_compose_file)
        INSTALL_SPOTIFY=$(<$caminho_spotify_file)
        INSTALL_OBS=$(<$caminho_obs_file)
        INSTALL_EXTENSOES_VSCODE=$(<$caminho_extensoes_vscode_file)
    }

    instala_os_pacostes_gerenciador_de_pacotes() {
        pwc "blue" "instalando programas via gerenciador de pacotes"
        # ---------------- Instala programas que podem ser instalados pelo gerenciador de pacotes ------------------
        for program_name in "${INSTALAR_POR_GERENCIADOR[@]}"; do
            # Verifica se o programa já está instalado
            if ! vertifica_programa_instalado_com_dpkg "$program_name"; then
                pwc "blue" "   ---> [instalando] $program_name"
                echo "$password" | sudo -S apt-get install "$program_name" -y > /dev/null 2> Logs/log_$program_name.txt
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
        echo "$password" | sudo -S dpkg -i $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS*.deb > /dev/null 2> Logs/log_dpkg.txt
    }

    instala_programas_flatpack() {
        if [ "$INSTALL_OBS" -eq 0 ]; then
            pwc "BLUE" "Instalando OBS"
            echo "$password" | sudo -S flatpak install flathub com.obsproject.Studio -y > /dev/null 2> Logs/log_obs.txt
            pwc "green" "OBS Instalado"
        fi
    }

    instala_programas_snap() {
        if [ "$INSTALL_SPOTIFY" -eq 0 ]; then
            pwc "BLUE" "Instalando spotify"
            echo "$password" | sudo -S snap install spotify 2> Logs/log_spotify.txt
            pwc "green" "Spotify instalado"
        fi
    }
    
    instala_docker() {
        if [ "$INSTALL_DOCKER" -eq 0 ]; then
            pwc "blue" "------ INICIANDO INSTALAÇÃO DO DOCKER ------"
            pwc "blue" "Removendo versão antiga do docker"
            {
                echo "$password" | sudo -S apt-get remove docker docker-engine docker.io containerd runc -y > /dev/null 2> Logs/log_remover_docker_antigo.txt
            } || {
                pwc "green" "Não existe versões anteriores para serem removidas"
            }
            sudo apt-get update &>/dev/null
            pwc "blue" "Instalando os pacotes necessários"
            sudo apt-get install ca-certificates curl gnupg lsb-release -y > /dev/null 2> Logs/log_pre_requisitos_docker.txt

            sudo curl -fsSL https://get.docker.com | bash > /dev/null 2> Logs/log_docker.txt
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
            echo "$password" | sudo -S curl -L "https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose > /dev/null 2> Logs/log_docker_compose.txt

            pwc "green" "Setando permição para o Docker compose"
            echo "$password" | sudo -S chmod +x /usr/local/bin/docker-compose

            pwc "green" "Instalação do Docker Compose Finalizada!"

            pwc "green" "----------------------------------------------------"
        fi
    }

    instala_extensoes_vscode() {
        if [ "$INSTALL_EXTENSOES_VSCODE" -eq 0 ]; then
            pwc "BLUE" "Instalando extensoes do vscode"
            for extension in "${VSCODE_EXTENSIONS[@]}"
                do
                    code --install-extension "$extension" > /dev/null 2> Logs/log_estensoes_vscode.txt
                    nome_extensao=$(retorna_nome_da_extensao "$extension")
                    pwc "green" "Extensão [$nome_extensao] instalada[✔]"
                    imcrementa_variavel_progresso 1
                done
            pwc "green" "extensoes Instaladas"
        fi
    }

    imprime_os_programas_instalados() {
        pwc "green" "[✔]-------- Programas instalados -------[✔]"
        # Verifica se os programas instalados por gerenciador foram instalados com sucesso
        for program_name in "${INSTALAR_POR_GERENCIADOR[@]}"; do
            if vertifica_programa_instalado_com_dpkg "$program_name"; then
                local tam=${#program_name}
                local num_espacos=$((29 - tam))
                local espacos=$(printf '%*s' "$num_espacos" '')
                pwc "green" " |    [✔] - $program_name${espacos}|"
            fi
        done

        for program_name in "${NOMES_PROGRAMAS_EXTERNOS[@]}"; do
            if vertifica_programa_instalado_com_which "$program_name"; then
                local tam=${#program_name}
                local num_espacos=$((29 - tam))
                local espacos=$(printf '%*s' "$num_espacos" '')
                pwc "green" " |    [✔] - $program_name${espacos}|"
            fi
        done

        if [ "$INSTALL_OBS" -eq 0 ]; then
            if vertifica_programa_instalado_com_flatpak "com.obsproject.Studio"; then
                local num_espacos=26
                local espacos=$(printf '%*s' "$num_espacos" '')
                pwc "green" " |    [✔] - OBS${espacos}|"
            fi
        fi
        
        if [ "$INSTALL_SPOTIFY" -eq 0 ]; then
            if vertifica_programa_instalado_com_snap "spotify${espacos}|"; then
                local num_espacos=22
                local espacos=$(printf '%*s' "$num_espacos" '')
                pwc "green" " |    [✔] - spotify"
            fi
        fi
        
        if [ "$INSTALL_DOCKER" -eq 0 ]; then
            if vertifica_programa_instalado_com_which "docker"; then
                local num_espacos=23
                local espacos=$(printf '%*s' "$num_espacos" '')
                pwc "green" " |    [✔] - docker${espacos}|"
            fi
        fi
        
        if [ "$INSTALL_DOCKER_COMPOSE" -eq 0 ]; then
            if [ -f "/usr/local/bin/docker-compose" ]; then
                if [ -x "/usr/local/bin/docker-compose" ]; then
                local num_espacos=15
                local espacos=$(printf '%*s' "$num_espacos" '')
                    pwc "green" " |    [✔] - docker-compose${espacos}|"
                fi
            fi
        fi

        if [ "$INSTALL_EXTENSOES_VSCODE" -eq 0 ]; then
            local num_espacos=13
            local espacos=$(printf '%*s' "$num_espacos" '')
            pwc "green" " |    [✔] - extensoes-vscode${espacos}|"
        fi
    }

    update_system
    imcrementa_variavel_progresso 3
    sleep 0.1

    le_tmp_files
    imcrementa_variavel_progresso 1
    sleep 0.1

    delete_tmp_files
    imcrementa_variavel_progresso 1
    sleep 0.1

    instala_os_pacostes_gerenciador_de_pacotes
    imcrementa_variavel_progresso 3
    sleep 0.1

    update_system
    imcrementa_variavel_progresso 1
    sleep 0.1
    
    cria_pasta_download
    imcrementa_variavel_progresso 1
    sleep 0.1

    donwload_todos_programas_externos
    imcrementa_variavel_progresso 3
    sleep 0.1

    instala_todos_os_programs_baixados
    imcrementa_variavel_progresso 1
    sleep 0.1

    update_system
    imcrementa_variavel_progresso 1
    sleep 0.1

    instala_programas_flatpack
    imcrementa_variavel_progresso 1
    sleep 0.1

    instala_programas_snap
    imcrementa_variavel_progresso 1
    sleep 0.1

    update_system
    imcrementa_variavel_progresso 1
    sleep 0.1

    instala_docker
    imcrementa_variavel_progresso 3
    sleep 0.1

    instala_docker_compose
    imcrementa_variavel_progresso 1
    sleep 0.1

    atualiza_tudo_e_limpa_o_sistema
    imcrementa_variavel_progresso 1
    sleep 0.1

    instala_extensoes_vscode
    imcrementa_variavel_progresso 1
    sleep 0.1

    imprime_os_programas_instalados
    imcrementa_variavel_progresso 1
    sleep 0.1
}