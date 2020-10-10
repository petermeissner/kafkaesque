package kafkaesque;

import org.apache.kafka.clients.producer.*;

/**
 * Shell Object to spin up producer, change config, send messages and close it again
 */
public class Kafka_producer {

  /**
   * Properties / Config
   * 
   * Create Config with default producer settings
   */
  public Kafka_producer_props props = new Kafka_producer_props();

  /**
   * Kafka Producer
   * 
   * Define Placeholder for producer to create and use later on
   */
  public Producer<String, String> prod;

  /**
   * Properties / Config
   * 
   * @param keys   array of property keys
   * @param values array of property values
   * 
   * @return returns all settings
   * 
   */
  public Kafka_producer_props props_set(String[] keys, String[] values) {

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
  public Kafka_producer_props props_set(String keys, String values) {

    // go through settings and store them
    this.props.set_prop(keys, values);

    // return updated state
    return this.props;
  };


  /**
   * Holds information as to whether or not consumer id running or not ( == was started and has not
   * been ended)
   */
  public boolean running = false;


  /**
   * Create a kafka producer object with a specific config
   * 
   * @return Kafka Producer Object
   */
  public void start() {
    this.end();
    this.prod = new KafkaProducer<String, String>(this.props.props());
    this.running = true;
  }


  /**
   * Close kafka producer
   */
  public void end() {
    if (this.prod != null) {
      this.prod.close();
    }
    this.running = false;
  }


  /**
   * Close and start producer
   * 
   */
  public void restart() {
    this.end();
    this.start();
  }


  public void flush() {
    prod.flush();
  }


  /**
   * Send message
   * 
   * @param topic topic
   * @param msg   message top send
   */
  public void send_message(String topic, String msg) {
    final ProducerRecord<String, String> record = new ProducerRecord<>(topic, msg);
    prod.send(record);
  }


  /**
   * Send messages
   * 
   * @param topic topic
   * @param msg   message
   */
  public void send_message(String[] topic, String[] msg) {
    for (int i = 0; i < topic.length; i++) {
      this.send_message(topic[i], msg[i]);
    }
  }


  public static void main(final String... args) throws Exception {
    System.out.println("-----------------------------------------------------");
    final Kafka_producer prod = new Kafka_producer();
    prod.start();
    prod.send_message("test", "a");
    prod.send_message("test", "b");
    prod.send_message("test", "c");
    prod.send_message("test", "d");
    prod.end();
    System.out.println("-----------------------------------------------------");
  }

}
