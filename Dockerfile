FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests apt-utils && \
    apt-get install -y --no-install-recommends --no-install-suggests wget gpg ca-certificates gettext-base curl && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.puteulanus.com/plus/ubuntu focal nginx-plus" > /etc/apt/sources.list.d/nginx-plus.list && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.puteulanus.com/app-protect/ubuntu focal nginx-plus" > /etc/apt/sources.list.d/nginx-app-protect.list && \
    echo "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://nginx.puteulanus.com/app-protect-security-updates/ubuntu focal nginx-plus" > /etc/apt/sources.list.d/app-protect-security-updates.list && \
    wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null && \
    addgroup --system --gid 101 nginx && \
    adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests nginx-plus app-protect app-protect-attack-signatures \
        nginx-plus-module-xslt nginx-plus-module-geoip nginx-plus-module-image-filter nginx-plus-module-perl nginx-plus-module-njs && \
    apt-get remove --purge -y apt-utils && \
    apt-get remove --purge --auto-remove -y && \
    rm -f /etc/apt/sources.list.d/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    sed -i '1iload_module modules/ngx_http_app_protect_module.so;' nginx.conf && \
    sed -i '/http {/a\    app_protect_enable on;' /etc/nginx/nginx.conf

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
