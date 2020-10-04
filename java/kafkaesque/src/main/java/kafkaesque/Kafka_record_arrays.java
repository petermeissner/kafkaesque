package kafkaesque;

import java.util.Objects;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;

/**
 * Class for moving record data from Java to Return
 * 
 * ... this is best done via arrays but those too need some place to get stored in 
 * 
 * 
 * @author retep.meissner@gmail.com
 * 
 */
public class Kafka_record_arrays {

  public String[] keys;
  public String[] values;
  public String[] topic;
  public long[] offsets;  
  public int[] partitions;
  
  public String[] timestamp;
  public String[] timestampType;
  public int[] serializedKeySize ;
  public int[] serializedValueSize;      
  public int[] leaderEpoch ;        


  Kafka_record_arrays (  ConsumerRecords<String, String> records ) {
    
    // get record length for array initialization
    int records_length  = records.count();
    
    // initialize array of correct size 
    this.keys                = new String[records_length];
    this.values              = new String[records_length];
    this.topic               = new String[records_length];
    this.offsets             = new long[records_length];
    this.partitions          = new int[records_length];
    this.timestamp           = new String[records_length];
    this.timestampType       = new String[records_length];
    this.serializedKeySize   = new int[records_length];
    this.serializedValueSize = new int[records_length];      
    this.leaderEpoch         = new int[records_length];       
    
    // get data and put it into arrays
    int counter = 0;
    for ( ConsumerRecord<String, String> record : records ) {
      
      this.keys[counter]                 = record.key();
      this.values[counter]               = record.value();
      this.topic[counter]                = record.topic();
      this.offsets[counter]              = record.offset();
      this.partitions[counter]           = record.partition();
      this.timestamp[counter]            = Objects.toString(record.timestamp(), null);
      this.timestampType[counter]        = record.timestampType().toString();
      this.serializedKeySize[counter]    = record.serializedKeySize();
      this.serializedValueSize[counter]  = record.serializedValueSize();
      this.leaderEpoch[counter]          = record.leaderEpoch().get();

      counter++;
    }
  }

  /**
   * Example usage
   * 
   */
  public static void main(final String... args) throws Exception {

  };

}
