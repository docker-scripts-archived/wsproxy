About Web Server Proxy
----------------------

If we want to host several domains/subdomains on the same webserver
we can use *name-based virtual hosting*. If we need to host these
domains/subdomains in different webservers, each one in its own
docker container, there is a problem because the ports 80/443 can
be used (exposed to the host) only by one of the containers.

In such a case the *Reverse Proxy* module of apache2 comes to the
rescue. We can have a docker container with apache2 that forwards
all the http requests to the other containers (webservers), behaving
like a kind of http gateway or hub. This is what **wsproxy** does.

Installation
------------

 + First install `ds` (docker scripts):
   https://github.com/docker-scripts/ds#installation

 + Then get wsproxy from github: `ds pull wsproxy`

 + Init a container directory for wsproxy: `ds init wsproxy @wsproxy`

 + Initialize and fix the settings:
   ```
   cd /var/ds/wsproxy/
   vim settings.sh
   ds info
   ```

 + Build image, create the container and configure it:
   ```
   ds build
   ds create
   ds config
   ```

Usage
-----

 + Create the containers of each webserver using commands like this:
   ```
   docker run -d --name=ws1 --hostname=test1.example.org webserver-1
   docker run -d --name=ws2 --hostname=test2.example.org webserver-2
   ```
   Note that no HTTP ports are exposed to the host (for example using options `-p 80:80 -p 443:443`).

 + Add domains for `test1.example.org` and `test2.example.org`:
   ```
   ds domains-add ws1 test1.example.org
   ds domains-add ws2 test2.example.org test3.example.org
   ```

 + To add a domain that is served through ssh tunnel by a remote server:
   ```
   ds sshtunnel-add test4.example.org
   ```
   This will also create the script `sshtunnel-keys/test4.example.org.sh` which can be used
   to establish the tunnel from the remote webserver.

 + Get a letsencrypt.org free SSL cert for the domains:
   ```
   ds get-ssl-cert info@test1.example.org test1.example.org test2.example.org --test
   ds get-ssl-cert info@test1.example.org test1.example.org test2.example.org
   ```


Commands
--------

    domains-add <container> <domain> <domain> ...
         Add one or more domains to the configuration of the web proxy.

    domains-rm <domain> <domain> ...
         Remove one or more domains from the configuration of the web proxy.

    get-ssl-cert <email> <domain>... [-t,--test]
         Get free SSL certificates from letsencrypt.org

    reload
        Update the configuration of apache2 and ssh.

    sshtunnel-add <domain>
        Setup a domain to be served by a remote web server through a ssh tunnel.

    sshtunnel-rm <domain>
        Remove the sshtunnel for a domain.

    update-etc-hosts
        Update the file /etc/hosts inside the wsproxy container.



How it works
------------

HTTP requests for a domain are redirected to HTTPS with a
configuration like this:
```
<VirtualHost *:80>
    ServerName example.org
    ProxyPass /.well-known !
    ProxyPass / http://example.org/
    ProxyPassReverse / http://example.org/
    ProxyRequests off
</VirtualHost>
```

HTTPS requests are forwarded to another webserver/container with a
configuration like this:
```
<VirtualHost _default_:443>
    ServerName example.org
    ProxyPass / https://example.org/
    ProxyPassReverse / https://example.org/

    ProxyRequests off

    SSLEngine on
    SSLCertificateFile     /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile  /etc/ssl/private/ssl-cert-snakeoil.key
    #SSLCertificateChainFile /etc/ssl/certs/ssl-cert-snakeoil.pem

    SSLProxyEngine on
    SSLProxyVerify none
    SSLProxyCheckPeerCN off
    SSLProxyCheckPeerName off

    BrowserMatch "MSIE [2-6]" \
            nokeepalive ssl-unclean-shutdown \
            downgrade-1.0 force-response-1.0
    BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

</VirtualHost>
```

It is important to note that without a line like this on `/etc/hosts`:
`172.17.0.3 example.org`, apache2 would not know where to forward the
request.

Also these apache2 modules have to be enabled:
```
a2enmod ssl proxy proxy_http proxy_connect proxy_balancer cache headers rewrite
```
