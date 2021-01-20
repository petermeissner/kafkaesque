package kafkaesque;


import org.apache.logging.log4j.*;


/**
 * Class to set and check log level of logger
 * 
 */
public class Kafka_logger {

  /**
   * Setting log level
   */
  public void set_log_level(String level) {

    // make casing uniform
    level = level.toLowerCase();

    // declare lvl
    Logger logger = org.apache.logging.log4j.LogManager.getRootLogger();
    Level  lvl    = logger.getLevel();

    // set log level
    switch (level) {
      case "info":
        lvl = org.apache.logging.log4j.Level.INFO;
        break;
      
      case "all": 
        lvl = org.apache.logging.log4j.Level.ALL;
        break;

      case "debug":
        lvl = org.apache.logging.log4j.Level.DEBUG;
        break;

      case "error":
        lvl = org.apache.logging.log4j.Level.ERROR;
        break;

      case "trace":
        lvl = org.apache.logging.log4j.Level.TRACE;
        break;

      case "warn":
        lvl = org.apache.logging.log4j.Level.WARN;
        break;

      default:
        break;
    }
    
    org.apache.logging.log4j.core.config.Configurator.setRootLevel(lvl);
    
  }


  /**
   * Checking log level
   * @return [String] the current log level
   * 
   */
  public String get_log_level() {
    Logger logger = org.apache.logging.log4j.LogManager.getRootLogger();
    return logger.getLevel().toString();
  }
}
  