include(bionic)

RUN apt install -y apache2 wget openssh-server net-tools

### install certbot (for getting ssl certs with letsencrypt)
RUN wget https://dl.eff.org/certbot-auto && \
    chmod +x certbot-auto && \
    mv certbot-auto /usr/local/bin/certbot && \
    certbot --os-packages-only --non-interactive && \
    certbot --version
