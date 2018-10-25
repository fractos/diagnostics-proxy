#!/bin/bash

# substitute environment variables for PROXY_TARGET_HOST, PROXY_TARGET_PORT and LISTEN_PORT
echo Running environment substitution
envsubst < /etc/nginx/conf.d/mysite.template > /etc/nginx/nginx.conf

echo Starting Nginx
/usr/nginx/sbin/nginx -c /etc/nginx/nginx.conf -g 'daemon off;'

