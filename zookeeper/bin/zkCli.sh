#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This script cleans up old transaction logs and snapshots
#

#
# If this scripted is run out of /usr/bin or some other system bin directory
# it should be linked to and not copied. Things like java jar files are found
# relative to the canonical path of this script.
#

# use POSTIX interface, symlink is followed automatically
ZOOBIN="${BASH_SOURCE-$0}"
ZOOBIN="$(dirname "${ZOOBIN}")"
ZOOBINDIR="$(cd "${ZOOBIN}"; pwd)"

if [ -e "$ZOOBIN/../libexec/zkEnv.sh" ]; then
  . "$ZOOBINDIR"/../libexec/zkEnv.sh
else
  . "$ZOOBINDIR"/zkEnv.sh
fi

ZOO_LOG_FILE=zookeeper-$USER-cli-$HOSTNAME.log

export CLIENT_JVMFLAGS="
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true
-Dzookeeper.ssl.keyStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.keystore.jks
-Dzookeeper.ssl.keyStore.password=huzhi567233
-Dzookeeper.ssl.trustStore.location=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/ssl/kafka.zookeeper-client.truststore.jks
-Dzookeeper.ssl.trustStore.password=huzhi567233"

export CLIENT_JVMFLAGS="${CLIENT_JVMFLAGS} -Djava.security.auth.login.config=/Users/huzhi/work/code/go_code/kafka_and_zookeeper/zookeeper/conf/client_jaas.conf"

"$JAVA" "-Dzookeeper.log.dir=${ZOO_LOG_DIR}" "-Dzookeeper.root.logger=${ZOO_LOG4J_PROP}" "-Dzookeeper.log.file=${ZOO_LOG_FILE}" \
     -cp "$CLASSPATH" $CLIENT_JVMFLAGS $JVMFLAGS \
     org.apache.zookeeper.ZooKeeperMain "$@"
