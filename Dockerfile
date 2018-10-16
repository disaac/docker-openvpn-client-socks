# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs
# See `start` in same repo for more ideas

FROM alpine

EXPOSE 8118

COPY sockd.sh /usr/local/bin/
COPY start_blackvpn.sh /usr/local/bin/
ADD config /etc/privoxy/

ENV BLACKVPN_USER my.blackvpn.username
ENV BLACKVPN_PASS my.blackvpn.password
ENV BLACKVPN_CONF random
ENV OVERRIDE_BVPN false

RUN true \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update-cache openvpn bash openssl ca-certificates privoxy \
    && wget -O /tmp/blackvpn_linux.zip 'https://www.blackvpn.com/download/3981/' \
    && unzip /tmp/blackvpn_linux.zip -d /tmp/ && mv /tmp/blackvpn_linux/* /etc/openvpn/ \
    && chmod 0644 /etc/openvpn/*.conf && chmod 0600 /etc/openvpn/ssl/*.key \
    && sed -i '/^up .*/d;/^down .*/d' /etc/openvpn/*.conf \
    && rm -rf /var/cache/apk/* \
    && chmod a+x /usr/local/bin/sockd.sh \
    && chmod a+x /usr/local/bin/start_blackvpn.sh \
    && true

COPY sockd.conf /etc/

ENTRYPOINT [ \
    "/bin/bash", "-c", \
    "/usr/local/bin/start_blackvpn.sh"]
