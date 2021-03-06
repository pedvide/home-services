FROM arm32v6/alpine:3.12

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf
RUN apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata && \
    update-ca-certificates

RUN set -ex && \
    mkdir ~/.gnupg; \
    echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf; \
    apk add --no-cache --virtual .build-deps wget gnupg tar && \
    for key in \
        05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; \
    do \
        gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
        gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
    done

ENV TELEGRAF_VERSION 1.15.3
RUN wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz.asc && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz && \
    gpg --batch --verify telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz.asc telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz

RUN mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}_linux_armhf.tar.gz && \
    mv /usr/src/telegraf*/etc/telegraf/telegraf.conf /etc/telegraf/ && \
    mkdir /etc/telegraf/telegraf.d && \
    cp -a /usr/src/telegraf*/usr/bin/telegraf /usr/bin/ && \
    gpgconf --kill all && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg && \
    apk del .build-deps

EXPOSE 8125/udp 8092/udp 8094

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]

# build:  docker build -t telegraf-armhf .
# run: docker run -d --user "$(id -u telegraf)":"$(getent group docker | cut -d: -f3)" --name=telegraf  \
#  --restart=always 
#  -e HOST_HOSTNAME=`hostname` \
#  -e HOST_MOUNT_PREFIX=/hostfs -v /:/hostfs:ro \
#  -e HOST_PROC=/hostfs/proc  \
#  -e HOST_SYS=/hostfs/sys \
#  -e HOST_VAR=/hostfs/var \
#  -v /var/run/docker.sock:/var/run/docker.sock \ 
#  -v /etc/telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
#  telegraf-armhf
