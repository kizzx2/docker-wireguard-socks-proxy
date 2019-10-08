# docker-wireguard-socks-proxy

Expose WireGuard as a SOCKS5 proxy in a Docker container.

(For the same thing in OpenVPN, see [kizzx2/docker-openvpn-client-socks](https://github.com/kizzx2/docker-openvpn-client-socks))

## Why?

This is arguably the easiest way to achieve "app based" routing. For example, you may only want certain applications to go through your WireGuard tunnel while the rest of your system should go through the default gateway. You can also achieve "domain name based" routing by using a [PAC file](https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file) that most browsers support.

## Usage

Preferably, using `start` in this repository:
```bash
bash start.sh /directory/containing/your/wireguard/conf/file
```

Alternatively, you can use `docker run` directly if you want to customize things such as port mapping:

```bash
docker run -it --rm --cap-add=NET_ADMIN \
    --name wireguard-socks-proxy \
    --volume /directory/containing/your/wireguard/conf/file/:/etc/openvpn/:ro \
    -p 1080:1080 \
    kizzx2/wireguard-socks-proxy
```

Then connect to SOCKS proxy through through `127.0.0.1:1080` (or `local.docker:1080` for Mac / docker-machine / etc.). For example:

```bash
curl --proxy socks5h://127.0.0.1:1080 ipinfo.io
```

## HTTP Proxy

You can easily convert this to an HTTP proxy using [http-proxy-to-socks](https://github.com/oyyd/http-proxy-to-socks), e.g.

```bash
hpts -s 127.0.0.1:1080 -p 8080
```

## Troubleshooting

### I get "Permission Denied"

This can happen if your WireGuard configuration file includes an IPv6 address but your host interface does not work with it. Try removing the IPv6 address in `Address` from your configuration file.
