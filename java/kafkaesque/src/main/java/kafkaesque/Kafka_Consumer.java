package kafkaesque;


import java.time.Duration;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.TopicPartition;




/**
 * Shell Object to spin up consumer, change config, send messages and close it again
 */
public class Kafka_consumer {


  /**
   * Properties / Config
   * 
   * Create Config with default consumer settings
   */
  public Kafka_consumer_props props = new Kafka_consumer_props();


  /**
   * Kafka Consumer
   * 
   * Define Placeholder for consumer to create and use later on
   */
  public KafkaConsumer<String, String> cons;


  /**
   * Create a kafka consumer object with a specific config
   * 
   */
  public void start() {
    
    // either use group id in properties object or use random value
    String group_id = this.props.get_prop("group.id", UUID.randomUUID().toString());
    
    // set group id
    this.props.set_prop("group.id", group_id);
    
    // create new consumer 
    this.cons = new KafkaConsumer<>(this.props.props());
    this.cons.subscribe(Arrays.asList("test"));
  }


  /**
   * Create a kafka consumer object with a specific config
   * 
   * @return Kafka consumer Object
   */
  public void restart() {
    this.end();
    this.start();
  }


  /**
   * Close kafka consumer
   */
  public void end() {
    if (this.cons != null) {
      this.cons.close();
    }
  }


  /**
   * Subscribe to topics
   */
  public void subscribe(String topic) {
    List<String> tpcs = Arrays.asList(topic);
    this.cons.subscribe(tpcs);
  }

  /**
   * Subscribe to topics
   */
  public void subscribe(String[] topics) {
    List<String> tpcs = Arrays.asList(topics);
    this.cons.subscribe(tpcs);
  }


  /**
   * 
   */
  public String subscription() {
    return Json.to_json(cons.subscription());
  }



  /**
   * Storage for messages returned from polling 
   */
  ConsumerRecords<String, String> records;


  /**
   * 
   * Poll Kafka for new messages
   * 
   */
  public void poll() {
    this.records = this.cons.poll(Duration.ofMillis(100));
  }
  

  /**
   * Poll Kafka for new messages for i milliseconds
   */
  public void poll(Integer i) {
    this.records = this.cons.poll(Duration.ofMillis(i));
  }


  public static void main(final String... args) throws Exception {

    System.out.println("\n\n-----------------------------------------------------");
    final Kafka_consumer cons = new Kafka_consumer();
    
    cons.start();
    cons.subscribe("test");
    // cons.seek_to_beginning("test");

    System.out.println(cons.subscription());

      cons.poll();
      cons.records.forEach(
          record -> {
            System.out.println(
              "1 Got Record: (" + 
              record.key() + 
              ", " + record.value() + 
              ") at offset " + 
              record.offset());
          });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "2 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "3 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "4 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "5 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "6 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "7 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.poll();
      cons.records.forEach(
        record -> {
          System.out.println(
            "8 Got Record: (" + 
            record.key() + 
            ", " + record.value() + 
            ") at offset " + 
            record.offset());
        });
      cons.end();
      System.out.println("-----------------------------------------------------\n\n");
    }

}


// public class Kafka_Consumer {

//     private final static String TOPIC = "test";
//     private final static String BOOTSTRAP_SERVERS = "localhost:9092";

//     public static void main(String... args) throws Exception {
//         runconsumer(5000);
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
