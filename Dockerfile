FROM alpine:latest

RUN sed -i 's@dl-cdn.alpinelinux.org/alpine@alpine.mirror.wearetriple.com@g' /etc/apk/repositories
RUN echo "@testing https://alpine.mirror.wearetriple.com/edge/testing/" >> /etc/apk/repositories
RUN echo "@main https://alpine.mirror.wearetriple.com/edge/main/" >> /etc/apk/repositories
RUN echo "@community https://alpine.mirror.wearetriple.com/edge/community/" >> /etc/apk/repositories

RUN apk add --no-cache \
        bash@main \
        bind-tools@main \
        dante-server@community \
        iptables@main \
        openvpn@main \
        nftables@main \
        shadow@community  \
        tinyproxy@main

COPY data/ /data/

ENV KILL_SWITCH=iptables
ENV USE_VPN_DNS=on
ENV VPN_LOG_LEVEL=3
ENV HTTP_PROXY=1
ENV SOCKS_PROXY=1

ARG BUILD_DATE
ARG IMAGE_VERSION

LABEL build-date=$BUILD_DATE
LABEL image-version=$IMAGE_VERSION

HEALTHCHECK CMD ping -c 3 1.1.1.1 || exit 1

WORKDIR /data

ENTRYPOINT [ "scripts/entry.sh" ]
