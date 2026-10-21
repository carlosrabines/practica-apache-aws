# Práctica Apache AWS: SSL Let's Encrypt y configuración HTTPS

## Descripción del proyecto

Esta práctica documenta la configuración de un servidor web Apache en una instancia de AWS para servir el sitio mediante HTTPS. El certificado SSL/TLS se obtiene de Let's Encrypt y se integra con Apache utilizando Certbot. El script de instalación automatiza la instalación de Certbot y solicita el certificado para el dominio indicado en `.env`, activando además la redirección de HTTP a HTTPS.

Las configuraciones de Apache incluidas muestran el sitio en los puertos 80 y 443. También se conserva una redirección de la ruta `/fp` a TodoFP y una página de error 404 personalizada (`/404.html`). La protección de un directorio mediante autenticación HTTP Basic y `.htaccess` se documenta en las evidencias; esos archivos y la configuración de autenticación del servidor no forman parte de este repositorio.

## Estructura del repositorio

- `scripts/setup_ssl.sh`: instala Certbot y el complemento de Apache, y solicita el certificado utilizando las variables `DOMAIN` y `EMAIL` del archivo `.env`.
- `000-default.conf`: configuración del VirtualHost HTTP en el puerto 80, con el DocumentRoot `/var/www/html`, registros, página 404 y redirecciones.
- `000-default-le-ssl.conf`: configuración del VirtualHost HTTPS en el puerto 443, con las rutas del certificado y las opciones SSL generadas por Certbot.
- `.env.example`: plantilla de las variables necesarias. Sustituye sus valores por los correspondientes a tu servidor antes de utilizarla.
- `.gitignore`: excluye `.env` y archivos `*.pem` del control de versiones.
- `README.md`: documentación de la práctica.
- `capturas/`: evidencias del funcionamiento y de las comprobaciones realizadas.

## Instrucciones de uso

### Requisitos previos

1. Una instancia de AWS con una distribución basada en Debian/Ubuntu y Apache instalado.
2. Un dominio o nombre DNS dinámico apuntando a la dirección pública de la instancia. La resolución DNS debe estar propagada antes de solicitar el certificado.
3. Reglas de entrada en el grupo de seguridad de AWS que permitan el tráfico TCP por los puertos **80 (HTTP)** y **443 (HTTPS)**.
4. Acceso SSH a la instancia y permisos para ejecutar comandos con `sudo`.

### Configuración e instalación

Desde el directorio raíz del proyecto en el servidor:

1. Crea el archivo de variables locales a partir de la plantilla:

   ```bash
   cp .env.example .env
   ```

2. Edita `.env` y establece el dominio que resuelve a tu instancia y una dirección de correo válida para Let's Encrypt:

   ```dotenv
   DOMAIN=tu-dominio.example
   EMAIL=tu-correo@example.com
   ```

   No compartas ni subas `.env` al repositorio. La plantilla contiene valores de ejemplo que debes revisar y reemplazar.

3. Da permiso de ejecución al script y ejecútalo desde la raíz del proyecto, donde se encuentra `.env`:

   ```bash
   chmod +x scripts/setup_ssl.sh
   ./scripts/setup_ssl.sh
   ```

   El script actualiza los paquetes, instala Certbot y su complemento para Apache, y solicita el certificado para `DOMAIN`. Certbot modifica la configuración de Apache y activa la redirección a HTTPS.

4. Comprueba que Apache está activo y visita `https://tu-dominio.example`. Puedes verificar también la renovación del certificado con:

   ```bash
   sudo certbot renew --dry-run
   ```

### Autenticación con `.htaccess`

La autenticación mostrada en las evidencias es una configuración adicional del servidor y no la instala `setup_ssl.sh`. Para reproducirla, configura Apache para permitir directivas de autenticación en el directorio protegido, crea el archivo de contraseñas con `htpasswd` y añade las directivas `AuthType Basic`, `AuthName`, `AuthUserFile` y `Require valid-user` en el `.htaccess` correspondiente. Limita el acceso a dicho recurso mediante HTTPS, ya que la autenticación Basic no cifra por sí misma las credenciales.

## Evidencias

Las capturas disponibles en `capturas/` son:

1. `01_nslookup.png`: consulta DNS del dominio.
2. `01_nslookup_ant.png`: evidencia adicional de la consulta o estado DNS anterior.
3. `02_certificado_letsencrypt.png`: certificado emitido por Let's Encrypt.
4. `03_pagina_index.png`: página principal servida por HTTPS.
5. `04_error_404.png`: respuesta de error para una ruta inexistente.
6. `05_analisis_logs.png`: consulta de los registros de Apache.
7. `06_htaccess_privado.png`: acceso al recurso protegido mediante autenticación `.htaccess`.

El directorio incluye siete archivos de captura: dos corresponden a DNS y los cinco restantes muestran el certificado, HTTPS, el error 404, los registros y la autenticación.