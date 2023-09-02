FROM docker.io/eclipse-temurin:11-jre@sha256:ee35a3e11c33b48a9d8e57c910b16c71deb45d79046981999ff1e16b96066abf

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="Unifi Controller"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/unifi"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/unifi"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/unifi"

ARG BUILD_VERSION
ARG WAIT_FOR_VERSION
ARG CONTAINER_LIBRARY_VERSION

ENV UNIFI_VERSION="${BUILD_VERSION:-7.4.156}"
# renovate: datasource=github-releases depName=thegeeklab/wait-for
ENV WAIT_FOR_VERSION="${WAIT_FOR_VERSION:-v0.4.2}"
# renovate: datasource=github-releases depName=owncloud-ops/container-library
ENV CONTAINER_LIBRARY_VERSION="${CONTAINER_LIBRARY_VERSION:-v0.1.0}"

ENV TZ=UTC
ENV UNIFI_JVM_INIT_HEAP_SIZE=1024M

ADD overlay /

RUN addgroup --gid 1001 --system unifi && \
    adduser --system --disabled-password --no-create-home --uid 1001 --home /opt/app --shell /sbin/nologin --ingroup unifi --gecos unifi unifi && \
    apt-get update && apt-get install -y wget curl gnupg2 apt-transport-https ca-certificates openssl tzdata \
        libarchive-tools ncat && \
    curl -SsfL -o /usr/local/bin/wait-for "https://github.com/thegeeklab/wait-for/releases/download/${WAIT_FOR_VERSION}/wait-for" && \
    curl -SsfL "https://github.com/owncloud-ops/container-library/releases/download/${CONTAINER_LIBRARY_VERSION}/container-library.tar.gz" | tar xz -C / && \
    chmod 755 /usr/local/bin/wait-for && \
    mkdir -p /opt/app/unifi/logs && \
    mkdir -p /opt/app/unifi/data && \
    mkdir -p /opt/app/unifi/run && \
    UNIFI_VERSION="${UNIFI_VERSION##v}" && \
    echo "Setup Unifi Controller 'v${UNIFI_VERSION}' ..." && \
    curl -SsfL "https://www.ubnt.com/downloads/unifi/${UNIFI_VERSION}/UniFi.unix.zip" | \
        bsdtar -xf - -C /opt/app/unifi -X /.tarignore --strip-components=1 && \
    chown -R unifi:unifi /opt/app/unifi && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME /opt/app/unifi/data

EXPOSE 3478/udp 6789/tcp 8080/tcp 8443/tcp

USER unifi

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR /opt/app/unifi
CMD []
