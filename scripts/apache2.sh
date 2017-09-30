#!/bin/bash -x

### apache2 modules
a2enmod ssl proxy proxy_http proxy_connect proxy_balancer cache headers rewrite
service apache2 restart
