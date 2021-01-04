FROM debian:buster-slim

ENV INSTALL_KEY=379CE192D401AB61
ENV DEB_DISTRO=bionic

RUN apt update && apt install -y \
    gnupg1 apt-transport-https dirmngr wget \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY
RUN echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" >> /etc/apt/sources.list.d/speedtest.list
RUN apt update && apt install -y \
    speedtest \
    && rm -rf /var/lib/apt/lists/*

RUN wget 'https://github.com/msoap/shell2http/releases/download/1.13/shell2http-1.13.linux.amd64.tar.gz' \
    && tar -xvf shell2http-1.13.linux.amd64.tar.gz \
    && rm LICENSE README.md shell2http.1 \
    && chmod +x shell2http

RUN speedtest --accept-gdpr --accept-license
#CMD shell2http -cgi / 'echo "Content-Type: application/json"; echo; echo "{\"date\": \"$(date)\"}"'
ENV SPEEDTEST="speedtest --accept-license --accept-gdpr -f json 2> /dev/null"
RUN echo "$(SPEEDTEST)"
CMD ./shell2http -cgi / 'echo "Content-Type: application/json"; echo; echo "${SPEEDTEST}"'

