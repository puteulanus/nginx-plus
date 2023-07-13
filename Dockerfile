FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y wget gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.puteulanus.com/plus/ubuntu focal nginx-plus" > /etc/apt/sources.list.d/nginx-plus.list && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.puteulanus.com/app-protect/ubuntu focal nginx-plus" > /etc/apt/sources.list.d/nginx-app-protect.list && \
    echo "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://nginx.puteulanus.com/app-protect-security-updates/ubuntu focal nginx-plus" > /etc/apt/sources.list.d/app-protect-security-updates.list && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null && \
    apt-get update && \
    apt-get install -y nginx-plus app-protect app-protect-attack-signatures
CMD ["nginx", "-g", "daemon off;"]
