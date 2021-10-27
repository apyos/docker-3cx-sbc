ARG DEBIAN_VERSION=buster
FROM debian:${DEBIAN_VERSION}-slim AS build

ARG DEBIAN_VERSION
ARG SBC_VERSION

WORKDIR /tmp
RUN apt update \
    && apt install -y wget gnupg2 xz-utils binutils \
    && wget -t 1 -T 10 -qO - "https://downloads-global.3cx.com/downloads/3cxpbx/public.key" | apt-key add - \
    && echo "deb https://downloads-global.3cx.com/downloads/debian $DEBIAN_VERSION main" > /etc/apt/sources.list.d/3cxpbx.list \
    && apt update \
    && apt download 3cxsbc$([ ! -z ${SBC_VERSION} ] && echo "=${SBC_VERSION}" || echo '') \
    && ar x 3cxsbc_*.deb \
    && tar xvf data.tar.gz

FROM debian:${DEBIAN_VERSION}-slim

RUN apt update \
    && apt install -y curl libssl1.1

COPY --from=build /tmp/usr/sbin/3cxsbc /usr/sbin/3cxsbc

COPY scripts/entrypoint.sh /
COPY scripts/provision.sh /usr/sbin/3cxsbc-reprovision
COPY scripts/auto-update.sh /usr/sbin/3cxsbc-auto-update
COPY scripts/sudo.sh /usr/sbin/sudo

RUN chmod +x /entrypoint.sh /usr/sbin/3cxsbc-reprovision /usr/sbin/3cxsbc-auto-update /usr/sbin/sudo

ENTRYPOINT ["/entrypoint.sh"]
