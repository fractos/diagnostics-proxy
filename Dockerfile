FROM ubuntu:xenial

RUN apt-get update -y \
    && apt-get install -y wget libncurses5 libpcre3 libssl1.0.0 groff build-essential gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# openresty
COPY ./openresty.tar.gz .
RUN tar -xzvf openresty.tar.gz

# nginx modules
RUN wget https://github.com/pintsized/lua-resty-http/archive/v0.09.tar.gz
RUN tar -xzvf v0.09.tar.gz
RUN mv lua-resty-http-0.09/lib/resty/http.lua /usr/lualib/resty/.
RUN mv lua-resty-http-0.09/lib/resty/http_headers.lua /usr/lualib/resty/.

# library path fixes
RUN ldconfig

# nginx resources
RUN useradd -U -M nginx
RUN mkdir -p /etc/nginx

RUN mkdir -p /var/log/nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stdout /var/log/nginx/error.log

ENV LISTEN_PORT 80
ENV PROXY_TARGET http://127.0.0.1:5000

COPY run.sh /
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

COPY etc/nginx.conf /etc/nginx/conf.d/mysite.template

