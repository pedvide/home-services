FROM msoap/shell2http

# Speedtest Version
ARG SPEEDTEST_VERSION=1.0.0
# Set tarball file URL
ARG TARBALL_URL=https://bintray.com/ookla/download/download_file?file_path=ookla-speedtest-${SPEEDTEST_VERSION}-x86_64-linux.tgz


RUN apk add --no-cache ca-certificates tar tzdata wget \
    && wget -qO- ${TARBALL_URL} | tar -xz -C ./ \
    && apk del tar wget && rm -rf /var/cache/apk/* \
    && chmod +x speedtest && mv speedtest /usr/bin/speedtest

RUN speedtest --accept-gdpr --accept-license

CMD ["-cgi", "/", "echo \"Content-Type: application/json\n\"; speedtest --accept-license --accept-gdpr -f json 2> /dev/null"]
