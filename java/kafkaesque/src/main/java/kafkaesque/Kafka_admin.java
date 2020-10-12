package kafkaesque;

import java.util.*;
import java.util.concurrent.ExecutionException;

import org.apache.kafka.clients.admin.*;
import org.apache.kafka.common.*;
import org.apache.kafka.common.acl.*;
import org.apache.kafka.common.protocol.types.Field.Str;



/**
 * Shell Object to spin up producer, change config, send messages and close it again
 */
public class Kafka_admin {

  /**
   * Properties / Config
   * 
   * Create Config with default producer settings
   */
  public Kafka_admin_props props = new Kafka_admin_props();

  /**
   * Kafka Producer
   * 
   * Define Placeholder for producer to create and use later on
   */
  public AdminClient admin;

  /**
   * Properties / Config
   * 
   * @param keys   array of property keys
   * @param values array of property values
   * 
   * @return returns all settings
   * 
   */
  public Kafka_admin_props props_set(String[] keys, String[] values) {

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
  public Kafka_admin_props props_set(String keys, String values) {

    // go through settings and store them
    this.props.set_prop(keys, values);

    // return updated state
    return this.props;
  };


  /**
   * Holds information as to whether or not admin id running or not ( == was started and has not
   * been ended)
   */
  public boolean running = false; // TODO: does running apply to admin clients or should this be
                                  // dropped???


  /**
   * Create a kafka producer object with a specific config
   * 
   * @return Kafka Admin Object
   */
  public void start() {
    this.end();
    this.admin = AdminClient.create(this.props.props());
    this.running = true; // TODO: does running apply to admin clients or should this be dropped???
  }


  /**
   * Close kafka producer
   */
  public void end() {
    if (this.admin != null) {
      this.admin.close();
    }
    this.running = false; // TODO: does running apply to admin clients or should this be dropped???
  }


  /**
   * Close and start admin
   * 
   */
  public void restart() {
    this.end();
    this.start();
  }


  public String[] topics_list() throws InterruptedException, ExecutionException {

    // retrieve info
    ListTopicsResult list_topics_result = this.admin.listTopics();

    // convert info to type String[]
    KafkaFuture<Set<String>> names_future = list_topics_result.names();
    Set<String> names = names_future.get();
    String[] topics_list = names.toArray(new String[names.size()]);

    // return
    return topics_list;
  }


  public String[] topics_create(String topic, int partitions, int replication_factor)
      throws InterruptedException, ExecutionException {

    // convert input to arrays
    String[] tp = {topic};
    int[] prt   = {partitions};
    int[] rpl   = {replication_factor};

    // forward input to method with array signature + return topics
    return this.topics_create(tp, prt, rpl);
  }


  public String[] topics_create(String[] topic, int[] partitions, int[] replication_factor)
      throws InterruptedException, ExecutionException {

    // collect topic information
    Collection<NewTopic> topics = new HashSet<NewTopic>();

    for (int i = 0; i < topic.length; i++) {
      Integer rep_int = replication_factor[i];
      short rep       = rep_int.shortValue();
      int part        = partitions[i];

      NewTopic topic_item = new NewTopic(topic[i], part, rep);
      topics.add(topic_item);
    }
    
    // execute topic creation
    CreateTopicsResult res = admin.createTopics(topics);
    KafkaFuture<Void> all = res.all();
    all.get();

    // return topics
    return this.topics_list();
  }


  public static void main(final String... args) throws Exception {
    System.out.println("-----------------------------------------------------");

    final Kafka_admin admin = new Kafka_admin();
    admin.start();


    System.out.println(Json.to_json_pretty(admin.topics_list()));
    System.out.println(Json.to_json_pretty(admin.topics_create("dings", 1, 1)));
    System.out.println(Json.to_json_pretty(admin.topics_list()));

    admin.end();

    System.out.println("-----------------------------------------------------");
  }

}
