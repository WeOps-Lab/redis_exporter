#
# build container
#
FROM --platform=linux/amd64 golang:1.19-alpine as builder
WORKDIR /

COPY redis_exporter /redis_exporter

EXPOSE     9121
ENTRYPOINT [ "/redis_exporter" ]
