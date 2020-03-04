package kafkaesque;



/**
 * Class to set and check log level of logger
 * 
 */
public class Kafka_logger {
  
  /**
   * Setting log level
   */
  public void set_log_level(String level) {
    
    // get access to logger used
    ch.qos.logback.classic.Logger root = (ch.qos.logback.classic.Logger) org.slf4j.LoggerFactory
        .getLogger(ch.qos.logback.classic.Logger.ROOT_LOGGER_NAME)
    ;
    
    // set log level
    ch.qos.logback.classic.Level lvl = root.getLevel();
    switch (level) {
      case "info":
        lvl = ch.qos.logback.classic.Level.INFO;
        break;
      
      case "all": 
        lvl = ch.qos.logback.classic.Level.ALL;
        break;

      case "debug":
        lvl = ch.qos.logback.classic.Level.DEBUG;
        break;

      case "error":
        lvl = ch.qos.logback.classic.Level.ERROR;
        break;

      case "trace":
        lvl = ch.qos.logback.classic.Level.TRACE;
        break;

      case "warn":
        lvl = ch.qos.logback.classic.Level.WARN;
        break;

      default:
        break;
    }
    root.setLevel(lvl);
    
  }


  /**
   * Checking log level
   * @return [String] the current log level
   * 
   */
  public String get_log_level() {
    
    // get access to logger used
    ch.qos.logback.classic.Logger root = (ch.qos.logback.classic.Logger) org.slf4j.LoggerFactory
        .getLogger(ch.qos.logback.classic.Logger.ROOT_LOGGER_NAME)
    ;

    return root.getLevel().toString();
  }
}
  