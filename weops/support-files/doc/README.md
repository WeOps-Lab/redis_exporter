## 使用说明

### 插件功能

采集器去访问redis client查询数据信息，清洗数据，得到指标

### 版本支持

linux实测：centos7

windows实测：

**组件支持版本：**

理论上支持：2.x, 3.x, 4.x, 5.x, 6.x, and 7.x

**是否支持远程采集:**

是

### 使用指引

1. 如果有出现 invalid password
   - 此问题为redis的密码问题

        ```
        # 找到redis安装目录
        whereis redis 

        # 进入刚才查询到的安装目录
        cd /usr/local/redis/bin

        # 确认密码是否正确  
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

     ```
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

### 参数说明

| **参数名**             | **含义**                                                        | **是否必填** | **使用举例**           |
|------------------------|---------------------------------------------------------------|-------------|------------------------|
| redis.addr             | redis 实例地址                                                  | 是           | redis://localhost:6379 |
| redis.user             | 用于身份验证的用户名，Redis ACL for Redis 6.0+, 默认为空         | 否           | admin                  |
| redis.password         | redis密码，若为空则不填，默认为空                                 | 否           | 123456                 |
| redis-only-metrics     | 是否只采集redis指标，默认为false, 设置为true时会采集go运行时指标 | 否           | true                   |
| include-system-metrics | 是否包含系统指标，比如total_system_memory_bytes, 默认为false     | 否           | true                   |
| is-cluster             | 是否集群模式, 默认为false                                       | 是           | false                  |
| ping-on-connect        | 连接后是否ping redis 实例并将持续时间记录为指标，默认为false     | 否           | true                   |
| connection-timeout     | 连接到redis的超时时间, 默认为15s                                | 否           | 15s                     |
| web.listen-address     | exporter监听id及端口地址                                        | 否           | 127.0.0.1:9601         |

### 版本日志

#### redis_exporter 1.0.0

- weops调整
