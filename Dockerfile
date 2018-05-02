FROM resin/rpi-raspbian:stretch

LABEL maintainer="soulmanos" \
      version="1"

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install gnupg gpgv libgpg-error0 \
    wget procps manpages net-tools logrotate && \
    apt-get clean

ADD install.sh /install.sh
RUN chmod +x /install.sh && sleep 1 && /install.sh

ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 53 53/udp
EXPOSE 80

VOLUME /etc/pihole
VOLUME /var/log

CMD ["/sbin/entrypoint.sh"]
