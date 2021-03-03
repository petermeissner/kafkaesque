
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

*lines of R code:* 677, *lines of Java code:* 570, *lines of test code:*
123

**Version**

0.1.1 ( 2021-03-03 20:43:43 )

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
    ## [1] "7593de2c-a9ce-4806-abc5-a87a600e50e8"
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
    ## [1] "7593de2c-a9ce-4806-abc5-a87a600e50e8"
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
    ## 1: test500000 <NA>         0      0 1614803776564     1    CreateTime           0                -1
    ##    serializedValueSize
    ## 1:                   1

### Looping over Messages and Executing Code

``` r
# loop over messages and execute code
res <- 
  consumer$consume_loop(
    expr  = expression(print(msgs)),
    check = expression(counter < 4)
  )
```

    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ## 1: test500000 <NA>         0      1 1614803776564     2    CreateTime           0                -1
    ##    serializedValueSize
    ## 1:                   1
    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ## 1: test500000 <NA>         0      2 1614803776564     3    CreateTime           0                -1
    ##    serializedValueSize
    ## 1:                   1
    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ## 1: test500000 <NA>         0      3 1614803776564     4    CreateTime           0                -1
    ##    serializedValueSize
    ## 1:                   1
    ##         topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ## 1: test500000 <NA>         0      4 1614803776564     5    CreateTime           0                -1
    ##    serializedValueSize
    ## 1:                   1

``` r
# having a look at the statistics
res
```

    ## $start_time
    ## [1] "2021-03-03 21:44:22 CET"
    ## 
    ## $end_time
    ## [1] "2021-03-03 21:44:22 CET"
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

    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0      5 1614803776564     6    CreateTime           0                -1
    ##   2: test500000 <NA>         0      6 1614803776564     7    CreateTime           0                -1
    ##   3: test500000 <NA>         0      7 1614803776564     8    CreateTime           0                -1
    ##   4: test500000 <NA>         0      8 1614803776564     9    CreateTime           0                -1
    ##   5: test500000 <NA>         0      9 1614803776564    10    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 491: test500000 <NA>         0    495 1614803776564   496    CreateTime           0                -1
    ## 492: test500000 <NA>         0    496 1614803776564   497    CreateTime           0                -1
    ## 493: test500000 <NA>         0    497 1614803776564   498    CreateTime           0                -1
    ## 494: test500000 <NA>         0    498 1614803776564   499    CreateTime           0                -1
    ## 495: test500000 <NA>         0    499 1614803776564   500    CreateTime           0                -1
    ##      serializedValueSize
    ##   1:                   1
    ##   2:                   1
    ##   3:                   1
    ##   4:                   1
    ##   5:                   2
    ##  ---                    
    ## 491:                   3
    ## 492:                   3
    ## 493:                   3
    ## 494:                   3
    ## 495:                   3
    ## 
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0    500 1614803776564   501    CreateTime           0                -1
    ##   2: test500000 <NA>         0    501 1614803776564   502    CreateTime           0                -1
    ##   3: test500000 <NA>         0    502 1614803776565   503    CreateTime           0                -1
    ##   4: test500000 <NA>         0    503 1614803776565   504    CreateTime           0                -1
    ##   5: test500000 <NA>         0    504 1614803776565   505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0    995 1614803776565   996    CreateTime           0                -1
    ## 497: test500000 <NA>         0    996 1614803776565   997    CreateTime           0                -1
    ## 498: test500000 <NA>         0    997 1614803776565   998    CreateTime           0                -1
    ## 499: test500000 <NA>         0    998 1614803776565   999    CreateTime           0                -1
    ## 500: test500000 <NA>         0    999 1614803776565  1000    CreateTime           0                -1
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
    ## 
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0   1000 1614803776565  1001    CreateTime           0                -1
    ##   2: test500000 <NA>         0   1001 1614803776565  1002    CreateTime           0                -1
    ##   3: test500000 <NA>         0   1002 1614803776565  1003    CreateTime           0                -1
    ##   4: test500000 <NA>         0   1003 1614803776565  1004    CreateTime           0                -1
    ##   5: test500000 <NA>         0   1004 1614803776565  1005    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0   1495 1614803776565  1496    CreateTime           0                -1
    ## 497: test500000 <NA>         0   1496 1614803776565  1497    CreateTime           0                -1
    ## 498: test500000 <NA>         0   1497 1614803776565  1498    CreateTime           0                -1
    ## 499: test500000 <NA>         0   1498 1614803776565  1499    CreateTime           0                -1
    ## 500: test500000 <NA>         0   1499 1614803776565  1500    CreateTime           0                -1
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

    ## $start_time
    ## [1] "2021-03-03 21:44:22 CET"
    ## 
    ## $end_time
    ## [1] "2021-03-03 21:44:22 CET"
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
