apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-exporter-standalone-{{VERSION}}
  namespace: redis
spec:
  serviceName: redis-exporter-standalone-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: redis-exporter-standalone-{{VERSION}}
  template:
    metadata:
      annotations:
        telegraf.influxdata.com/interval: 1s
        telegraf.influxdata.com/inputs: |+
          [[inputs.cpu]]
            percpu = false
            totalcpu = true
            collect_cpu_time = true
            report_active = true

          [[inputs.disk]]
            ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

          [[inputs.diskio]]

          [[inputs.kernel]]

          [[inputs.mem]]

          [[inputs.processes]]

          [[inputs.system]]
            fielddrop = ["uptime_format"]

          [[inputs.net]]
            ignore_protocol_stats = true

          [[inputs.procstat]]
          ## pattern as argument for pgrep (ie, pgrep -f <pattern>)
            pattern = "exporter"
        telegraf.influxdata.com/class: opentsdb
        telegraf.influxdata.com/env-fieldref-NAMESPACE: metadata.namespace
        telegraf.influxdata.com/limits-cpu: '300m'
        telegraf.influxdata.com/limits-memory: '300Mi'
      labels:
        app: redis-exporter-standalone-{{VERSION}}
        exporter_object: redis
        object_mode: standalone
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      shareProcessNamespace: true
      containers:
      - name: redis-exporter-standalone-{{VERSION}}
        image: registry-svc:25000/library/redis-exporter:latest
        imagePullPolicy: Always
        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        args:
          - --redis.addr=redis://redis-standalone-{{VERSION}}-master.redis:6379
          - --redis.password=weops
          - --connection-timeout=3s
          - --include-system-metrics=true
          - --redis-only-metrics=true
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 300m
            memory: 300Mi
        ports:
        - containerPort: 9121

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: redis-exporter-standalone-{{VERSION}}
  name: redis-exporter-standalone-{{VERSION}}
  namespace: redis
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "9121"
    prometheus.io/path: '/metrics'
spec:
  ports:
  - port: 9121
    protocol: TCP
    targetPort: 9121
  selector:
    app: redis-exporter-standalone-{{VERSION}}
