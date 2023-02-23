CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build  -o weops_redis_exporter main.go
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build  -o weops_redis_exporter.exe main.go
CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build  -o weops_redis_exporter_arm64 main.go