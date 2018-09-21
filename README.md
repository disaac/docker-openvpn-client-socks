# OpenVPN-client

This is a docker image of an OpenVPN client tied to a HTTP proxy server.  I use it to tunnel only my web traffic through my VPN.

This supports directory style (where the certificates are not bundled together in one `.ovpn` file) and those that contains `update-resolv-conf`

## Usage

`/your/openvpn/directory` should contain *one* OpenVPN `.conf` file. It can reference other certificate files or key files in the same directory.

Alternatively, using `docker run` directly:

```bash
docker run -it --device=/dev/net/tun --cap-add=NET_ADMIN \
    --name openvpn-client \
    --volume /your/openvpn/directory/:/etc/openvpn/:ro -p 8118:8118 \
    docker-openvpn-privoxy
```

Then connect to HTTP proxy through through `local.docker:8118`. For example:

```bash
curl --proxy socks5://local.docker:8118 ipinfo.io
```
