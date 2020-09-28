# Startup script for kafka

# start zookeeper
nohup ./kafka/bin/zookeeper-server-start.sh ./kafka/config/zookeeper.properties & 


# start kafka
nohup ./kafka/bin/kafka-server-start.sh ./kafka/config/server.properties & 


# waiting for zookeeper and kafka to finish startup
out="\rwaiting "
while ! grep -e "started (kafka.server.KafkaServer)" nohup.out > /dev/null;
do
    out=$out"."
    sleep 0.1
    echo -n $out
done


# adding testdata
echo "\n... adding messages ... to topic test500000"
kafkacat -P -b localhost -t test500000 -l test_500_000.txt

echo "\n... adding messages ... to topic test"
cat kafka_messages.txt | kafkacat -P -b localhost -t test 

echo "\n... adding messages ... to topic test2"
cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2
echo "... done."

echo "\n... starting script constantly adding messages to topic test3"
nohup watch -n 0.1 "cat /proc/meminfo | grep MemFree | kafkacat -P -b localhost -t test3" > /dev/null & 


