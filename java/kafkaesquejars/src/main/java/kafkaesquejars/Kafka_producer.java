package kafkaesquejars;

import org.apache.kafka.clients.producer.*;


/**
 * Shell Object to spin up producer, change config, send messages and close it again
 */
public class Kafka_producer {

    /** 
     * Properties / Config
     * 
     * Create Config with default producer settings
     * */ 
    public Kafka_producer_props props = new Kafka_producer_props();


    /**
     * Kafka Producer
     * 
     * Define Placeholder for producer to create and use later on
     */
    public Producer<String, String> prod;


    /**
     * Create a kafka producer object with a specific config
     * 
     * @return Kafka Producer Object
     */
    public void producer_start() {
      this.producer_close();
      this.prod = new KafkaProducer<String, String>(this.props.props());
    }

    /**
     * Close kafka producer
     */
    public void producer_close(){
      if ( this.prod != null ){
        this.prod.close();
      }
    }

    public void send_message(String topic, String msg){
      final ProducerRecord<String, String> record = new ProducerRecord<>(topic, msg);
      prod.send(record);
      prod.flush();
    }

    public static void main(final String... args) throws Exception {
      System.out.println("-----------------------------------------------------");
      final Kafka_producer prod = new Kafka_producer();
      prod.producer_start();
      prod.send_message("test", "a");
      prod.send_message("test", "b");
      prod.send_message("test", "c");
      prod.send_message("test", "d");
      prod.producer_close();
      System.out.println("-----------------------------------------------------");
    }

}
