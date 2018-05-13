FROM ubuntu:18.04

### install systemd
RUN apt update && \
    apt -y upgrade && \
    apt -y install systemd && \
    systemctl set-default multi-user.target

CMD ["/sbin/init"]
WORKDIR /host

RUN apt -y install rsyslog logrotate ssmtp logwatch cron

RUN apt -y install apache2 wget openssh-server net-tools

### install certbot (for getting ssl certs with letsencrypt)
RUN wget https://dl.eff.org/certbot-auto && \
    chmod +x certbot-auto && \
    mv certbot-auto /usr/local/bin/certbot && \
    certbot --os-packages-only --non-interactive && \
    certbot --version
