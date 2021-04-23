# Unifi Controller

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/unifi/status.svg)](https://drone.owncloud.com/owncloud-ops/unifi/)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/unifi)

Docker image for Unifi Controller.

## Ports

Ingress ports for L3 management over the internet

- 3478/udp  (port used for STUN connection)
- 6789/tcp  (port used for UniFi mobile speed test)
- 8080/tcp  (port used for device and controller communication)
- 8443/tcp  (port used for controller GUI/API as seen in a web browser)
- 8880/tcp  (port used for HTTP portal redirection)
- 8843/tcp  (port used for HTTPS portal redirection)

( see: https://help.ui.com/hc/en-us/articles/218506997-UniFi-Ports-Used#2 )

Local ingress ports

- 1900/udp  (port used for "Make controller discoverable on L2 network" in controller settings)
- 3478/udp  (port used for STUN connection)
- 5514/udp  (port used for remote syslog capture)
- 6789/tcp  (port used for UniFi mobile speed test)
- 8080/tcp  (port used for device and controller communication)
- 8443/tcp  (port used for controller GUI/API as seen in a web browser)
- 8880/tcp  (port used for HTTP portal redirection)
- 8843/tcp  (port used for HTTPS portal redirection)
- 27117/tcp (port used for local-bound database communication)
- 5656-5699/udp (ports used for AP-EDU broadcasting)
- 10001/udp (port used for device discovery)

( see: https://help.ui.com/hc/en-us/articles/218506997-UniFi-Ports-Used#1 )

## Volumes

- /opt/app/data
- /opt/app/log
- /opt/app/run

## Environment Variables

```Shell
JAVA_HOME = java
UNIFI_DATA_DIR = /opt/app/data
UNIFI_ENTROPY_GATHER_DEVICE = file:/dev/./urandom
UNIFI_HEALTHCHECK_CODE = 200
UNIFI_HEALTHCHECK_URL = https://localhost:8443
UNIFI_HTTPS_PORT = 8443
UNIFI_HTTP_PORT = 8080
UNIFI_JVM_EXTRA_OPTS =
UNIFI_JVM_INIT_HEAP_SIZE =
UNIFI_JVM_MAX_HEAP_SIZE = 1024M
UNIFI_LOG_DIR = /opt/app/log
UNIFI_MONGODB_EXTRAARGS =
UNIFI_MONGODB_NOJOURNAL =
UNIFI_RUN_DIR = /opt/app/run
UNIFI_SKIP_CHOWN = false
UNIFI_SOURCE_DIR = /opt/app/unifi
```

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=5.14.23 -f Dockerfile -t unifi:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/unifi/blob/master/LICENSE) file for details.
