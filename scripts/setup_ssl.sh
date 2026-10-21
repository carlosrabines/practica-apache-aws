#!/bin/bash

# Carga de variables desde el archivo .env
if [ -f .env ]; then
 export $(cat .env | xargs)
else
 echo "Error: El archivo .env no existe." 
 exit 1
fi

echo "=== Instalando Certbot y generando certificado HTTPS ==="
sudo apt update -y
sudo apt install -y certbot python3-certbot-apache

# Solicitud desatendida del certificado e integración con redirección automática a HTTPS
sudo certbot --apache -d ${DOMAIN} --non-interactive --agree-tos -m ${EMAIL} --redirect

echo "=== Certificado SSL instalado y configurado correctamente ==="
