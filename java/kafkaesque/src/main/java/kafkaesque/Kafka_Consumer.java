package kafkaesque;

import java.time.Duration;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.PartitionInfo;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.clients.consumer.OffsetAndMetadata;

/**
 * Shell Object to spin up consumer, change config, send messages and close it
 * again
 */
public class Kafka_consumer {

  /**
   * Properties / Config
   * 
   * Create Config with default consumer settings
   */
  public Kafka_consumer_props props = new Kafka_consumer_props();


  /**
   * Properties / Config
   * 
   * Create Config with default consumer settings
   */
  public Kafka_consumer_props props_set(String[] keys, String[] values){

    // go through seetings and store them
    for (int i = 0; i < keys.length; i++) {
      this.props.set_prop(keys[i], values[i]);
    }

    // return updated state
    return this.props;
  };


  /**
   * Kafka Consumer
   * 
   * Define Placeholder for consumer to create and use later on
   */
  public KafkaConsumer<String, String> cons;

  /**
   * Holds information as to whether or not consumer id running or not ( == was
   * started and has not been ended)
   */
  public boolean running = false;

  /**
   * Create a kafka consumer object with a specific config
   * 
   */
  public void start() {

    // either use group id in properties object or use random value
    final String group_id = this.props.get_prop("group.id", UUID.randomUUID().toString());

    // set group id
    this.props.set_prop("group.id", group_id);

    // create new consumer
    this.cons = new KafkaConsumer<>(this.props.props());
    this.running = true;
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
    this.running = false;
  }

  /**
   * commit all topics synchronously
   */
  public void commit_sync() {
    cons.commitSync();
  }

  /**
   * commit all topics asynchronously
   */
  public void commit_async() {
    cons.commitAsync();
  }

  
  /**
   * List topics
   */
  public String topics_list() {
    final Map<String, List<PartitionInfo>> topics = cons.listTopics();
    return Json.to_json(topics);
  }

  public Map<String, List<PartitionInfo>> topics;

  /**
   * Subscribe to topics
   */
  public String[] topics_subscribe(final String topic) {
    final List<String> tpcs = Arrays.asList(topic);
    this.cons.subscribe(tpcs);
    return this.topics_subscription();
  }

  /**
   * Subscribe to topics
   */
  public String[] topics_subscribe(final String[] topics) {
    final List<String> tpcs = Arrays.asList(topics);
    this.cons.subscribe(tpcs);
    return this.topics_subscription();
  }

  /**
   * Return topics subscribed to
   */
  public String[] topics_subscription() {
    // get current subscription and cast type set to type String[] of size set
    String[] str = new String[cons.subscription().size()];
    str = cons.subscription().toArray(str);
    return str;
  }

  /**
   * Storage for messages returned from polling
   */
  public ConsumerRecords<String, String> records;

  /**
   * 
   * Poll Kafka for new messages
   * 
   */
  public int poll() {
    this.records = this.cons.poll(Duration.ofMillis(100));
    return records.count();
  }

  /**
   * 
   * Poll Kafka for new messages
   * 
   */
  public int poll(final int timeout_ms) {
    this.records = this.cons.poll(Duration.ofMillis(timeout_ms));
    return records.count();
  }

  /**
   * 
   * Return current set of records as JSON string
   * 
   * @return JSON string of record data
   * 
   */
  public String records_json() {
    return Json.to_json(this.records);
  }

  /**
   * 
   * Poll Kafka for new messages and print them
   * 
   */
  public void poll_print() {
    this.records = this.cons.poll(Duration.ofMillis(100));
    this.records.forEach(record -> {
      System.out.println("1 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
  }

  public static void main(final String... args) throws Exception {

    System.out.println("\n\n-----------------------------------------------------");
    final Kafka_consumer cons = new Kafka_consumer();

    cons.start();
    cons.topics_subscribe("test");
    // cons.seek_to_beginning("test");

    System.out.println(cons.topics_subscription());

    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("1 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("2 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("3 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("4 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("5 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("6 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("7 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.poll();
    cons.records.forEach(record -> {
      System.out.println("8 Got Record: (" + record.key() + ", " + record.value() + ") at offset " + record.offset());
    });
    cons.end();
    System.out.println("-----------------------------------------------------\n\n");
  }

}

// public class Kafka_Consumer {

// private final static String TOPIC = "test";
// private final static String BOOTSTRAP_SERVERS = "localhost:9092";

// public static void main(String... args) throws Exception {
// runconsumer(5000);
// runConsumer();
// }

// private static Producer<Long, String> createProducer() {
// Properties props = new Properties();
// props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, BOOTSTRAP_SERVERS);
// props.put(ProducerConfig.CLIENT_ID_CONFIG, "KafkaExampleProducer");
// props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
// LongSerializer.class.getName());
// props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
// StringSerializer.class.getName());
// return new KafkaProducer<>(props);
// }

// static void runProducer(final int sendMessageCount) throws Exception {
// final Producer<Long, String> producer = createProducer();
// long time = System.currentTimeMillis();

// try {
// for (long index = time; index < time + sendMessageCount; index++) {
// final ProducerRecord<Long, String> record =
// new ProducerRecord<>(TOPIC, index, "Hello Mom " + index);

// RecordMetadata metadata = producer.send(record).get();

// long elapsedTime = System.currentTimeMillis() - time;
// System.out.printf("sent record(key=%s value=%s) " +
// "meta(partition=%d, offset=%d) time=%d\n",
// record.key(), record.value(), metadata.partition(),
// metadata.offset(), elapsedTime);

// }
// }finally {
// producer.flush();
// producer.close();
// }
// }

// static void runConsumer() throws InterruptedException {
// Consumer<Long, String> consumer = createConsumer();

// while (true) {
// final ConsumerRecords<Long, String> consumerRecords =
// consumer.poll(Duration.ofMillis(100));

// if (consumerRecords.count()==0) {
// break;
// }

// consumerRecords.forEach(record -> {
// System.out.println("Got Record: (" + record.key() + ", " + record.value()
// + ") at offset " + record.offset());
// });
// consumer.commitAsync();
// }
// consumer.close();
// System.out.println("DONE");
// }

// }
