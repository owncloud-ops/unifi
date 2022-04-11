# unifi

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/unifi/status.svg)](https://drone.owncloud.com/owncloud-ops/unifi/)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/unifi)

Custom container image for [Ubiquiti](https://www.ui.com/) Unifi Controller.

## Ports

For more details see [Unifi Port Usage](https://help.ui.com/hc/en-us/articles/218506997-UniFi-Ports-Used).

- 3478/udp (port used for STUN connection)
- 6789/tcp (port used for UniFi mobile speed test)
- 8080/tcp (port used for device and controller communication)
- 8443/tcp (port used for controller GUI/API as seen in a web browser)

## Volumes

- /opt/app/unifi/data

## Environment Variables

```Shell
UNIFI_DB_HOST=
UNIFI_DB_PORT=27017
UNIFI_DB_NAME=unifi
UNIFI_JVM_EXTRA_OPTS=
UNIFI_JVM_MAX_HEAP_SIZE=1024M
UNIFI_JVM_INIT_HEAP_SIZE=
```

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=5.14.23 -f Dockerfile -t unifi:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/unifi/blob/main/LICENSE) file for details.
