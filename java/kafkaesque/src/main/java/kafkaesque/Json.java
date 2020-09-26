package kafkaesque;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;


public class Json {
  
  public static String to_json(Object obj){
    Gson gson = new Gson();
    return gson.toJson(obj);
  }
  
  public static String to_json_pretty(Object obj){
    Gson gson = new GsonBuilder().setPrettyPrinting().create();
    return gson.toJson(obj);
  }

}
