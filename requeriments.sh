#!/bin/bash

echo " "
echo "Atualizando arquivos..."
sudo apt update -y && sudo apt upgrade -y
echo " 
[**Atualização completa**] 

"
echo "Baixando dependências do Ameba...

"

# Instalação de pacotes
sudo apt install -y \
  python3-pip \
  python2 \
  python3 \
  git \
  nmap \
  nikto \
  whatweb \
  nuclei \
  subfinder \
  gobuster \
  python3 \
  wpscan \
  wget \
  whois
echo "

"  

#Instalando uro
echo "Fazendo o donwload do uro."
sudo pip3 install uro --break-system-packages
echo "
[**Download do uro finalizado!**]

"
# Clonando repositório NucleiFuzzer e executando instalação
if [ ! -d "NucleiFuzzer" ]; then
  sudo git clone https://github.com/0xKayala/NucleiFuzzer.git
  cd NucleiFuzzer
  sudo chmod +x install.sh && ./install.sh
  cd ..
else
  echo "[**Repositório NucleiFuzzer já clonado.**]"
fi

echo " 

"
echo "[**Dependências baixadas com sucesso**]"

echo "
 
"
echo "Atualizando pacotes adicionais..."
sudo apt-get update -y && sudo apt-get full-upgrade -y
echo "[**A atualização foi concluída com sucesso**]"
