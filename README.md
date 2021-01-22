
<!-- <style>body {max-width: 1100px; margin: auto; padding: 1em; line-height: 20px ;}</style>-->

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- -->

<!-- FILL OUT OPTIONS !!! -->

<!-- -->

<!-- -->

<!-- -->

# Kafka R Bindings via ‘rJava’

**Status**

<img src="https://codecov.io/gh/petermeissner/kafkaesque/branch/master/graph/badge.svg" alt="Codecov" />
<img src="http://www.r-pkg.org/badges/version/kafkaesque">
<img src="http://cranlogs.r-pkg.org/badges/grand-total/kafkaesque">
<img src="http://cranlogs.r-pkg.org/badges/kafkaesque">

*lines of R code:* 677, *lines of Java code:* 570, *lines of test code:*
56

**Version**

0.1.1 ( 2021-01-20 21:54:48 )

**Description**

Provides R bindings for Consumer, Admin and Producer APIs for Kafka via
‘rJava’: “Apache Kafka is an open-source distributed event streaming
platform used by thousands of companies for high-performance data
pipelines, streaming analytics, data integration, and mission-critical
applications.” Kafka is distributed, highly scalable, provides
persistent event storage and is designed for high throughput and low
latency.

**License**

GPL (\>= 3) <br>Peter Meissner \[aut, cre\], Marius Pirv \[aut\],
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

Stable version from CRAN:

``` r
install.packages("kafkaesque")
```

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

    ##  [1] "%>%"                  "gnrndmsg"             "kafka_admin"          "kafka_admin_class"    "kafka_consumer"      
    ##  [6] "kafka_consumer_class" "kafka_get_log_level"  "kafka_producer"       "kafka_producer_class" "kafka_set_log_level"

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
    ## [1] "74ff7435-374b-4ab3-99ad-baf2f0fc3ba9"
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
    ## [1] "74ff7435-374b-4ab3-99ad-baf2f0fc3ba9"
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

    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ## 1: test500000 <NA>         0      0 1611341715806     1    CreateTime           0                -1                   1

### Looping over Messages and Executing Code

``` r
# loop over messages and execute code
res <- 
  consumer$consume_loop(
    expr  = expression(print(msgs)),
    check = expression(counter < 4)
  )
```

    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ## 1: test500000 <NA>         0      1 1611341715806     2    CreateTime           0                -1                   1
    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ## 1: test500000 <NA>         0      2 1611341715806     3    CreateTime           0                -1                   1
    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ## 1: test500000 <NA>         0      3 1611341715806     4    CreateTime           0                -1                   1
    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ## 1: test500000 <NA>         0      4 1611341715806     5    CreateTime           0                -1                   1

``` r
# having a look at the statistics
res
```

    ## $start_time
    ## [1] "2021-01-22 19:55:58 CET"
    ## 
    ## $end_time
    ## [1] "2021-01-22 19:55:58 CET"
    ## 
    ## $n
    ## [1] 4

### Looping over Batches of Messages and Executing Code

``` r
# loop over batches of messages and execute code
res <- 
  consumer$consume_loop(
    expr  = 
      expression({
        print(msgs)
        cat("\n")
      }),
    check = expression(counter < 1000),
    batch = TRUE
  )
```

    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ##   1: test500000 <NA>         0      5 1611341715806     6    CreateTime           0                -1                   1
    ##   2: test500000 <NA>         0      6 1611341715806     7    CreateTime           0                -1                   1
    ##   3: test500000 <NA>         0      7 1611341715806     8    CreateTime           0                -1                   1
    ##   4: test500000 <NA>         0      8 1611341715806     9    CreateTime           0                -1                   1
    ##   5: test500000 <NA>         0      9 1611341715806    10    CreateTime           0                -1                   2
    ##  ---                                                                                                                     
    ## 491: test500000 <NA>         0    495 1611341715807   496    CreateTime           0                -1                   3
    ## 492: test500000 <NA>         0    496 1611341715807   497    CreateTime           0                -1                   3
    ## 493: test500000 <NA>         0    497 1611341715807   498    CreateTime           0                -1                   3
    ## 494: test500000 <NA>         0    498 1611341715807   499    CreateTime           0                -1                   3
    ## 495: test500000 <NA>         0    499 1611341715807   500    CreateTime           0                -1                   3
    ## 
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ##   1: test500000 <NA>         0    500 1611341715807   501    CreateTime           0                -1                   3
    ##   2: test500000 <NA>         0    501 1611341715807   502    CreateTime           0                -1                   3
    ##   3: test500000 <NA>         0    502 1611341715807   503    CreateTime           0                -1                   3
    ##   4: test500000 <NA>         0    503 1611341715807   504    CreateTime           0                -1                   3
    ##   5: test500000 <NA>         0    504 1611341715807   505    CreateTime           0                -1                   3
    ##  ---                                                                                                                     
    ## 496: test500000 <NA>         0    995 1611341715812   996    CreateTime           0                -1                   3
    ## 497: test500000 <NA>         0    996 1611341715812   997    CreateTime           0                -1                   3
    ## 498: test500000 <NA>         0    997 1611341715812   998    CreateTime           0                -1                   3
    ## 499: test500000 <NA>         0    998 1611341715812   999    CreateTime           0                -1                   3
    ## 500: test500000 <NA>         0    999 1611341715812  1000    CreateTime           0                -1                   4
    ## 
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize serializedValueSize
    ##   1: test500000 <NA>         0   1000 1611341715812  1001    CreateTime           0                -1                   4
    ##   2: test500000 <NA>         0   1001 1611341715812  1002    CreateTime           0                -1                   4
    ##   3: test500000 <NA>         0   1002 1611341715812  1003    CreateTime           0                -1                   4
    ##   4: test500000 <NA>         0   1003 1611341715812  1004    CreateTime           0                -1                   4
    ##   5: test500000 <NA>         0   1004 1611341715812  1005    CreateTime           0                -1                   4
    ##  ---                                                                                                                     
    ## 496: test500000 <NA>         0   1495 1611341715812  1496    CreateTime           0                -1                   4
    ## 497: test500000 <NA>         0   1496 1611341715812  1497    CreateTime           0                -1                   4
    ## 498: test500000 <NA>         0   1497 1611341715812  1498    CreateTime           0                -1                   4
    ## 499: test500000 <NA>         0   1498 1611341715812  1499    CreateTime           0                -1                   4
    ## 500: test500000 <NA>         0   1499 1611341715812  1500    CreateTime           0                -1                   4

``` r
res
```

    ## $start_time
    ## [1] "2021-01-22 19:55:58 CET"
    ## 
    ## $end_time
    ## [1] "2021-01-22 19:55:59 CET"
    ## 
    ## $n
    ## [1] 1495

### Offsets and Seeking

``` r
# get current offsets from Kafka
consumer$topics_offsets()
```

    ##         topic partition offset
    ## 1: test500000         0   1500

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

  - {kafkaesque} contains all the R functions, classes and methods and
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
