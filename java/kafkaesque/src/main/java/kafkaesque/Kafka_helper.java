package kafkaesque;

import java.lang.reflect.*;

/**
 * Shell Object to spin up consumer, change config, send messages and close it again
 */
public class Kafka_helper {

  public static void test () {
    System.out.println("\ntest passed");
  }

  public static void print_class (Object obj) {
    System.out.println(obj.getClass());
  }

  public static void print_methods(Object obj){
    Method[] methods = obj.getClass().getDeclaredMethods();

    for (int i = 0; i < methods.length; i++) {
        System.out.println(methods[i].toString());
    }
  }

}
