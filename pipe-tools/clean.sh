#!/bin/bash
kubectl delete -f ./exporter -n redis
kubectl delete -f ./exporter/standalone -n redis

# 卸载监控对象
cd charts
bash helm_uninstall.sh
