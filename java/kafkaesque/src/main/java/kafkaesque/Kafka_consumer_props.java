package kafkaesque;


/**
 * Class for managing Kafka  Properties
 * 
 * - setting 
 * - and getting 
 * - and passing them around
 * 
 * 
 * @author retep.meissner@gmail.com
 * 
 */
public class Kafka_consumer_props extends Kafka_props {

  // /**
  //  * props holds all property values
  //  * 
  //  */
  public void set_defaults() {
    this.set_prop("key.deserializer",   "org.apache.kafka.common.serialization.StringDeserializer");
    this.set_prop("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
    this.set_prop("bootstrap.servers",  "localhost:9092");
    this.set_prop("client.id",          "kafkaesque_consumer");
    this.set_prop("auto.offset.reset",  "earliest");
    // this.set_prop("", "");
    // this.set_prop("", "");
    // this.set_prop("", "");
    // this.set_prop("", "");
    // this.set_prop("", "");
    // this.set_prop("", "");
  }


  /**
   * 
   * Default constructor method without parameters. Will set properties to default
   * values.
   * 
   */
  Kafka_consumer_props() {
    this.set_defaults();
  };

  /**
   * Constructor method that lets user decide whether to use default values or
   * not.
   * 
   * @param use_defaults [Boolean] Set default values or not?
   */
  Kafka_consumer_props(Boolean use_defaults) {
    if ( use_defaults ){
      this.set_defaults();
    } else {
      // do nothing
    }
  }



  /**
   * Example usage
   * 
   */
  public static void main(final String... args) throws Exception {

    final Kafka_consumer_props props = new Kafka_consumer_props();

    System.out.println("\nstart");
    System.out.println(props.props());

    props.set_defaults();
    props.set_prop("key", "value");

    System.out.println("\ndefaults()");
    System.out.println(props.props());

    System.out.println();
    System.out.println(props.to_json());

    System.out.println();
    System.out.println(props);

    props.from_json("{'test_from_json':'ok', 'test_from_json_2':'also ok'}");
    System.out.println();
    System.out.println(props);
  };

}
