# Startup script for kafka

# start zookeeper
nohup ./kafka/bin/zookeeper-server-start.sh ./kafka/config/zookeeper.properties & 


# start kafka
nohup ./kafka/bin/kafka-server-start.sh ./kafka/config/server.properties & 

# 
# sleep 3 && \
# cat kafka_messages.txt | kafkacat -P -b localhost -t test && \
# cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
# cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
# cat kafka_messages.txt | kafkacat -P -b localhost -t test2

out="\rwaiting "
while ! grep -e "started (kafka.server.KafkaServer)" nohup.out > /dev/null;
do
    out=$out"."
    sleep 0.1
    echo -n $out
done

echo "\n... adding messages ..."
cat kafka_messages.txt | kafkacat -P -b localhost -t test && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2 && \
cat kafka_messages.txt | kafkacat -P -b localhost -t test2
echo "... done."
