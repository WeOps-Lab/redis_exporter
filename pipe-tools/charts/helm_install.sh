#!/bin/bash

# 部署监控对象
redis_versions=("7.0" "6.0" "5.0" "4.0.14" "3.2.9-r3")
redis_architectures=("standalone")

for version in "${redis_versions[@]}"; do
  for architecture in "${redis_architectures[@]}"; do
    version_suffix="v${version%%.*}"

    if [[ "$architecture" == "standalone" ]]; then
      helm install redis-$architecture-$version_suffix --namespace redis \
      --set image.tag=$version \
      --set global.redis.password='weops' \
      --set master.podLabels.object='redis' \
      --set commonLabels.object='redis' \
      --set redis.podLabels.object='redis' \
      --set redis.podLabels.object_version=$version_suffix \
      --set master.persistence.enabled=false \
      --set persistence.enabled=false \
      --set architecture=$architecture \
      --set master.sidecars[0].name=redis-benchmark \
      --set master.sidecars[0].image=redislabs/memtier_benchmark:1.4.0 \
      --set master.sidecars[0].imagePullPolicy=IfNotPresent \
      --set master.sidecars[0].command[0]='/bin/sh' \
      --set master.sidecars[0].args[0]='-c' \
      --set master.sidecars[0].args[1]='while true; do memtier_benchmark --hide-histogram -s 127.0.0.1 -a weops --test-time=30 --expiry-range=10-30; sleep 30; done' \
      ./redis
    fi
  done
done

# cluster 集群模式
helm install redis-cluster-v7 --namespace redis \
--set global.redis.password='weops' \
--set master.podLabels.object='redis' \
--set commonLabels.object='redis' \
--set redis.podLabels.object='redis' \
--set persistence.enabled=false \
--set redis.sidecars[0].name=redis-benchmark \
--set redis.sidecars[0].image=redislabs/memtier_benchmark:1.4.0 \
--set redis.sidecars[0].imagePullPolicy=IfNotPresent \
--set redis.sidecars[0].command[0]='/bin/sh' \
--set redis.sidecars[0].args[0]='-c' \
--set redis.sidecars[0].args[1]='while true; do memtier_benchmark --hide-histogram -s 127.0.0.1 -a weops --test-time=30 --expiry-range=10-30 --cluster-mode; sleep 30; done' \
./redis-cluster 


# sentinel 哨兵模式
# 6379为redis端口，26379为哨兵端口
helm install redis-sentinel-v7 --namespace redis \
--set architecture='replication' \
--set global.redis.password='weops' \
--set master.podLabels.object='redis' \
--set commonLabels.object='redis' \
--set sentinel.enabled=true \
--set master.persistence.enabled=false \
--set replica.persistence.enabled=false \
--set sentinel.persistence.enabled=false \
--set master.sidecars[0].name=redis-benchmark \
--set master.sidecars[0].image=redislabs/memtier_benchmark:1.4.0 \
--set master.sidecars[0].imagePullPolicy=IfNotPresent \
--set master.sidecars[0].command[0]='/bin/sh' \
--set master.sidecars[0].args[0]='-c' \
--set master.sidecars[0].args[1]='while true; do memtier_benchmark --hide-histogram -s 127.0.0.1 -a weops --test-time=30 --expiry-range=10-30; sleep 30; done' \
--set replica.sidecars[0].name=redis-benchmark \
--set replica.sidecars[0].image=redislabs/memtier_benchmark:1.4.0 \
--set replica.sidecars[0].imagePullPolicy=IfNotPresent \
--set replica.sidecars[0].command[0]='/bin/sh' \
--set replica.sidecars[0].args[0]='-c' \
--set replica.sidecars[0].args[1]='while true; do memtier_benchmark --hide-histogram -s 127.0.0.1 -a weops --test-time=30 --expiry-range=10-30; sleep 30; done' \
./redis

