#!/bin/bash

# 部署监控对象
redis_versions=("7.0" "6.0" "5.0" "4.0.14" "3.2.9-r3")

for version in "${redis_versions[@]}"; do
    version_suffix="v${version%%.*}"

    helm install redis-standalone-$version_suffix --namespace redis  -f ./values/standalone_values.yaml \
    --set image.tag=$version \
    --set redis.podLabels.object_version=$version_suffix \
    ./redis
done


helm install redis-cluster-v7 --namespace redis -f ./values/cluster_values.yaml ./redis-cluster
helm install redis-sentinel-v7 --namespace redis -f ./values/sentinel_values.yaml ./redis
