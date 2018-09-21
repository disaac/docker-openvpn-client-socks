# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs
# See `start` in same repo for more ideas

FROM alpine

EXPOSE 8118

COPY service /etc/service/

RUN true \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update-cache openvpn bash openresolv openrc privoxy runit tini \
    && rm -rf /var/cache/apk/* \
    && chmod a+x /etc/service/openvpn/run \
    && chmod a+x /etc/service/privoxy/run \
    && true

ENTRYPOINT ["tini", "--"]
CMD ["runsvdir", "/etc/service"]

