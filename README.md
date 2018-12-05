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
  --env PROXY_TARGET=http://target:**CONTAINER_PORT** \
  --link **CONTAINER_NAME**:target \
  -p=**PROXY_PORT**:80 \
  fractos/diagnostics-proxy:latest
```

## Proxy traffic going to another host

Replace the following placeholders:

| Placeholder         | Description                                                                                                      |
|---------------------|------------------------------------------------------------------------------------------------------------------|
| **TARGET_BASE_URI** | The base URI of the target you want to proxy, e.g. http://google.com, https://example.org, http://127.0.0.1:5000 |
| **PROXY_PORT**      | The port that you want the proxy to be available as on your machine                                              |
```
docker run -t -i --rm \
  --env PROXY_TARGET=**TARGET_BASE_URI** \
  -p=**PROXY_PORT**:80 \
  fractos/diagnostics-proxy:latest
```
