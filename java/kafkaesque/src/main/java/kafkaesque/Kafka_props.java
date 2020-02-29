package kafkaesque;

import java.util.Properties;
import java.util.*;
import com.google.gson.*;

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
public class Kafka_props {

  /**
   * props holds all property values
   * 
   */
  private Properties props = new Properties();


  /**
   * Set properties on Kafka_props object.
   * 
   * @param key   [String] key to store value under
   * @param value [String] value to store under specified key
   * 
   */
  public void set_prop(String key, String value) {
    this.props.setProperty(key, value);
  }

  /**
   * 
   * Return Property values from Kafka_props object and specifying
   * default value.
   * 
   * @param key   key to look for
   * @param value value to return if no value is found
   * 
   */
  public void get_prop(String key, String value) {
    this.props.getProperty(key, value);
  }

  /**
   * 
   * Return Property values from Kafka_consumer_props object.
   * 
   * @param key key to look for
   * 
   */
  public void get_prop(String key) {
    this.props.getProperty(key);
  }

  /**
   * Return Properties object from Kafka_consumer_props object.
   * 
   */
  public Properties props() {
    return props;
  };

  private void merge_props(Properties... new_props) {
    for (Properties np : new_props) {
      Set<String> names = np.stringPropertyNames();
      for (String name : names) {
        String value = np.getProperty(name);
        this.set_prop(name, value);
      }
    }
  }


  /**
   * Transforming properties to JSON string.
   * @return JSON string
   */
  public String to_json() {
    Gson gson = new Gson();
    String props_json = gson.toJson(this.props);
    return props_json;
  };


  /**
   *  Transforming properties to JSON string
   * @return pretty JSON string
   */
  public String to_json_pretty() {
    Gson gson = new GsonBuilder().setPrettyPrinting().create();
    String props_json = gson.toJson(this.props);
    return props_json;
  };


  /**
   * Method to set properties from JSON strings
   * 
   * @param json [String] JSON string with properties in format key:value
   */
  public void from_json(String json) {
    Gson gson = new Gson();
    final Properties new_props = gson.fromJson(json, Properties.class);
    this.merge_props(new_props);
  };


  /**
   * Set properties from JSON strings.
   * 
   * Allowing to decide whether or not properties stored already 
   * should be overwritten. 
   * 
   * @param json [String] JSON string with properties in format key:value
   */
  public void from_json(String json, Boolean replace) {
    
    // handle replace option
    if ( replace ){
      Properties new_props = new Properties();
      this.props = new_props;
    }

    // parse JSON and add to this.props
    Gson gson = new Gson();
    final Properties new_props = gson.fromJson(json, Properties.class);
    this.merge_props(new_props);
  };

  /**
   * toString replacement
   */
  @Override
  public String toString() {
    return this.to_json_pretty();
  };


  /**
   * Example usage
   * 
   */
  public static void main(final String... args) throws Exception {

    final Kafka_props props = new Kafka_props();

    props.set_prop("this key", "value");

    System.out.println();
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
