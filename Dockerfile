FROM alpine:3.13@sha256:69e70a79f2d41ab5d637de98c1e0b055206ba40a8145e7bddb55ccc04e13cf8f

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="Unifi Controller"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/unifi"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/unifi"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/unifi"

ARG BUILD_VERSION
ARG GOMPLATE_VERSION
ARG WAIT_FOR_VERSION

ENV UNIFI_VERSION="${BUILD_VERSION:-5.14.23}"
# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION="${GOMPLATE_VERSION:-v3.9.0}"
# renovate: datasource=github-releases depName=thegeeklab/wait-for
ENV WAIT_FOR_VERSION="${WAIT_FOR_VERSION:-v0.1.0}"

ENV TZ=UTC

ADD overlay /

RUN apk --update --no-cache add bash ca-certificates gettext asciidoc \
    git git-lfs gnupg openssh-keygen

RUN addgroup -g 1001 -S unifi && \
    adduser -S -D -H -u 1001 -h /opt/app -s /bin/bash -G unifi -g unifi unifi

RUN apk --update add --virtual .build-deps curl libarchive-tools tar && \
    apk --update add binutils coreutils curl libcap openjdk8-jre openssl shadow su-exec tzdata && \
    curl -SsL -o /usr/local/bin/gomplate "https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim" && \
    curl -SsL -o /usr/local/bin/wait-for "https://github.com/thegeeklab/wait-for/releases/download/${WAIT_FOR_VERSION}/wait-for" && \
    chmod 755 /usr/local/bin/gomplate && \
    chmod 755 /usr/local/bin/wait-for && \
    mkdir -p /opt/app/unifi/logs && \
    mkdir -p /opt/app/unifi/data && \
    mkdir -p /opt/app/unifi/run && \
    UNIFI_VERSION="${UNIFI_VERSION##v}" && \
    echo "Setup Unifi Controller v'${UNIFI_VERSION}' ..." && \
    curl -SsL "https://www.ubnt.com/downloads/unifi/${UNIFI_VERSION}/UniFi.unix.zip" | \
        bsdtar -xf - -C /opt/app/unifi -X /.tarignore --strip-components=1 && \
    chown -R unifi:unifi /opt/app/unifi && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/*

EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp

USER unifi

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR /opt/app/unifi
CMD []
