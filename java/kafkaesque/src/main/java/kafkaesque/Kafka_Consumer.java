package kafkaesque;

import java.time.Duration;
import java.util.*;
import java.util.UUID;

import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.PartitionInfo;

/**
 * Shell Object to spin up consumer, change config, send messages and close it again
 */
public class Kafka_consumer {

  /**
   * Properties / Config
   * 
   * Create Config with default consumer settings
   */
  public Kafka_consumer_props props = new Kafka_consumer_props(true);

  /**
   * Properties / Config
   * 
   * @param keys   array of property keys
   * @param values array of property values
   * 
   * @return returns all settings
   * 
   */
  public Kafka_consumer_props props_set(String[] keys, String[] values) {

    // go through settings and store them
    for (int i = 0; i < keys.length; i++) {
      this.props.set_prop(keys[i], values[i]);
    }

    // return updated state
    return this.props;
  };


  /**
   * Properties / Config
   * 
   * @param keys   array of property keys
   * @param values array of property values
   * 
   * @return returns all settings
   * 
   */
  public Kafka_consumer_props props_set(String keys, String values) {

    // go through settings and store them
    this.props.set_prop(keys, values);

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
   * Holds information as to whether or not consumer id running or not ( == was started and has not
   * been ended)
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
   * Seek to beginning of all topic(-partitions) assigned to
   * 
   */
  public void topics_seek_to_beginning() {
    // seek for all topics and partitions currently assigned
    this.cons.seekToBeginning(this.cons.assignment());
  }


  /**
   * Seek to end of all topic(-partitions) assigned to
   * 
   */
  public void topics_seek_to_end() {
    // seek for all topics and partitions currently assigned
    this.cons.seekToEnd(this.cons.assignment());
  }


  /**
  * 
  * 
  */
  public Kafka_offset_arrays topics_offsets() {
    return new Kafka_offset_arrays(this.cons);
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
    // poll for data
    this.records = this.cons.poll(Duration.ofMillis(100));

    // return number of messages retrieved
    return records.count();
  }


  /**
   * 
   * Poll Kafka for new messages
   * 
   */
  public int poll(final int timeout_ms) {
    // poll for data
    this.records = this.cons.poll(Duration.ofMillis(timeout_ms));

    // return number of messages retrieved
    return records.count();
  }


  /**
   * 
   * Return current set of records as JSON string
   * 
   * @return JSON string of record data
   * 
   */
  public Kafka_record_arrays records_arrays() {
    Kafka_record_arrays res = new Kafka_record_arrays(this.records);
    return res;
  }


  /**
   * 
   * Return current set of records as JSON string
   * 
   * @return JSON string of record data
   * 
   */
  public String records_json() {
    return Json.to_json_pretty(this.records);
  }


  /**
   * 
   * Poll Kafka for new messages and print them
   * 
   */
  public void poll_print() {
    this.records = this.cons.poll(Duration.ofMillis(100));
    this.records.forEach(record -> {
      System.out.println("1 Got Record: (" + record.key() + ", " + record.value() + ") at offset "
          + record.offset());
    });
  }


  public static void main(final String... args) throws Exception {

    System.out.println("\n\n-----------------------------------------------------");
    final Kafka_consumer cons = new Kafka_consumer();

    cons.props_set("max.poll.records", "1");
    cons.start();
    cons.topics_subscribe("test3");

    System.out.println(Json.to_json_pretty(cons.topics_subscription()));

    System.out.println("-----------------------------------------------------\n\n");

    cons.poll();
    while (cons.records.count() == 0) {
      cons.poll();
    }

    System.out.println(cons.records_json());

    System.out.println(cons.topics_offsets());

    System.out.println("-----------------------------------------------------\n\n");
  }

}
