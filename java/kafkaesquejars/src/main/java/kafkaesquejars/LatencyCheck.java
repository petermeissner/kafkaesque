package kafkaesquejars;

import org.apache.kafka.clients.consumer.*;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.producer.*;
import org.apache.kafka.common.serialization.*;

import static org.apache.kafka.clients.producer.ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG;
import static org.apache.kafka.clients.producer.ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

public class LatencyCheck {


  private final static String TOPIC = "test";
  //private final static String BOOTSTRAP_SERVERS = "localhost:9092";
  private final static String BOOTSTRAP_SERVERS = "192.168.178.45:9092";
  

  public static void main(final String... args) throws Exception {
    
    // create producer
    final Properties propsp = new Properties();
    propsp.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
    propsp.put(ProducerConfig.CLIENT_ID_CONFIG, "KafkaExampleProducer");
    propsp.put(KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class.getName());
    propsp.put(VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
    final Producer<Long, String> producer = new KafkaProducer<>(propsp);
    
    // create consumer
    final Properties propsc = new Properties();
    propsc.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
    propsc.put(ConsumerConfig.GROUP_ID_CONFIG, "KafkaExampleConsumer");
    propsc.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, LongDeserializer.class.getName());
    propsc.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    final Consumer<Long, String> consumer = new KafkaConsumer<>(propsc);
    consumer.subscribe(Collections.singletonList(TOPIC));

    // push some messages ahead
    for (int i = 0; i < 1000; i++) {
      final long timep = System.currentTimeMillis();
      try {
        final ProducerRecord<Long, String> record = new ProducerRecord<>(TOPIC, timep + "");
        producer.send(record).get();
      } finally {
        producer.flush();
        
      }
    }

    // push more messages and process messages at the same time while measuring latency
    for (int i = 0; i < 1000; i++) {
      final long timep = System.currentTimeMillis();
      try {
        final ProducerRecord<Long, String> record = new ProducerRecord<>(TOPIC, timep + "");
        producer.send(record).get();
      } finally {
        producer.flush();
      }
      
      long offs = -1;
      long send_time = System.currentTimeMillis();
      long timec     = System.currentTimeMillis();

      while (true) {
        final ConsumerRecords<Long, String> records = consumer.poll(Duration.ofMillis(100));
        if (records.count() == 0) {
          break;
        }
        
        for (final ConsumerRecord<Long, String> record : records) {
          offs      = record.offset();
          send_time = Long.parseLong(0 + record.value());
          timec     = System.currentTimeMillis();
        }
        consumer.commitAsync();
      }

      System.out.println("record: " + offs + " i: " + i + " with latency: " + (timec - send_time) + " and loop duration: " + (timec - timep));

    }

    producer.close();
    consumer.close();
  }

}
