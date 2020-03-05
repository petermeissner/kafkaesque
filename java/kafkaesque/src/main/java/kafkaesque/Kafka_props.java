package kafkaesque;

import java.util.Properties;
import java.util.*;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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
  public void set_prop(final String key, final String value) {
    this.props.setProperty(key, value);
  }

  /**
   * 
   * Return Property values from Kafka_props object and specifying default value.
   * 
   * @param key   key to look for
   * @param value value to return if no value is found
   * 
   */
  public String get_prop(final String key, final String value) {
    return this.props.getProperty(key, value);
  }

  /**
   * 
   * Return Property values from Kafka_consumer_props object.
   * 
   * @param key key to look for
   * 
   */
  public String get_prop(final String key) {
    return this.props.getProperty(key);
  }

  /**
   * Return Properties object from Kafka_consumer_props object.
   * 
   */
  public Properties props() {
    return props;
  };

  private void merge_props(final Properties... new_props) {
    for (final Properties np : new_props) {
      final Set<String> names = np.stringPropertyNames();
      for (final String name : names) {
        final String value = np.getProperty(name);
        this.set_prop(name, value);
      }
    }
  }

  /**
   * Transforming properties to JSON string.
   * 
   * @return JSON string
   */
  public String to_json() {
    final Gson gson = new Gson();
    final String props_json = gson.toJson(this.props);
    return props_json;
  };

  /**
   * Transforming properties to JSON string
   * 
   * @return pretty JSON string
   */
  public String to_json_pretty() {
    final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    final String props_json = gson.toJson(this.props);
    return props_json;
  };

  /**
   * Method to set properties from JSON strings
   * 
   * @param json [String] JSON string with properties in format key:value
   */
  public void from_json(final String json) {
    final Gson gson = new Gson();
    final Properties new_props = gson.fromJson(json, Properties.class);
    this.merge_props(new_props);
  };

  /**
   * Set properties from JSON strings.
   * 
   * Allowing to decide whether or not properties stored already should be
   * overwritten.
   * 
   * @param json [String] JSON string with properties in format key:value
   */
  public void from_json(final String json, final Boolean replace) {

    // handle replace option
    if (replace) {
      final Properties new_props = new Properties();
      this.props = new_props;
    }

    // parse JSON and add to this.props
    final Gson gson = new Gson();
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
