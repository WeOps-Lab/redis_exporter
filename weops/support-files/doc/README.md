## 嘉为蓝鲸redis插件使用说明

### 插件功能

Redis Exporter 使用 Redis 的监控命令 INFO、CONFIG、CLUSTER、COMMANDSTATS 等来获取 Redis 实例的监控指标。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Redis版本支持: 2.x, 3.x, 4.x, 5.x, 6.x, 7.x

部署模式支持: 单机模式(Standalone), 主从复制模式(Master-Slave Replication), 集群(Cluster), 哨兵模式(Sentinel)

**是否支持远程采集:**

是

### 参数说明

| **参数名**                 | **含义**                                          | **是否必填** | **使用举例**               |
|-------------------------|-------------------------------------------------|----------|------------------------|
| REDIS_USER              | 用于身份验证的用户名(环境变量)，Redis ACL for Redis 6.0+, 默认为空 | 否        | admin                  |
| REDIS_PASSWORD          | redis密码(环境变量)，若为空则不填，默认为空                       | 否        | 123456                 |
| -redis.addr             | redis 实例地址                                      | 是        | redis://localhost:6379 |
| -include-system-metrics | 是否包含系统指标，比如total_system_memory_bytes, 默认为false  | 否        | true                   |
| -is-cluster             | 是否集群模式, 默认为false                                | 是        | false                  |
| -ping-on-connect        | 连接后是否ping redis 实例并将持续时间记录为指标，默认为false          | 否        | true                   |
| -connection-timeout     | 连接到redis的超时时间, 默认为15s                           | 否        | 15s                    |
| -web.listen-address     | exporter监听id及端口地址                               | 否        | 127.0.0.1:9601         |


### 使用指引

1. 验证redis密码
    ```shell
    ./redis-cli -h redis地址 -p 端口号
    ./redis-cli -h 127.0.0.1 -p 6379

    # 进入后会出现 127.0.0.1:6379>
    # 在右侧输入AUTH 密码, 如果正确会返回OK, 下面是一些示例
    root@5a3f395bab17:/usr/local/bin# ./redis-cli -h 127.0.0.1 -p 6379 -a wsbs201712
    Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
    127.0.0.1:6379>
    127.0.0.1:6379> AUTH 1234567
    (error) ERR invalid password
    127.0.0.1:6379> AUTH 123456
    OK
    127.0.0.1:6379> config get requirepass
    1) "requirepass"
    2) "123456"
    ```

   - 查看redis密码
     方法1: 通过redis-cli进入redis后执行config get requirepass命令

     ```shell
     # 返回示例，密码为空
     127.0.0.1:6379> config get requirepass
     1) "requirepass"
     2) ""
     
     # 返回示例，密码不为空
     127.0.0.1:6379> config get requirepass
     (error) NOAUTH Authentication required.
     ```

     方法2: 寻找Redis的配置文件, 默认在/etc/redis.conf，找到字样"requirepass"
     requirepass redis密码

2. redis账户
    如果用到redis账户需要确保授权，注意redis版本不同可能授权不同
    例: redis v7授权 
    ```bash
    127.0.0.1:6379> ACL SETUSER weops on >123456 +client +ping +info +config|get +cluster|info +slowlog +latency +memory +select +get +scan +xinfo +type +pfcount +strlen +llen +scard +zcard +hlen +xlen +eval allkeys
    OK
    ```


