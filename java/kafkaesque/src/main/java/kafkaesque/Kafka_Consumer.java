// package kafkaesquejars;

// import org.apache.kafka.clients.consumer.*;
// import org.apache.kafka.clients.consumer.Consumer;
// import org.apache.kafka.clients.producer.*;
// import org.apache.kafka.common.serialization.*;

// import java.time.Duration;
// import java.util.Collections;
// import java.util.Properties;

// public class Kafka_Consumer {

//     private final static String TOPIC = "test";
//     private final static String BOOTSTRAP_SERVERS = "localhost:9092";

//     public static void main(String... args) throws Exception {
//         runProducer(5000);
//         runConsumer();
//     }

//     private static Producer<Long, String> createProducer() {
//         Properties props = new Properties();
//         props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
//         props.put(ProducerConfig.CLIENT_ID_CONFIG, "KafkaExampleProducer");
//         props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class.getName());
//         props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
//         return new KafkaProducer<>(props);
//     }

//     static void runProducer(final int sendMessageCount) throws Exception {
//         final Producer<Long, String> producer = createProducer();
//         long time = System.currentTimeMillis();

//         try {
//             for (long index = time; index < time + sendMessageCount; index++) {
//                 final ProducerRecord<Long, String> record =
//                         new ProducerRecord<>(TOPIC, index, "Hello Mom " + index);

//                 RecordMetadata metadata = producer.send(record).get();

//                 long elapsedTime = System.currentTimeMillis() - time;
//                 System.out.printf("sent record(key=%s value=%s) " +
//                                 "meta(partition=%d, offset=%d) time=%d\n",
//                                 record.key(), record.value(), metadata.partition(),
//                         metadata.offset(), elapsedTime);

//             }
//         }finally {
//             producer.flush();
//             producer.close();
//         }
//     }


//     static void runConsumer() throws InterruptedException {
//         Consumer<Long, String> consumer = createConsumer();

//         while (true) {
//             final ConsumerRecords<Long, String> consumerRecords = consumer.poll(Duration.ofMillis(100));

//             if (consumerRecords.count()==0) {
//                 break;
//             }

//             consumerRecords.forEach(record -> {
//                 System.out.println("Got Record: (" + record.key() + ", " + record.value()
//                         + ") at offset " + record.offset());
//             });
//             consumer.commitAsync();
//         }
//         consumer.close();
//         System.out.println("DONE");
//     }

// }
