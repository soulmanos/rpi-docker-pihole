FROM resin/rpi-raspbian:stretch

LABEL maintainer="soulmanos" \
      version="1"

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install gnupg gpgv libgpg-error0 \
    wget procps manpages net-tools logrotate && \
    apt-get clean

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf.asc /tini.asc
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --verify /tini.asc
RUN chmod +x /tini

ADD install.sh /install.sh
RUN chmod +x /install.sh && sleep 1 && /install.sh

ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 53 53/udp
EXPOSE 80

VOLUME /etc/pihole
VOLUME /var/log

ENTRYPOINT ["/tini", "--"]

CMD ["/sbin/entrypoint.sh"]
