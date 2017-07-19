FROM ubuntu:16.04
ENV container docker
# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target
CMD ["/sbin/init"]

RUN apt-get update; apt-get -y upgrade
RUN apt-get -y install \
        rsyslog logrotate ssmtp logwatch \
        cron apache2 wget vim openssh-server net-tools

### install certbot (for getting ssl certs with letsencrypt)
RUN wget https://dl.eff.org/certbot-auto; \
    chmod +x certbot-auto ; \
    mv certbot-auto /usr/local/bin/certbot ; \
    certbot --os-packages-only --non-interactive ; \
    certbot --version
