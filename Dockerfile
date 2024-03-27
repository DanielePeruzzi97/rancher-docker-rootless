# https://github.com/k3s-io/k3s/issues/2054
FROM alpine:3.12 AS alpine
RUN apk -u --no-cache add shadow-uidmap

FROM rancher/k3s:v1.27.12-k3s1

COPY --from=alpine /etc/passwd /etc/group /etc/shadow /etc/subgid /etc/subuid /etc/
COPY --from=alpine /usr/bin/newgidmap /usr/bin/newuidmap /usr/bin/
COPY --from=alpine /lib/ld-musl-x86_64.so.1 /lib/

RUN mkdir -p /var/lib/rancher/k3s \
        && adduser -h /var/lib/rancher/k3s -g k3s -s /bin/false -D -u 1001 -G root k3s \
        && echo k3s:165536:65536 >> /etc/subuid \
        && echo k3s:165536:65536 >> /etc/subgid

RUN chmod g+w /bin/aux
RUN echo F3F79821-80EE-4B43-A4DD-E3DA712CA2BC >/etc/machine-id

USER k3s:root