#!/bin/bash

# 部署监控对象
object_versions=("7.0" "6.0" "5.0" "4.0.14" "3.2.9-r3")
object=redis

for version in "${object_versions[@]}"; do
    version_suffix="v${version%%.*}"

    helm uninstall redis-standalone-"$version_suffix" --namespace $object
done


helm uninstall redis-cluster-v7 --namespace $object
helm uninstall redis-sentinel-v7 --namespace $object

# Uninstall Redis deployments
for RELEASE in $(helm list -n $object --short)
do
  echo "Uninstalling $RELEASE ..."
  helm uninstall -n $object "$RELEASE"
done
