#!/bin/bash

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\e${BLUE}------ ATUALIZANDO O SISTEMA LINUX ------${NC}"

echo -e "\e${GREEN}Executando UPDATE${NC}"
apt-get update

echo -e "\e${GREEN}Executando UPGRADE${NC}"
apt-get upgrade -y

echo -e "\e${BLUE}-----------------------------------------${NC}"



echo -e "\e${GREEN}------ INICIANDO INSTALAÇÃO DO DOCKER ------${NC}"

echo -e "\e${BLUE}Removendo versão antiga do docker${NC}"

{
	apt-get remove docker docker-engine docker.io containerd runc
} || {
	echo -e "\e${BLUE}Não existe versões anteriores para serem removidas${NC}"
}

echo -e "\e${BLUE}Atualizando os pacotes${NC}"
apt-get update


echo -e "\e${BLUE}Instalando os pacotes necessários${NC}"
apt-get install ca-certificates curl gnupg lsb-release -y

echo -e "\e${BLUE}Adicionando Docker GPG key${NC}"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo -e "\e${BLUE}Setando repositorio estavel${NC}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "\e${BLUE}Atualizando os pacotes${NC}"
apt-get update

echo -e "\e${BLUE}Instalando o Docker Engine${NC}"
apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

echo -e "\e${GREEN}Versão do Docker instalada: ${NC}"
docker --version

echo -e "\e${GREEN}Iniciando serviço Docker${NC}"
service docker start

echo -e "\e${GREEN}Instalação do Docker Finalizada!${NC}"
echo -e "\e${GREEN}--------------------------------------------${NC}"

echo -e "\e${GREEN}------ INICIANDO INSTALAÇÃO DO DOCKER COMPOSE ------${NC}"

echo -e "\e${GREEN}Download do Docker Compose${NC}"
curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose

echo -e "\e${GREEN}Setando permição para o Docker compose${NC}"
chmod +x /usr/local/bin/docker-compose

echo -e "\e${GREEN}Instalação do Docker Compose Finalizada!${NC}"

echo -e "\e${GREEN}----------------------------------------------------${NC}"


