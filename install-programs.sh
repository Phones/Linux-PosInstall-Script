#!/bin/bash

source listas_dados.sh

# ------------------------------------------------------------

# ------------------  print with color -----------------------
function pwc()
{
    text_color=${1^^}
    text=${2^^}

    echo -e "\e${!text_color} ${text} ${NC}"
}

# ------------------- Atualização do sistema ------------------

function update_system()
{
    pwc "blue" "atualizando o sistema"
    sudo apt-get update -y
    sudo apt-get upgrade -y
}

# -------------------------------------------------------------

update_system

# ---------------- Instala programas que podem ser instalados pelo gerenciador de pacotes ------------------

pwc "blue" "instalando programas via gerenciador de pacotes"
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

# update_system

# # -------------- Faz a instalação dos programas que precisam ser baixados externamente ---------------------
# pwc "blue" "criando e acessando pasta de downloads dos programas externos"
# mkdir $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS

# DOWNLOAD_PROGRAMAS_EXTERNOS=(
#     "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
#     "https://az764295.vo.msecnd.net/stable/da76f93349a72022ca4670c1b84860304616aaa2/code_1.70.0-1659589288_amd64.deb"
#     "https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.deb"
#     "https://objects.githubusercontent.com/github-production-release-asset-2e65be/262342594/97d35eb0-ef50-4623-ab3f-24dbc72fa82c?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220810%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220810T061410Z&X-Amz-Expires=300&X-Amz-Signature=f2a14b22c7d3a9c83d7e248baa374281069d5bc241d087d85f60777e55dcf198&X-Amz-SignedHeaders=host&actor_id=32886272&key_id=0&repo_id=262342594&response-content-disposition=attachment%3B%20filename%3Dobsidian_0.15.9_amd64.deb&response-content-type=application%2Foctet-stream"
# )

# pwc "blue" "fazendo download de todos os programas externos"
# for program_url in ${DOWNLOAD_PROGRAMAS_EXTERNOS[@]}; do
#     wget -c "${program_url}"
# done

# pwc "green" "todos os downloads foram finalizados"

# pwc "blue" "instalando todos os programas baixados"
# dpkg -i $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS/*.deb

# # ----------------------------------------------------------------------------------------------------------

# # ----------------- Instalação de programas via flatpack --------------
# flatpak install flathub com.obsproject.Studio -y
# # ---------------------------------------------------------------------

# # ----------------- Instalação dos pacotes por snap -------------------
# snap install spotify
# # ---------------------------------------------------------------------

# # ----------------- Instalação do Docker e Docker Compose ----------------

# update_system

# pwc "blue" "------ INICIANDO INSTALAÇÃO DO DOCKER ------"

# pwc "blue" "Removendo versão antiga do docker"

# {
# 	sudo apt-get remove docker docker-engine docker.io containerd runc
# } || {
# 	pwc "green" "Não existe versões anteriores para serem removidas"
# }

# sudo apt-get update

# pwc "blue" "Instalando os pacotes necessários"
# sudo apt-get install ca-certificates curl gnupg lsb-release -y

# pwc "blue" "Adicionando Docker GPG key"
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# pwc "blue" "Setando repositorio estavel"
# echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/sudo apt/sources.list.d/docker.list > /dev/null

# pwc "blue" "Atualizando os pacotes"
# sudo apt-get update

# pwc "blue" "Instalando o Docker Engine"
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# pwc "green" "Versão do Docker instalada: "
# docker --version

# pwc "green" "Iniciando serviço Docker"
# service docker start

# pwc "green" "Instalação do Docker Finalizada!"
# pwc "green" "--------------------------------------------"

# pwc "green" "------ INICIANDO INSTALAÇÃO DO DOCKER COMPOSE ------"

# pwc "green" "Download do Docker Compose"
# curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

# pwc "green" "Setando permição para o Docker compose"
# chmod +x /usr/local/bin/docker-compose

# pwc "green" "Instalação do Docker Compose Finalizada!"

# pwc "green" "----------------------------------------------------"

# # ------------------------------------------------------------------------

# # ---------------------------- Atualiza o sistema e executa os comandos de limpeza -------------------------
# sudo apt update && sudo apt dist-upgrade -y
# flatpak update
# sudo apt autoclean
# sudo apt autoremove -y
# rm -rf $CAMINHO_PASTA_DOWNLOADS_PROGRAMAS
# # ----------------------------------------------------------------------------------------------------------

# pwc "green" "programas instalados"
# for program_name in ${LISTA_NOMES_PROGRAMAS_EXTERNOS[@]}; do
#     pwc "green" "   [✔] - $program_name"
# done

# # --------------------- Faz a configuração do VSCode ---------------------
# pwc "blue" "instalando extenções do vscode"
# for vscode_extension_name in ${VSCODE_EXTENSIONS}; do
#     {
#         pwc "blue" "instalando extensão ${vscode_extension_name}"
#         code --install-extension $vscode_extension_name
#     } || {
# 	    pwc "red" "a extensão ${vscode_extension_name} já está instalada"
#     }
# done
# pwc "green" "extensões instaladas"
# #-------------------------------------------------------------------------


# print "green" "[✔] script de instalação finalizado [✔]"
