# diagnostics-proxy

This is a wrapped up version of nginx with openresty that will do extremely basic logging of request contents, including the body of POST requests.

I use it to diagnose request traffic for containers, but it should work as a general proxy as well.

The Lua code came from this gist primarily, though I already had the openresty setup previously: https://gist.github.com/morhekil/1ff0e902ed4de2adcb7a

## Building Docker image

```
docker build -t fractos/diagnostics-proxy .
```

## Proxy traffic going to another container

Replace the following placeholders:

| Placeholder        | Description                                                                                                         |
|--------------------|---------------------------------------------------------------------------------------------------------------------|
| **CONTAINER_NAME** | The Docker container name you wish to proxy                                                                         |
| **CONTAINER_PORT** | The port that the Docker container uses internally (not the one that Docker may map it to, the natural EXPOSE port) |
| **PROXY_PORT**     | The port that you want the proxy to be available as on your machine                                                 |

```
docker run -t -i --rm \
  --env PROXY_TARGET_HOST=target \
  --env PROXY_TARGET_PORT=**CONTAINER_PORT** \
  --link **CONTAINER_NAME**:target \
  -p=**PROXY_PORT**:80 \
  fractos/diagnostics-proxy:latest
```

## Proxy traffic going to another host

Replace the following placeholders:

| Placeholder     | Description                                                         |
|-----------------|---------------------------------------------------------------------|
| **TARGET_HOST** | The host that you wish to proxy                                     |
| **TARGET_PORT** | The port on the target host that you with to proxy                  |
| **PROXY_PORT**  | The port that you want the proxy to be available as on your machine |

```
docker run -t -i --rm \
  --env PROXY_TARGET_HOST=**TARGET_HOST** \
  --env PROXY_TARGET_PORT=**TARGET_PORT** \
  -p=**PROXY_PORT**:80 \
  fractos/diagnostics-proxy:latest
```
