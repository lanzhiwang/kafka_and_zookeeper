#!/bin/bash
set -x
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ./kafka/bin/kafka-server-start.sh -daemon ./kafka/config/server-0.properties

if [ $# -lt 1 ];
then
	echo "USAGE: $0 [-daemon] server.properties [--override property=value]*"
	exit 1
fi
base_dir=$(dirname $0)
# base_dir=./kafka/bin

if [ "x$KAFKA_LOG4J_OPTS" = "x" ]; then
    export KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$base_dir/../config/log4j.properties -Dzookeeper.ssl.client.enable=true -Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty -Dzookeeper.ssl.keyStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.keystore.jks -Dzookeeper.ssl.keyStore.password=huzhi567233 -Dzookeeper.ssl.trustStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.truststore.jks -Dzookeeper.ssl.trustStore.password=huzhi567233 -Djava.security.auth.login.config=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/kafka/config/kafka_server_jaas.conf -Dzookeeper.sasl.client=true -Dzookeeper.sasl.client.username=bob"
         # KAFKA_LOG4J_OPTS=-Dlog4j.configuration=file:./kafka/bin/../config/log4j.properties
fi

# -Dzookeeper.ssl.client.enable=true
# -Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
# -Dzookeeper.ssl.keyStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.keystore.jks
# -Dzookeeper.ssl.keyStore.password=huzhi567233
# -Dzookeeper.ssl.trustStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.truststore.jks
# -Dzookeeper.ssl.trustStore.password=huzhi567233

# -Djava.security.auth.login.config=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/kafka/config/kafka_server_jaas.conf
# -Dzookeeper.sasl.client=true
# -Dzookeeper.sasl.client.username=bob

if [ "x$KAFKA_HEAP_OPTS" = "x" ]; then
    export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
         # KAFKA_HEAP_OPTS='-Xmx1G -Xms1G'
fi

EXTRA_ARGS=${EXTRA_ARGS-'-name kafkaServer -loggc'}
# EXTRA_ARGS='-name kafkaServer -loggc'

COMMAND=$1
case $COMMAND in
  -daemon)
    EXTRA_ARGS="-daemon "$EXTRA_ARGS
    shift
    ;;
  *)
    ;;
esac
# EXTRA_ARGS='-daemon -name kafkaServer -loggc'

exec $base_dir/kafka-run-class.sh $EXTRA_ARGS kafka.Kafka "$@"
 # ./kafka/bin/kafka-run-class.sh -daemon -name kafkaServer -loggc kafka.Kafka ./kafka/config/server-0.properties



# /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home/bin/java
# -Xmx1G -Xms1G
# -server
# -XX:+UseG1GC
# -XX:MaxGCPauseMillis=20
# -XX:InitiatingHeapOccupancyPercent=35
# -XX:+ExplicitGCInvokesConcurrent
# -XX:MaxInlineLevel=15
# -Djava.awt.headless=true
# -Xloggc:/Users/huzhi/work/code/go_code/kafka_and_zookeeper/kafka/bin/../logs/kafkaServer-gc.log
# -verbose:gc
# -XX:+PrintGCDetails
# -XX:+PrintGCDateStamps
# -XX:+PrintGCTimeStamps
# -XX:+UseGCLogFileRotation
# -XX:NumberOfGCLogFiles=10
# -XX:GCLogFileSize=100M
# -Dcom.sun.management.jmxremote
# -Dcom.sun.management.jmxremote.authenticate=false
# -Dcom.sun.management.jmxremote.ssl=false
# -Dkafka.logs.dir=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/kafka/bin/../logs
# -Dlog4j.configuration=file:./kafka/bin/../config/log4j.properties
# -cp
# /Users/huzhi/work/code/go_code/kafka_and_zookeeper/kafka/bin/../libs/activation-1.1.1.jar:
# ...
# /Users/huzhi/work/code/go_code/kafka_and_zookeeper/kafka/bin/../libs/zstd-jni-1.4.4-7.jar
# -Dzookeeper.ssl.client.enable=true
# -Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
# -Dzookeeper.ssl.keyStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.keystore.jks
# -Dzookeeper.ssl.keyStore.password=huzhi567233
# -Dzookeeper.ssl.trustStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.truststore.jks
# -Dzookeeper.ssl.trustStore.password=huzhi567233
# kafka.Kafka
# ./kafka/config/server-0.properties
