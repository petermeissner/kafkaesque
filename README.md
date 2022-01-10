
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
has a policy on package size (\<= 5MB) and publishing to CRAN would mean
only publishing the R code without any Java dependencies. One can add an
install function that downloads the necessary JAR files after installing
the package from CRAN. So far no decision has been made if I should
pursue this way or not.

Presentations: 
- User!2021: 
    * video: https://youtu.be/5e7W4ktjASQ?t=2209
- UROS 2020: 
    * slides: https://r-project.ro/conference2020/presentations/Mei%C3%9Fner_web_scraping_at_scale_15min_talk_uros_2020.pdf
    * video: https://youtu.be/THDoBJCM9ZE?t=409


*lines of R code:* 593, *lines of Java code:* 577, *lines of test code:*
580

**Version**

0.1.5 ( 2021-03-21 19:08:23 UTC )

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
Meissner P, Pirv M (2021). kafkaesque: Kafka R Bindings via 'rJava'. R package version 0.1.5.
```

**BibTex for citing**

``` r
toBibtex(citation("kafkaesque"))
```

    @Manual{,
      title = {kafkaesque: Kafka R Bindings via 'rJava'},
      author = {Peter Meissner and Marius Pirv},
      year = {2021},
      note = {R package version 0.1.5},
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

# Prerequisites

For the package to work (more precisely do any significant work) it
needs a running Kafka that can be reached over network.

A simple way to get a test version and the same version used throughout
the README is to run the following docker command ([Link to
Dockerfile](https://github.com/petermeissner/kafkaesque/blob/master/docker/Dockerfile)).

    docker run -p 127.0.0.1:2181:2181 -p 127.0.0.1:9092:9092 petermeissner/kafkatest

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

# Alternatives

There are no viable alternatives at the moment, that I know off.

  - There is
    **[{rkafka}](https://cran.r-project.org/web/packages/rkafka/index.html)**
    which was a invaluable source of inspiration to take the first steps
    in making R talk to Kafka. Its using the {rJava} and Kafka’s Java
    API. Unfortuantly the code does not work with any kind of recent
    versions of Kafka. So basically the package is dead and no
    developement has happened for years.
  - Another attempt has been made with the
    **[{fRanz}](https://github.com/uptake/fRanz)** (refering to the
    author Franz Kafka) using a C++ library under the hood. Unfortunatly
    this started very promissing fast paced but then developement died
    as quickly.

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
    ## $auto.offset.reset
    ## [1] "earliest"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $group.id
    ## [1] "891ee35c-95a7-4fa8-bb9c-ca10b81a7bd8"
    ## 
    ## $value.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
    ## 
    ## $client.id
    ## [1] "kafkaesque_consumer"

``` r
consumer$props(max.poll.records = 200)
```

    ## $key.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
    ## 
    ## $max.poll.records
    ## [1] "200"
    ## 
    ## $auto.offset.reset
    ## [1] "earliest"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $group.id
    ## [1] "891ee35c-95a7-4fa8-bb9c-ca10b81a7bd8"
    ## 
    ## $value.deserializer
    ## [1] "org.apache.kafka.common.serialization.StringDeserializer"
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
    ## 1: test500000 <NA>         0 500000 1641799430491     1    CreateTime           0                -1
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
    ##   1: test500000 <NA>         0 500001 1641799430491     2    CreateTime           0                -1
    ##   2: test500000 <NA>         0 500002 1641799430491     3    CreateTime           0                -1
    ##   3: test500000 <NA>         0 500003 1641799430491     4    CreateTime           0                -1
    ##   4: test500000 <NA>         0 500004 1641799430491     5    CreateTime           0                -1
    ##   5: test500000 <NA>         0 500005 1641799430491     6    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 495: test500000 <NA>         0 500495 1641799430492   496    CreateTime           0                -1
    ## 496: test500000 <NA>         0 500496 1641799430492   497    CreateTime           0                -1
    ## 497: test500000 <NA>         0 500497 1641799430492   498    CreateTime           0                -1
    ## 498: test500000 <NA>         0 500498 1641799430492   499    CreateTime           0                -1
    ## 499: test500000 <NA>         0 500499 1641799430492   500    CreateTime           0                -1
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
    ##   1: test500000 <NA>         0 500500 1641799430492   501    CreateTime           0                -1
    ##   2: test500000 <NA>         0 500501 1641799430492   502    CreateTime           0                -1
    ##   3: test500000 <NA>         0 500502 1641799430492   503    CreateTime           0                -1
    ##   4: test500000 <NA>         0 500503 1641799430492   504    CreateTime           0                -1
    ##   5: test500000 <NA>         0 500504 1641799430492   505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 500995 1641799430492   996    CreateTime           0                -1
    ## 497: test500000 <NA>         0 500996 1641799430492   997    CreateTime           0                -1
    ## 498: test500000 <NA>         0 500997 1641799430492   998    CreateTime           0                -1
    ## 499: test500000 <NA>         0 500998 1641799430492   999    CreateTime           0                -1
    ## 500: test500000 <NA>         0 500999 1641799430492  1000    CreateTime           0                -1
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
    ##   1: test500000 <NA>         0 501000 1641799430492  1001    CreateTime           0                -1
    ##   2: test500000 <NA>         0 501001 1641799430492  1002    CreateTime           0                -1
    ##   3: test500000 <NA>         0 501002 1641799430492  1003    CreateTime           0                -1
    ##   4: test500000 <NA>         0 501003 1641799430492  1004    CreateTime           0                -1
    ##   5: test500000 <NA>         0 501004 1641799430492  1005    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 501495 1641799430493  1496    CreateTime           0                -1
    ## 497: test500000 <NA>         0 501496 1641799430493  1497    CreateTime           0                -1
    ## 498: test500000 <NA>         0 501497 1641799430493  1498    CreateTime           0                -1
    ## 499: test500000 <NA>         0 501498 1641799430493  1499    CreateTime           0                -1
    ## 500: test500000 <NA>         0 501499 1641799430493  1500    CreateTime           0                -1
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
    ##   1: test500000 <NA>         0 501500 1641799430493  1501    CreateTime           0                -1
    ##   2: test500000 <NA>         0 501501 1641799430493  1502    CreateTime           0                -1
    ##   3: test500000 <NA>         0 501502 1641799430493  1503    CreateTime           0                -1
    ##   4: test500000 <NA>         0 501503 1641799430493  1504    CreateTime           0                -1
    ##   5: test500000 <NA>         0 501504 1641799430493  1505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 501995 1641799430493  1996    CreateTime           0                -1
    ## 497: test500000 <NA>         0 501996 1641799430493  1997    CreateTime           0                -1
    ## 498: test500000 <NA>         0 501997 1641799430493  1998    CreateTime           0                -1
    ## 499: test500000 <NA>         0 501998 1641799430493  1999    CreateTime           0                -1
    ## 500: test500000 <NA>         0 501999 1641799430493  2000    CreateTime           0                -1
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
    ## [1] "2022-01-10 08:25:17 CET"
    ## 
    ## $meta$loop_counter
    ## [1] 4
    ## 
    ## $meta$start_time
    ## [1] "2022-01-10 08:25:17 CET"
    ## 
    ## $meta$message_counter
    ## [1] 1999
    ## 
    ## 
    ## $messages
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0 501500 1641799430493  1501    CreateTime           0                -1
    ##   2: test500000 <NA>         0 501501 1641799430493  1502    CreateTime           0                -1
    ##   3: test500000 <NA>         0 501502 1641799430493  1503    CreateTime           0                -1
    ##   4: test500000 <NA>         0 501503 1641799430493  1504    CreateTime           0                -1
    ##   5: test500000 <NA>         0 501504 1641799430493  1505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 501995 1641799430493  1996    CreateTime           0                -1
    ## 497: test500000 <NA>         0 501996 1641799430493  1997    CreateTime           0                -1
    ## 498: test500000 <NA>         0 501997 1641799430493  1998    CreateTime           0                -1
    ## 499: test500000 <NA>         0 501998 1641799430493  1999    CreateTime           0                -1
    ## 500: test500000 <NA>         0 501999 1641799430493  2000    CreateTime           0                -1
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
    ##   1: test500000 <NA>         0 502000 1641799430493  2001    CreateTime           0                -1
    ##   2: test500000 <NA>         0 502001 1641799430493  2002    CreateTime           0                -1
    ##   3: test500000 <NA>         0 502002 1641799430493  2003    CreateTime           0                -1
    ##   4: test500000 <NA>         0 502003 1641799430493  2004    CreateTime           0                -1
    ##   5: test500000 <NA>         0 502004 1641799430493  2005    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 502495 1641799430493  2496    CreateTime           0                -1
    ## 497: test500000 <NA>         0 502496 1641799430493  2497    CreateTime           0                -1
    ## 498: test500000 <NA>         0 502497 1641799430493  2498    CreateTime           0                -1
    ## 499: test500000 <NA>         0 502498 1641799430493  2499    CreateTime           0                -1
    ## 500: test500000 <NA>         0 502499 1641799430493  2500    CreateTime           0                -1
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
    ##   1: test500000 <NA>         0 502500 1641799430493  2501    CreateTime           0                -1
    ##   2: test500000 <NA>         0 502501 1641799430493  2502    CreateTime           0                -1
    ##   3: test500000 <NA>         0 502502 1641799430493  2503    CreateTime           0                -1
    ##   4: test500000 <NA>         0 502503 1641799430493  2504    CreateTime           0                -1
    ##   5: test500000 <NA>         0 502504 1641799430493  2505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 502995 1641799430494  2996    CreateTime           0                -1
    ## 497: test500000 <NA>         0 502996 1641799430494  2997    CreateTime           0                -1
    ## 498: test500000 <NA>         0 502997 1641799430494  2998    CreateTime           0                -1
    ## 499: test500000 <NA>         0 502998 1641799430494  2999    CreateTime           0                -1
    ## 500: test500000 <NA>         0 502999 1641799430494  3000    CreateTime           0                -1
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
    ## [1] "2022-01-10 08:25:17 CET"
    ## 
    ## $meta$loop_counter
    ## [1] 2
    ## 
    ## $meta$start_time
    ## [1] "2022-01-10 08:25:17 CET"
    ## 
    ## $meta$message_counter
    ## [1] 1000
    ## 
    ## 
    ## $messages
    ##           topic  key partition offset     timestamp value timestampType leaderEpoch serializedKeySize
    ##   1: test500000 <NA>         0 502500 1641799430493  2501    CreateTime           0                -1
    ##   2: test500000 <NA>         0 502501 1641799430493  2502    CreateTime           0                -1
    ##   3: test500000 <NA>         0 502502 1641799430493  2503    CreateTime           0                -1
    ##   4: test500000 <NA>         0 502503 1641799430493  2504    CreateTime           0                -1
    ##   5: test500000 <NA>         0 502504 1641799430493  2505    CreateTime           0                -1
    ##  ---                                                                                                 
    ## 496: test500000 <NA>         0 502995 1641799430494  2996    CreateTime           0                -1
    ## 497: test500000 <NA>         0 502996 1641799430494  2997    CreateTime           0                -1
    ## 498: test500000 <NA>         0 502997 1641799430494  2998    CreateTime           0                -1
    ## 499: test500000 <NA>         0 502998 1641799430494  2999    CreateTime           0                -1
    ## 500: test500000 <NA>         0 502999 1641799430494  3000    CreateTime           0                -1
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
    ## 1: test500000         0 503000

``` r
# seek to end of topics 
consumer$topics_seek_to_end()
consumer$topics_offsets()
```

    ##         topic partition  offset
    ## 1: test500000         0 1000000

``` r
# seek to beginning of topics
consumer$topics_seek_to_beginning()
consumer$topics_offsets()
```

    ##         topic partition offset
    ## 1: test500000         0 500000

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

    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $value.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"
    ## 
    ## $client.id
    ## [1] "kafkaesque_producer"
    ## 
    ## $key.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"

``` r
producer$props(whatever.you.may.want.to.set = "true")
```

    ## $whatever.you.may.want.to.set
    ## [1] "true"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $value.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"
    ## 
    ## $client.id
    ## [1] "kafkaesque_producer"
    ## 
    ## $key.serializer
    ## [1] "org.apache.kafka.common.serialization.StringSerializer"

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
