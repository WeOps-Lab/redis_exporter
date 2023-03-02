#
# build container
#
FROM --platform=linux/amd64 golang:1.19-alpine as builder
WORKDIR /
ADD . /

ARG GOARCH

RUN go env -w GOPROXY=https://goproxy.cn
# linux x86
RUN BUILD_DATE=$(date +%F-%T) CGO_ENABLED=0 GOOS=linux GOARCH=$GOARCH go build -o /redis_exporter \
    -ldflags  "-s -w -extldflags \"-static\"  -X main.BuildDate=$BUILD_DATE" .

# linux arm64
RUN BUILD_DATE=$(date +%F-%T) CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o /redis_exporter_arm64 \
    -ldflags  "-s -w -extldflags \"-static\"  -X main.BuildDate=$BUILD_DATE" .

# windows x86
RUN BUILD_DATE=$(date +%F-%T) CGO_ENABLED=0 GOOS=linux GOARCH=windows go build -o /redis_exporter.exe \
    -ldflags  "-s -w -extldflags \"-static\"  -X main.BuildDate=$BUILD_DATE" .

RUN [ "$GOARCH" = $GOARCH ]  && /redis_exporter -version || ls -la /redis_exporter

#
# scratch release container
#
FROM --platform=linux/amd64 scratch as scratch

COPY --from=builder /redis_exporter /redis_exporter

EXPOSE     9121
ENTRYPOINT [ "/redis_exporter" ]
