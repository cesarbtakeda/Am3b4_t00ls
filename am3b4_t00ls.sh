#!/bin/bash

echo "


        Am3b4 t00l
"

# Variáveis
url=""
api=""
diretorio=""
https_url=""
c="clear"

# Entrada do usuário
read -p "Qual caminho da pasta deseja salvar?: " diretorio
mkdir -p "$diretorio" || { echo "Erro ao criar o diretório. Saindo."; exit 1; }

read -p "Sua API do WPScan: " api
read -p "Qual a URL completa do site (ex: https://example.com)?: " https_url
read -p "Domínio para o escaneamento (ex: example.com): " url
$c
# Subdomínios
read -p "Deseja buscar por subdomínios antes do scan? [S/N]: " resposta_sub
if [[ "$resposta_sub" =~ ^[Ss]$ ]]; then
  echo "Buscando subdomínios com dnsrato..."
  dnsrato "$url" /usr/share/wordlists/dnsrato/rato.txt > "$diretorio/subdomains.txt"
  echo "[**Busca de subdomínios concluída**]"
  $c
else
  echo "[**Busca de subdomínios ignorada**]"
fi
$c
echo "[**Scaneando, Subdomains aguarde!**]"

# Nmap
echo "[**Iniciando nmap!**]"
sudo nmap -vv -sS -p-65535 -A -sV -Pn -T5 --script=all -g 53 -O --min-rate=450 -e -oN "$diretorio/scan-nmap.txt" "$url"
echo "[**Nmap Finalizado**]"
$c
# Nuclei Paramsider
echo "[**Iniciando nuclei paramsider!**]"
sudo nf -d "$https_url" > "$diretorio/nuclei-vulns.txt"
echo "[**Nuclei paramsider finalizado**]"
$c
# WhatWeb
echo "[**Iniciando whatweb!**]"
sudo whatweb -a3 "$https_url" > "$diretorio/services.txt"
echo "[**WhatWeb finalizado**]"
$c
# Gobuster
echo "Iniciando força bruta de diretórios com Gobuster!"
sudo gobuster dir -u "$https_url" -w /usr/share/wordlists/dirb/common.txt > "$diretorio/directories.txt"
echo "[**Gobuster finalizado**]"
$c
# Whois
echo "[**Iniciando WhoIs!**]"
sudo whois "$url" > "$diretorio/whois.txt"
echo "[**WhoIs finalizado**]"
$c
# Nikto
echo "[**Iniciando Nikto!**]"
sudo nikto -url "$https_url" -C all > "$diretorio/scan-nikto.txt"
echo "[**Nikto finalizado**]"
$c
# Nuclei
echo "[**Iniciando o nuclei!**]"
echo "$https_url" | subfinder -all | nuclei -severity low,medium,high,critical -t ~/.local/nuclei-templates > "$diretorio/nuclei-vulns.txt"
echo "[**Scan do nuclei finalizado**]"
$c
# Criando info.txt
echo "[**Criando arquivo info.txt**]"
touch "$diretorio/info.txt"
echo "[**Arquivo info.txt criado com sucesso!**]"
$c
# Scan do WordPress
read -p "Deseja fazer scan do WordPress (caso exista)? [S/N]: " resposta_wp
if [[ "$resposta_wp" =~ ^[Ss]$ ]]; then
  wpscan --url "$url" --force -e vp,vt,tt,cb,dbe,u,m --rua --api-token "$api" > "$diretorio/wp-scan.txt"
  echo "[**Scan do WordPress concluído**]"
  $c
else
  echo "[**Scan do WordPress ignorado**]"
  $c
fi

# Download do site
read -p "[**Deseja fazer download do site para análise?**] [S/N]: " resposta_download
if [[ "$resposta_download" =~ ^[Ss]$ ]]; then
  wget -m "$https_url" -P "$diretorio/site-mirror"
  echo "[**Download do site concluído**]"
$c
else
  echo "[**Download do site ignorado**]"
fi
 $c
echo "[**SCAN FINALIZADO**]. Obrigado por utilizar a Am3b4_t00ls!"