### 指标简介
| 指标ID                                         | 指标中文名                      | 维度ID                                       | 维度含义                | 单位      |
|----------------------------------------------|----------------------------|--------------------------------------------|---------------------|---------|
| redis_up                                     | Redis监控插件运行状态              | -                                          | -                   | -       |
| redis_uptime_in_seconds                      | Redis服务器已运行时间              | -                                          | -                   | s       |
| redis_commands_processed_total               | Redis命令处理数量                | -                                          | -                   | -       |
| redis_net_input_bytes_total                  | Redis网络接收流量                | -                                          | -                   | bytes   |
| redis_net_output_bytes_total                 | Redis网络发送流量                | -                                          | -                   | bytes   |
| redis_db_keys                                | Redis数据库key数量              | db                                         | 数据库编号               | -       |
| redis_db_keys_expiring                       | Redis即将过期的key数量            | db                                         | 数据库编号               | -       |
| redis_expired_keys_total                     | Redis过期的key数量              | -                                          | -                   | -       |
| redis_evicted_keys_total                     | Redis已删除的key数量             | -                                          | -                   | -       |
| redis_commands_total                         | Redis命令执行数量                | cmd                                        | 命令名称                | -       |
| redis_commands_duration_seconds_total        | Redis命令执行时间                | cmd                                        | 命令名称                | s       |
| redis_rejected_connections_total             | Redis拒绝连接的数量               | -                                          | -                   | -       |
| redis_mem_fragmentation_ratio                | Redis内存碎片比率                | -                                          | -                   | -       |
| redis_memory_used_bytes                      | Redis内存使用量                 | -                                          | -                   | bytes   |
| redis_memory_max_bytes                       | Redis最大可用内存量               | -                                          | -                   | bytes   |
| redis_total_system_memory_bytes              | Redis系统内存总量                | -                                          | -                   | bytes   |
| redis_connected_slaves                       | Redis从服务器连接数               | -                                          | -                   | -       |
| redis_instance_info                          | Redis实例信息                  | role                                       | tcp_port            | 角色      | 端口             | -       |
| redis_connected_clients                      | Redis客户端连接数                | -                                          | -                   | -       |
| redis_config_maxclients                      | Redis客户端最大连接数              | -                                          | -                   | -       |
| redis_blocked_clients                        | Redis被阻塞的客户端数量             | -                                          | -                   | -       |
| redis_keyspace_hits_total                    | Redis命中key数量               | -                                          | -                   | -       |
| redis_keyspace_misses_total                  | Redis未命中key数量              | -                                          | -                   | -       |
| redis_rdb_last_save_timestamp_seconds        | Redis RDB最后保存时间            | -                                          | -                   | seconds |
| redis_rdb_changes_since_last_save            | Redis RDB上次保存以来更改的key数量    | -                                          | -                   | -       |
| redis_cluster_connections                    | Redis集群连接数                 | -                                          | -                   | -       |
| redis_cluster_current_epoch                  | Redis集群当前纪元                | -                                          | -                   | -       |
| redis_cluster_enabled                        | Redis集群是否启用                | -                                          | -                   | -       |
| redis_cluster_known_nodes                    | Redis集群已知节点数               | -                                          | -                   | -       |
| redis_cluster_messages_received_total        | Redis集群接收消息总数              | -                                          | -                   | -       |
| redis_cluster_messages_sent_total            | Redis集群发送消息总数              | -                                          | -                   | -       |
| redis_cluster_my_epoch                       | Redis集群当前节点所在纪元            | -                                          | -                   | -       |
| redis_cluster_size                           | Redis集群节点数量                | -                                          | -                   | -       |
| redis_cluster_slots_assigned                 | Redis集群已分配的槽数量             | -                                          | -                   | -       |
| redis_cluster_slots_fail                     | Redis集群标记为FAIL的槽数量         | -                                          | -                   | -       |
| redis_cluster_slots_ok                       | Redis集群正常运行的槽数量            | -                                          | -                   | -       |
| redis_cluster_slots_pfail                    | Redis集群标记为PFAIL的槽数量        | -                                          | -                   | -       |
| redis_cluster_state                          | Redis集群状态                  | -                                          | -                   | -       |
| redis_sentinel_master_ok_sentinels           | Redis Sentinel主节点的可用哨兵数量   | master_address, master_name                | 主节点地址 , 主节点名称       | -       |
| redis_sentinel_master_ok_slaves              | Redis Sentinel主节点的可用从节点数量  | master_address, master_name                | 主节点地址 , 主节点名称       | -       |
| redis_sentinel_master_sentinels              | Redis Sentinel主节点的哨兵数量     | master_address, master_name                | 主节点地址 , 主节点名称       | -       |
| redis_sentinel_master_slaves                 | Redis Sentinel主节点的从节点数量    | master_address, master_name                | 主节点地址 , 主节点名称       | -       |
| redis_sentinel_master_status                 | Redis Sentinel主节点状态        | master_address, master_name, master_status | 主节点地址, 主节点名称, 主节点状态 | -       |
| redis_sentinel_masters                       | Redis Sentinel主节点数量        | -                                          | -                   | -       |
| redis_exporter_last_scrape_duration_seconds  | Redis监控探针最近一次抓取时长          | -                                          | -                   | s       |
| redis_exporter_last_scrape_ping_time_seconds | Redis监控探针最后一次抓取ping命令的响应时间 | -                                          | -                   | s       |
| redis_slowlog_length                         | Redis慢查询日志队列长度             | -                                          | -                   | -       |


### 版本日志

#### weops_redis_exporter 4.0.1

- weops调整

#### weops_redis_exporter 4.0.2

- 密码参数使用环境变量

#### weops_redis_exporter 4.0.3

- 密码参数使用密码类型参数隐藏

#### weops_redis_exporter 4.0.4

- 支持用户名参数

添加“小嘉”微信即可获取redis监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
