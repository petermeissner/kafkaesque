package kafkaesque;

import java.util.*;

import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.TopicPartition;

/**
 * Class for kafka offsets
 * 
 * - retrieval - passing to R
 * 
 * 
 * @author retep.meissner@gmail.com
 * 
 */
public class Kafka_offset_arrays {

  public String[] topics;
  public int[] partitions;
  public long[] offsets;


  Kafka_offset_arrays(KafkaConsumer<String, String> parent_consumer) {
    
    // get topic partition offsets
    Set<TopicPartition> tp = parent_consumer.assignment();
    Iterator<TopicPartition> tp_iter = tp.iterator();

    // adjust size of data storage
    this.offsets    = new long[tp.size()];
    this.partitions = new int[tp.size()];
    this.topics     = new String[tp.size()];

    // loop over items
    int i = 0;
    while (tp_iter.hasNext()) {
      // next partition
      TopicPartition tp_item = tp_iter.next();
      
      // gather data 
      offsets[i]    = parent_consumer.position(tp_item);
      partitions[i] = tp_item.partition();
      topics[i]     = tp_item.topic();
      
      // advance counter
      i++;
    }
  }

}
