[How to launch a Kafka Cluster on your Laptop | Apache Kafka Series - Part 02](https://www.youtube.com/watch?v=gwrslUOSez8)

![](./images/01.png)


```bash
$ mkdir data
$ cd data/
$ mkdir zookeeper
$ mkdir broker-0
$ mkdir broker-1
$ mkdir broker-2
$ ll
total 0
drwxr-xr-x  6 huzhi  staff  192  1 14 21:43 ./
drwxr-xr-x  7 huzhi  staff  224  1 14 21:42 ../
drwxr-xr-x  2 huzhi  staff   64  1 14 21:43 broker-0/
drwxr-xr-x  2 huzhi  staff   64  1 14 21:43 broker-1/
drwxr-xr-x  2 huzhi  staff   64  1 14 21:43 broker-2/
drwxr-xr-x  2 huzhi  staff   64  1 14 21:42 zookeeper/

$ cd ../
$ ll
total 8
drwxr-xr-x   7 huzhi  staff  224  1 14 21:42 ./
drwxr-xr-x  26 huzhi  staff  832  1 14 21:29 ../
drwxr-xr-x  12 huzhi  staff  384  1 14 21:31 .git/
-rw-r--r--@  1 huzhi  staff  151  1 14 21:35 README.md
drwxr-xr-x   6 huzhi  staff  192  1 14 21:43 data/
drwxr-xr-x   3 huzhi  staff   96  1 14 21:35 images/
drwxr-xr-x   8 huzhi  staff  256  4  8  2020 kafka_2.12-2.5.0/
$


# vim ./config/zookeeper.properties

$ ./bin/zookeeper-server-start.sh -daemon ./config/zookeeper.properties
$ jps
4739 QuorumPeerMain
4774 Jps
$


$ cp server.properties server-0.properties
$ cp server.properties server-1.properties
$ cp server.properties server-2.properties


$ vim server-0.properties
$ vim server-1.properties
$ vim server-2.properties

$ ./bin/kafka-server-start.sh -daemon ./config/server-0.properties
$ jps
4739 QuorumPeerMain
4806 ZooKeeperMainWithTlsSupportForKafka
5675 Kafka
5677 Jps
$ ./bin/kafka-server-start.sh -daemon ./config/server-1.properties
$ ./bin/kafka-server-start.sh -daemon ./config/server-2.properties
$ jps
4739 QuorumPeerMain
4806 ZooKeeperMainWithTlsSupportForKafka
6025 Kafka
6347 Kafka
5675 Kafka
6348 Jps
$

$ tree -a data/zookeeper/
data/zookeeper/
└── version-2
    ├── log.1
    └── snapshot.0

1 directory, 2 files
$
$ tree -a data/broker-0/
data/broker-0/
├── .lock
├── cleaner-offset-checkpoint
├── log-start-offset-checkpoint
├── meta.properties
├── recovery-point-offset-checkpoint
└── replication-offset-checkpoint

0 directories, 6 files
$


$ ./bin/kafka-topics.sh --zookeeper localhost:2181 --list
$ ./bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic first-topic --partitions 2 --replication-factor 3
Created topic first-topic.
$ ./bin/kafka-topics.sh --zookeeper localhost:2181 --list
first-topic
$ ./bin/kafka-topics.sh --zookeeper localhost:2181 --topic first-topic --describe
Topic: first-topic	PartitionCount: 2	ReplicationFactor: 3	Configs:
	Topic: first-topic	Partition: 0	Leader: 0	Replicas: 0,1,2	Isr: 0,1,2
	Topic: first-topic	Partition: 1	Leader: 1	Replicas: 1,2,0	Isr: 1,2,0

$ cd ../

$ tree -a data/zookeeper/
data/zookeeper/
└── version-2
    ├── log.1
    └── snapshot.0

1 directory, 2 files

$ tree -a data/broker-0/
data/broker-0/
├── .lock
├── cleaner-offset-checkpoint
├── first-topic-0
│   ├── 00000000000000000000.index
│   ├── 00000000000000000000.log
│   ├── 00000000000000000000.timeindex
│   └── leader-epoch-checkpoint
├── first-topic-1
│   ├── 00000000000000000000.index
│   ├── 00000000000000000000.log
│   ├── 00000000000000000000.timeindex
│   └── leader-epoch-checkpoint
├── log-start-offset-checkpoint
├── meta.properties
├── recovery-point-offset-checkpoint
└── replication-offset-checkpoint

2 directories, 14 files

$ tree -a data/broker-1/
data/broker-1/
├── .lock
├── cleaner-offset-checkpoint
├── first-topic-0
│   ├── 00000000000000000000.index
│   ├── 00000000000000000000.log
│   ├── 00000000000000000000.timeindex
│   └── leader-epoch-checkpoint
├── first-topic-1
│   ├── 00000000000000000000.index
│   ├── 00000000000000000000.log
│   ├── 00000000000000000000.timeindex
│   └── leader-epoch-checkpoint
├── log-start-offset-checkpoint
├── meta.properties
├── recovery-point-offset-checkpoint
└── replication-offset-checkpoint

2 directories, 14 files

$ tree -a data/broker-2/
data/broker-2/
├── .lock
├── cleaner-offset-checkpoint
├── first-topic-0
│   ├── 00000000000000000000.index
│   ├── 00000000000000000000.log
│   ├── 00000000000000000000.timeindex
│   └── leader-epoch-checkpoint
├── first-topic-1
│   ├── 00000000000000000000.index
│   ├── 00000000000000000000.log
│   ├── 00000000000000000000.timeindex
│   └── leader-epoch-checkpoint
├── log-start-offset-checkpoint
├── meta.properties
├── recovery-point-offset-checkpoint
└── replication-offset-checkpoint

2 directories, 14 files
$

$ ./bin/kafka-console-producer.sh --bootstrap-server localhost:9092,localhost:9093,localhost:9094 --topic first-topic
>hello1
>hello2
>hello3
>hello4
>hello5
>hello6
>

$ ./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092,localhost:9093,localhost:9094 --topic first-topic --from-beginning --group first-consumer
hello1
hello3
hello2
hello4
hello5
hello6



$ ./bin/kafka-topics.sh --zookeeper localhost:2181 --list
__consumer_offsets
first-topic

$ ./bin/kafka-topics.sh --zookeeper localhost:2181 --topic __consumer_offsets --describe
Topic: __consumer_offsets	PartitionCount: 50	ReplicationFactor: 1	Configs: compression.type=producer,cleanup.policy=compact,segment.bytes=104857600
	Topic: __consumer_offsets	Partition: 0	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 1	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 2	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 3	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 4	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 5	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 6	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 7	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 8	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 9	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 10	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 11	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 12	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 13	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 14	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 15	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 16	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 17	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 18	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 19	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 20	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 21	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 22	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 23	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 24	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 25	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 26	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 27	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 28	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 29	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 30	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 31	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 32	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 33	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 34	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 35	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 36	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 37	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 38	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 39	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 40	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 41	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 42	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 43	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 44	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 45	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 46	Leader: 0	Replicas: 0	Isr: 0
	Topic: __consumer_offsets	Partition: 47	Leader: 1	Replicas: 1	Isr: 1
	Topic: __consumer_offsets	Partition: 48	Leader: 2	Replicas: 2	Isr: 2
	Topic: __consumer_offsets	Partition: 49	Leader: 0	Replicas: 0	Isr: 0

$ ./bin/kafka-run-class.sh kafka.admin.ConsumerGroupCommand --bootstrap-server localhost:9092,localhost:9093,localhost:9094 --describe --group first-consumer

GROUP           TOPIC           PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID                                                    HOST            CLIENT-ID
first-consumer  first-topic     0          3               3               0               consumer-first-consumer-1-97207b6f-712d-4b46-9f93-be334a282663 /127.0.0.1      consumer-first-consumer-1
first-consumer  first-topic     1          3               3               0               consumer-first-consumer-1-97207b6f-712d-4b46-9f93-be334a282663 /127.0.0.1      consumer-first-consumer-1

$ ./bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092,localhost:9093,localhost:9094 --topic first-topic
first-topic:0:3
first-topic:1:3
$


http://localhost:9090/commands/watches
http://localhost:9090/commands/stats


$ ./bin/zookeeper-shell.sh localhost:2181
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is disabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
ls /brokers/ids
Node does not exist: /brokers/ids
ls /brokers/ids
Node does not exist: /brokers/ids
ls /brokers/ids
Node does not exist: /brokers/ids
ls /brokers/ids
Node does not exist: /brokers/ids
ls /brokers/ids
Node does not exist: /brokers/ids
ls /brokers/ids
[0]
ls /brokers/ids
[0, 1, 2]
ls /
[admin, brokers, cluster, config, consumers, controller, controller_epoch, isr_change_notification, latest_producer_id_block, log_dir_event_notification, zookeeper]
ls /brokers
[ids, seqid, topics]
ls /brokers/topics
[first-topic]
ls /consumers
[]
ls /consumers
[]
quit

WATCHER::

WatchedEvent state:Closed type:None path:null
$


$ git diff
diff --git a/kafka_2.12-2.5.0/config/server-0.properties b/kafka_2.12-2.5.0/config/server-0.properties
index b1cf5c4..9b55737 100644
--- a/kafka_2.12-2.5.0/config/server-0.properties
+++ b/kafka_2.12-2.5.0/config/server-0.properties
@@ -28,12 +28,12 @@ broker.id=0
 #     listeners = listener_name://host_name:port
 #   EXAMPLE:
 #     listeners = PLAINTEXT://your.host.name:9092
-#listeners=PLAINTEXT://:9092
+listeners=PLAINTEXT://localhost:9092

 # Hostname and port the broker will advertise to producers and consumers. If not set,
 # it uses the value for "listeners" if configured.  Otherwise, it will use the value
 # returned from java.net.InetAddress.getCanonicalHostName().
-#advertised.listeners=PLAINTEXT://your.host.name:9092
+advertised.listeners=PLAINTEXT://localhost:9092

 # Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
 #listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
@@ -57,12 +57,12 @@ socket.request.max.bytes=104857600
 ############################# Log Basics #############################

 # A comma separated list of directories under which to store log files
-log.dirs=/tmp/kafka-logs
+log.dirs=/Users/huzhi/work/code/go_code/kafka/data/broker-0

 # The default number of log partitions per topic. More partitions allow greater
 # parallelism for consumption, but this will also result in more files across
 # the brokers.
-num.partitions=1
+num.partitions=3

 # The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
 # This value is recommended to be increased for installations with data dirs located in RAID array.
diff --git a/kafka_2.12-2.5.0/config/server-1.properties b/kafka_2.12-2.5.0/config/server-1.properties
index b1cf5c4..ef01944 100644
--- a/kafka_2.12-2.5.0/config/server-1.properties
+++ b/kafka_2.12-2.5.0/config/server-1.properties
@@ -18,7 +18,7 @@
 ############################# Server Basics #############################

 # The id of the broker. This must be set to a unique integer for each broker.
-broker.id=0
+broker.id=1

 ############################# Socket Server Settings #############################

@@ -28,12 +28,12 @@ broker.id=0
 #     listeners = listener_name://host_name:port
 #   EXAMPLE:
 #     listeners = PLAINTEXT://your.host.name:9092
-#listeners=PLAINTEXT://:9092
+listeners=PLAINTEXT://localhost:9093

 # Hostname and port the broker will advertise to producers and consumers. If not set,
 # it uses the value for "listeners" if configured.  Otherwise, it will use the value
 # returned from java.net.InetAddress.getCanonicalHostName().
-#advertised.listeners=PLAINTEXT://your.host.name:9092
+advertised.listeners=PLAINTEXT://localhost:9093

 # Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
 #listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
@@ -57,12 +57,12 @@ socket.request.max.bytes=104857600
 ############################# Log Basics #############################

 # A comma separated list of directories under which to store log files
-log.dirs=/tmp/kafka-logs
+log.dirs=/Users/huzhi/work/code/go_code/kafka/data/broker-1

 # The default number of log partitions per topic. More partitions allow greater
 # parallelism for consumption, but this will also result in more files across
 # the brokers.
-num.partitions=1
+num.partitions=3

 # The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
 # This value is recommended to be increased for installations with data dirs located in RAID array.
diff --git a/kafka_2.12-2.5.0/config/server-2.properties b/kafka_2.12-2.5.0/config/server-2.properties
index b1cf5c4..86a1ac9 100644
--- a/kafka_2.12-2.5.0/config/server-2.properties
+++ b/kafka_2.12-2.5.0/config/server-2.properties
@@ -18,7 +18,7 @@
 ############################# Server Basics #############################

 # The id of the broker. This must be set to a unique integer for each broker.
-broker.id=0
+broker.id=2

 ############################# Socket Server Settings #############################

@@ -28,12 +28,12 @@ broker.id=0
 #     listeners = listener_name://host_name:port
 #   EXAMPLE:
 #     listeners = PLAINTEXT://your.host.name:9092
-#listeners=PLAINTEXT://:9092
+listeners=PLAINTEXT://localhost:9094

 # Hostname and port the broker will advertise to producers and consumers. If not set,
 # it uses the value for "listeners" if configured.  Otherwise, it will use the value
 # returned from java.net.InetAddress.getCanonicalHostName().
-#advertised.listeners=PLAINTEXT://your.host.name:9092
+advertised.listeners=PLAINTEXT://localhost:9094

 # Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
 #listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
@@ -57,12 +57,12 @@ socket.request.max.bytes=104857600
 ############################# Log Basics #############################

 # A comma separated list of directories under which to store log files
-log.dirs=/tmp/kafka-logs
+log.dirs=/Users/huzhi/work/code/go_code/kafka/data/broker-2

 # The default number of log partitions per topic. More partitions allow greater
 # parallelism for consumption, but this will also result in more files across
 # the brokers.
-num.partitions=1
+num.partitions=3

 # The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
 # This value is recommended to be increased for installations with data dirs located in RAID array.
diff --git a/kafka_2.12-2.5.0/config/zookeeper.properties b/kafka_2.12-2.5.0/config/zookeeper.properties
index 90f4332..990c1c9 100644
--- a/kafka_2.12-2.5.0/config/zookeeper.properties
+++ b/kafka_2.12-2.5.0/config/zookeeper.properties
@@ -13,12 +13,14 @@
 # See the License for the specific language governing permissions and
 # limitations under the License.
 # the directory where the snapshot is stored.
-dataDir=/tmp/zookeeper
+dataDir=/Users/huzhi/work/code/go_code/kafka/data/zookeeper
 # the port at which the clients will connect
 clientPort=2181
 # disable the per-ip limit on the number of connections since this is a non-production config
 maxClientCnxns=0
 # Disable the adminserver by default to avoid port conflicts.
 # Set the port to something non-conflicting if choosing to enable this
-admin.enableServer=false
-# admin.serverPort=8080
+admin.enableServer=true
+admin.serverPort=9090
+server.1=localhost:2888:3888
+
$


```

