#!/bin/bash

# 部署监控对象
object_versions=("7.0" "6.0" "5.0" "4.0.14" "3.2.9-r3")
object=mysql

for version in "${object_versions[@]}"; do
    version_suffix="v${version%%.*}"

    helm install redis-standalone-$version_suffix --namespace $object  -f ./values/standalone_values.yaml \
    --set image.tag=$version \
    --set redis.podLabels.object_version=$version_suffix \
    ./redis
done


helm install redis-cluster-v7 --namespace $object -f ./values/cluster_values.yaml ./redis-cluster
helm install redis-sentinel-v7 --namespace $object -f ./values/sentinel_values.yaml ./redis
