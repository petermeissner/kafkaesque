
<!-- <style>body {max-width: 1100px; margin: auto; padding: 1em; line-height: 20px ;}</style>-->

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- -->
<!-- FILL OUT OPTIONS !!! -->
<!-- -->
<!-- -->
<!-- -->

# Kafka R Bindings via ‘rJava’

**Status**

[![codecov](https://codecov.io/gh/petermeissner/kafkaesque/branch/master/graph/badge.svg?token=jzamre15u6)](https://codecov.io/gh/petermeissner/kafkaesque)<!--<img src="http://www.r-pkg.org/badges/version/kafkaesque"><img src="http://cranlogs.r-pkg.org/badges/grand-total/kafkaesque"><img src="http://cranlogs.r-pkg.org/badges/kafkaesque">-->[![Check,
Test,
Lint](https://github.com/petermeissner/kafkaesque/actions/workflows/tests.yml/badge.svg)](https://github.com/petermeissner/kafkaesque/actions/workflows/tests.yml)

This package is - so far - feature complete and should be functional.
This is a structured extract and rewrite from client work. Though core
parts of the package are used in production and are ‘battle tested’ the
package presented here is not - so far.

Package has not been published to CRAN. Attempts have been made. CRAN
has a policy on package size (&lt;= 5MB) and publishing to CRAN would
mean only publishing the R code without any Java dependencies. One can
add an install function that downloads the necessary JAR files after
installing the package from CRAN. So far no decision has been made if I
should pursue this way or not.

*lines of R code:* 593, *lines of Java code:* 570, *lines of test code:*
237

**Version**

0.1.1 ( 2021-03-16 22:22:24 )

**Description**

Provides R bindings for Consumer, Admin and Producer APIs for Kafka via
‘rJava’: “Apache Kafka is an open-source distributed event streaming
platform used by thousands of companies for high-performance data
pipelines, streaming analytics, data integration, and mission-critical
applications.” Kafka is distributed, highly scalable, provides
persistent event storage and is designed for high throughput and low
latency.

**License**

GPL (&gt;= 3) <br>Peter Meissner \[aut, cre\], Marius Pirv \[aut\],
virtual7 \[cph\]

**Citation**

``` r
citation("kafkaesque")
```

``` r
Meissner P, Pirv M (2021). kafkaesque: Kafka R Bindings via 'rJava'. R package version 0.1.1.
```

**BibTex for citing**

``` r
toBibtex(citation("kafkaesque"))
```

    @Manual{,
      title = {kafkaesque: Kafka R Bindings via 'rJava'},
      author = {Peter Meissner and Marius Pirv},
      year = {2021},
      note = {R package version 0.1.1},
    }

**Installation**

<!-- Stable version from CRAN: -->
<!-- ```{r, results='asis', echo=FALSE} -->
<!-- cat("```r\n") -->
<!-- cat("install.packages(\"",package_name,"\")", sep = "") -->
<!-- cat("\n```\n") -->
<!-- ``` -->

Latest development version from Github:

``` r
devtools::install_github("petermeissner/kafkaesque")
```

<!-- # ToDos -->
<!-- ```{r, results='asis'} -->
<!-- md_list(kafkaesque:::todo) -->
<!-- ``` -->

# Content

``` r
library(kafkaesque)
```

    ## Loading required package: rJava

``` r
ls("package:kafkaesque")
```

    ##  [1] "%>%"                  "gnrndmsg"             "kafka_admin"          "kafka_admin_class"   
    ##  [5] "kafka_consumer"       "kafka_consumer_class" "kafka_get_log_level"  "kafka_producer"      
    ##  [9] "kafka_producer_class" "kafka_set_log_level"

# Usage

## Consumer

### Start Consumer (… Stop, Status)

``` r
library("kafkaesque")

# new consumer
consumer <- kafka_consumer()

# starting/connecting - + status
consumer$start()

consumer$running()
```

    ## [1] TRUE

``` r
consumer$end()$running()
```

    ## [1] FALSE

``` r
consumer$start()$running()
```

    ## [1] TRUE

### Properties aka Config

See here for list of consumer properties:
<https://kafka.apache.org/documentation/#consumerconfigs>.

``` r
consumer$props()
```

    ## $key.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
    ## 
    ## $value.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
    ## 
    ## $group.id
    ## [1] "80fc5c16-5096-4d73-805a-8d9c965562dc"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $auto.offset.reset
    ## [1] "earliest"
    ## 
    ## $client.id
    ## [1] "kafkaesque_consumer"

``` r
consumer$props(max.poll.records = 200)
```

    ## $key.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
    ## 
    ## $value.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
    ## 
    ## $max.poll.records
    ## [1] "200"
    ## 
    ## $group.id
    ## [1] "80fc5c16-5096-4d73-805a-8d9c965562dc"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $auto.offset.reset
    ## [1] "earliest"
    ## 
    ## $client.id
    ## [1] "kafkaesque_consumer"

### Topics and Subscriptions

``` r
# list topics available to consumer
consumer$topics_list()
```

    ## [1] "test500000" "test2"      "test3"      "test"

``` r
# subscribe to topic
consumer$topics_subscribe("test500000")
consumer$topics_subscription()
```

    ## [1] "test500000"

### Retrieving a Message

``` r
# retrieve next message
consumer$consume_next()
```

    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ## 1: test500000 <NA>         0      0 1615930914705     1    CreateTime           0                -1
    ##    serializedValueSize
    ## 1:                   1

### Looping over Messages and Executing Code

``` r
# loop over messages and execute code
res <- 
  consumer$consume_loop(
    f     = function(loop_env){ print(loop_env$messages)},
    check = function(loop_env){loop_env$meta$loop_counter < 4},
    batch = TRUE
  )
```

    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0      1 1615930914705     2    CreateTime           0                -1
    ##   2: test500000 <NA>         0      2 1615930914705     3    CreateTime           0                -1
    ##   3: test500000 <NA>         0      3 1615930914705     4    CreateTime           0                -1
    ##   4: test500000 <NA>         0      4 1615930914705     5    CreateTime           0                -1
    ##   5: test500000 <NA>         0      5 1615930914705     6    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 495: test500000 <NA>         0    495 1615930914705   496    CreateTime           0                -1
    ## 496: test500000 <NA>         0    496 1615930914705   497    CreateTime           0                -1
    ## 497: test500000 <NA>         0    497 1615930914705   498    CreateTime           0                -1
    ## 498: test500000 <NA>         0    498 1615930914705   499    CreateTime           0                -1
    ## 499: test500000 <NA>         0    499 1615930914705   500    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   1
    ##   2:                   1
    ##   3:                   1
    ##   4:                   1
    ##   5:                   1
    ##  ---                    
    ## 495:                   3
    ## 496:                   3
    ## 497:                   3
    ## 498:                   3
    ## 499:                   3
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0    500 1615930914705   501    CreateTime           0                -1
    ##   2: test500000 <NA>         0    501 1615930914705   502    CreateTime           0                -1
    ##   3: test500000 <NA>         0    502 1615930914705   503    CreateTime           0                -1
    ##   4: test500000 <NA>         0    503 1615930914705   504    CreateTime           0                -1
    ##   5: test500000 <NA>         0    504 1615930914705   505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0    995 1615930914706   996    CreateTime           0                -1
    ## 497: test500000 <NA>         0    996 1615930914706   997    CreateTime           0                -1
    ## 498: test500000 <NA>         0    997 1615930914706   998    CreateTime           0                -1
    ## 499: test500000 <NA>         0    998 1615930914706   999    CreateTime           0                -1
    ## 500: test500000 <NA>         0    999 1615930914706  1000    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   3
    ##   2:                   3
    ##   3:                   3
    ##   4:                   3
    ##   5:                   3
    ##  ---                    
    ## 496:                   3
    ## 497:                   3
    ## 498:                   3
    ## 499:                   3
    ## 500:                   4
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   1000 1615930914706  1001    CreateTime           0                -1
    ##   2: test500000 <NA>         0   1001 1615930914706  1002    CreateTime           0                -1
    ##   3: test500000 <NA>         0   1002 1615930914706  1003    CreateTime           0                -1
    ##   4: test500000 <NA>         0   1003 1615930914706  1004    CreateTime           0                -1
    ##   5: test500000 <NA>         0   1004 1615930914706  1005    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   1495 1615930914706  1496    CreateTime           0                -1
    ## 497: test500000 <NA>         0   1496 1615930914706  1497    CreateTime           0                -1
    ## 498: test500000 <NA>         0   1497 1615930914706  1498    CreateTime           0                -1
    ## 499: test500000 <NA>         0   1498 1615930914706  1499    CreateTime           0                -1
    ## 500: test500000 <NA>         0   1499 1615930914706  1500    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   4
    ##   2:                   4
    ##   3:                   4
    ##   4:                   4
    ##   5:                   4
    ##  ---                    
    ## 496:                   4
    ## 497:                   4
    ## 498:                   4
    ## 499:                   4
    ## 500:                   4
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   1500 1615930914706  1501    CreateTime           0                -1
    ##   2: test500000 <NA>         0   1501 1615930914706  1502    CreateTime           0                -1
    ##   3: test500000 <NA>         0   1502 1615930914706  1503    CreateTime           0                -1
    ##   4: test500000 <NA>         0   1503 1615930914706  1504    CreateTime           0                -1
    ##   5: test500000 <NA>         0   1504 1615930914706  1505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   1995 1615930914706  1996    CreateTime           0                -1
    ## 497: test500000 <NA>         0   1996 1615930914706  1997    CreateTime           0                -1
    ## 498: test500000 <NA>         0   1997 1615930914706  1998    CreateTime           0                -1
    ## 499: test500000 <NA>         0   1998 1615930914706  1999    CreateTime           0                -1
    ## 500: test500000 <NA>         0   1999 1615930914706  2000    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   4
    ##   2:                   4
    ##   3:                   4
    ##   4:                   4
    ##   5:                   4
    ##  ---                    
    ## 496:                   4
    ## 497:                   4
    ## 498:                   4
    ## 499:                   4
    ## 500:                   4

``` r
# having a look at the statistics
res
```

    ## $meta
    ## $meta$end_time
    ## [1] "2021-03-16 23:34:20 CET"
    ## 
    ## $meta$loop_counter
    ## [1] 4
    ## 
    ## $meta$start_time
    ## [1] "2021-03-16 23:34:20 CET"
    ## 
    ## $meta$message_counter
    ## [1] 1999
    ## 
    ## 
    ## $messages
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   1500 1615930914706  1501    CreateTime           0                -1
    ##   2: test500000 <NA>         0   1501 1615930914706  1502    CreateTime           0                -1
    ##   3: test500000 <NA>         0   1502 1615930914706  1503    CreateTime           0                -1
    ##   4: test500000 <NA>         0   1503 1615930914706  1504    CreateTime           0                -1
    ##   5: test500000 <NA>         0   1504 1615930914706  1505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   1995 1615930914706  1996    CreateTime           0                -1
    ## 497: test500000 <NA>         0   1996 1615930914706  1997    CreateTime           0                -1
    ## 498: test500000 <NA>         0   1997 1615930914706  1998    CreateTime           0                -1
    ## 499: test500000 <NA>         0   1998 1615930914706  1999    CreateTime           0                -1
    ## 500: test500000 <NA>         0   1999 1615930914706  2000    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   4
    ##   2:                   4
    ##   3:                   4
    ##   4:                   4
    ##   5:                   4
    ##  ---                    
    ## 496:                   4
    ## 497:                   4
    ## 498:                   4
    ## 499:                   4
    ## 500:                   4

### Looping over Batches of Messages and Executing Code

``` r
# loop over batches of messages and execute code
res <- 
  consumer$consume_loop(
    f     = function(loop_env){ print(loop_env$messages); cat("\n")},
    check = function(loop_env){loop_env$meta$message_counter < 1000},
    batch = TRUE
  )
```

    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   2000 1615930914706  2001    CreateTime           0                -1
    ##   2: test500000 <NA>         0   2001 1615930914706  2002    CreateTime           0                -1
    ##   3: test500000 <NA>         0   2002 1615930914706  2003    CreateTime           0                -1
    ##   4: test500000 <NA>         0   2003 1615930914706  2004    CreateTime           0                -1
    ##   5: test500000 <NA>         0   2004 1615930914706  2005    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   2495 1615930914706  2496    CreateTime           0                -1
    ## 497: test500000 <NA>         0   2496 1615930914706  2497    CreateTime           0                -1
    ## 498: test500000 <NA>         0   2497 1615930914706  2498    CreateTime           0                -1
    ## 499: test500000 <NA>         0   2498 1615930914706  2499    CreateTime           0                -1
    ## 500: test500000 <NA>         0   2499 1615930914706  2500    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   4
    ##   2:                   4
    ##   3:                   4
    ##   4:                   4
    ##   5:                   4
    ##  ---                    
    ## 496:                   4
    ## 497:                   4
    ## 498:                   4
    ## 499:                   4
    ## 500:                   4
    ## 
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   2500 1615930914706  2501    CreateTime           0                -1
    ##   2: test500000 <NA>         0   2501 1615930914706  2502    CreateTime           0                -1
    ##   3: test500000 <NA>         0   2502 1615930914706  2503    CreateTime           0                -1
    ##   4: test500000 <NA>         0   2503 1615930914706  2504    CreateTime           0                -1
    ##   5: test500000 <NA>         0   2504 1615930914706  2505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   2995 1615930914706  2996    CreateTime           0                -1
    ## 497: test500000 <NA>         0   2996 1615930914706  2997    CreateTime           0                -1
    ## 498: test500000 <NA>         0   2997 1615930914706  2998    CreateTime           0                -1
    ## 499: test500000 <NA>         0   2998 1615930914706  2999    CreateTime           0                -1
    ## 500: test500000 <NA>         0   2999 1615930914706  3000    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   4
    ##   2:                   4
    ##   3:                   4
    ##   4:                   4
    ##   5:                   4
    ##  ---                    
    ## 496:                   4
    ## 497:                   4
    ## 498:                   4
    ## 499:                   4
    ## 500:                   4

``` r
res
```

    ## $meta
    ## $meta$end_time
    ## [1] "2021-03-16 23:34:20 CET"
    ## 
    ## $meta$loop_counter
    ## [1] 2
    ## 
    ## $meta$start_time
    ## [1] "2021-03-16 23:34:20 CET"
    ## 
    ## $meta$message_counter
    ## [1] 1000
    ## 
    ## 
    ## $messages
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   2500 1615930914706  2501    CreateTime           0                -1
    ##   2: test500000 <NA>         0   2501 1615930914706  2502    CreateTime           0                -1
    ##   3: test500000 <NA>         0   2502 1615930914706  2503    CreateTime           0                -1
    ##   4: test500000 <NA>         0   2503 1615930914706  2504    CreateTime           0                -1
    ##   5: test500000 <NA>         0   2504 1615930914706  2505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   2995 1615930914706  2996    CreateTime           0                -1
    ## 497: test500000 <NA>         0   2996 1615930914706  2997    CreateTime           0                -1
    ## 498: test500000 <NA>         0   2997 1615930914706  2998    CreateTime           0                -1
    ## 499: test500000 <NA>         0   2998 1615930914706  2999    CreateTime           0                -1
    ## 500: test500000 <NA>         0   2999 1615930914706  3000    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   4
    ##   2:                   4
    ##   3:                   4
    ##   4:                   4
    ##   5:                   4
    ##  ---                    
    ## 496:                   4
    ## 497:                   4
    ## 498:                   4
    ## 499:                   4
    ## 500:                   4

### Offsets and Seeking

``` r
# get current offsets from Kafka
consumer$topics_offsets()
```

    ##         topic partition offset
    ## 1: test500000         0   3000

``` r
# seek to end of topics 
consumer$topics_seek_to_end()
consumer$topics_offsets()
```

    ##         topic partition offset
    ## 1: test500000         0 500000

``` r
# seek to beginning of topics
consumer$topics_seek_to_beginning()
consumer$topics_offsets()
```

    ##         topic partition offset
    ## 1: test500000         0      0

## Producer

### Start Producer (… Stop, Status)

``` r
library("kafkaesque")

# new producer
producer <- kafka_producer()

# starting/connecting - + status
producer$start()

producer$running()
```

    ## [1] TRUE

``` r
producer$end()$running()
```

    ## [1] FALSE

``` r
producer$start()$running()
```

    ## [1] TRUE

``` r
producer$restart()$running()
```

    ## [1] TRUE

### Properties aka Config

See here for list of consumer properties:
<https://kafka.apache.org/documentation/#producerconfigs>.

``` r
producer$props()
```

    ## $value.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $key.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"
    ## 
    ## $client.id
    ## [1] "kafkaesque_producer"

``` r
producer$props(whatever.you.may.want.to.set = "true")
```

    ## $value.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"
    ## 
    ## $whatever.you.may.want.to.set
    ## [1] "true"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $key.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"
    ## 
    ## $client.id
    ## [1] "kafkaesque_producer"

### Sending Messages

``` r
producer$send(topic = "test", msg = "Die Kuh macht muh.")
producer$send(topic = "test", msg = "Das Schaf macht mäh.")
producer$send(topic = "test", msg = "Das Pferd macht wihiiiiiiiii-pffffff.")
```

## Setting and Getting Java-LogLEvels

``` r
kafka_get_log_level()
```

    ## [1] "ERROR"

``` r
# one of off, fatal, error, warn, info, debug, trace, all
kafka_set_log_level("info")
```

    ## [1] "INFO"

``` r
producer$start()


# set back to normal
kafka_set_log_level("error")
```

    ## [1] "ERROR"

## Admin

### Properties aka Config

``` r
admin <- kafka_admin()
admin$start()

admin$props()
```

    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $client.id
    ## [1] "kafkaesque_admin"

``` r
admin$props(whatever.you.may.want.to.set = "true")
```

    ## $whatever.you.may.want.to.set
    ## [1] "true"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $client.id
    ## [1] "kafkaesque_admin"

### Get List of Topics

``` r
admin$topics_list()
```

    ## [1] "test500000" "test2"      "test3"      "test"

### Create Topics

``` r
admin$topics_list()
```

    ## [1] "test500000" "test2"      "test3"      "test"

``` r
topics <- c("chuckle", "chit_chat")
admin$topics_create(
  topic              = topics, 
  partition         = c(1L, 1L), 
  replication_factor = c(1L, 1L)
)
```

    ## [1] "chuckle"    "test500000" "test2"      "test3"      "test"       "chit_chat"

### Delete Topics

``` r
admin$topics_delete(topics)
```

    ## [1] "test500000" "test2"      "test3"      "test"

# Developement Notes

For R development Rstudio was used. For Java development Visual Studio
Code lend a helping hand with Maven as build tooling.

For development one packages is needed:

-   {kafkaesque} contains all the R functions, classes and methods and
    also all Java code that is specific to this project (and not just a
    dependency)

Java sources are in `./java/kafkaesque/` folder - so your Java project
should take this as root folder. Building Java sources can be done via
Maven: `mvn install` will compile everything and copy the
`kafkaesque.jar` into the package’s `./inst/java/` folder with all its
java dependencies.

After Java compilation, the R packages has to be (re-)build and
(re-)installed (with most likely re-starting the R session frist
(Ctrl-Shift-F10 in Rstudio)).

If developing Java in VScode - as I did here - pressing Ctr-Shift-B
should allow to select the two most important tasks: resolving
dependencies and compiling the Java code and distributing it to the
right places as described above.
