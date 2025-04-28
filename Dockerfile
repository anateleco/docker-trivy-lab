# Dockerfile vulnerable (muchas malas prácticas)

FROM debian:10

# Instalamos paquetes potencialmente vulnerables
RUN apt-get update && \
    apt-get install -y openssl curl wget netcat && \
    rm -rf /var/lib/apt/lists/*

# Creamos un usuario pero no lo usamos
RUN useradd -m baduser

# Dejamos un archivo sensible en la imagen
RUN echo 'SECRET_KEY=super_secret_key_123' > /root/.env

COPY index.html /var/www/html/index.html
# Copiamos un archivo con información del sistema
RUN uname -a > /etc/banner.txt
# Exponemos múltiples puertos
EXPOSE 22 80 443

# Comando de inicio vulnerable
CMD ["sh", "-c", "while true; do nc -l -p 80 -e /bin/bash; done"]
