#!/usr/bin/bash

# Startup script for kafka

# start zookeeper
echo "starting Zookeeper"
nohup ./kafka/bin/zookeeper-server-start.sh ./kafka/config/zookeeper.properties > /home/docker/nohup.out 2>&1 &


# start kafka
echo "starting Kafka"
nohup ./kafka/bin/kafka-server-start.sh ./kafka/config/server.properties >> /home/docker/nohup.out 2>&1 &


# waiting for zookeeper and kafka to finish startup
out="\rwaiting for Kafka to finish startup"
while ! grep -e "started (kafka.server.KafkaServer)" nohup.out > /dev/null;
do
    out=$out"."
    sleep 0.1
    if [ ${#out} -ge 10 ]; then 
        out="${out}."
        echo -n "."
    fi
done
echo ""


# adding testdata
echo "... adding messages ... to topic test500000"
kafkacat -P -b localhost -t test500000 -l test_500_000.txt

echo "... adding messages ... to topic test"
cat kafka_messages.txt | kafkacat -P -b localhost -t test

echo "... adding messages ... to topic test2"
cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2
echo "... done."

echo "... starting script constantly adding messages to topic test3"
while /bin/true; do
    cat /proc/meminfo | grep MemFree | kafkacat -P -b localhost -t test3
    sleep 0.5
done &

echo "... sleeping and letting background tasks do their job"
sleep infinity
