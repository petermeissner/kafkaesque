
<style>body {max-width: 1100px; margin: auto; padding: 1em; line-height: 20px ;}</style>

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- -->

<!-- FILL OUT OPTIONS !!! -->

<!-- -->

<!-- -->

<!-- -->

# Kafka R Bindings via ‘rJava’

**Status**

<a href="https://travis-ci.org/petermeissner/kafkaesque"><img src="https://api.travis-ci.org/petermeissner/kafkaesque.svg?branch=master"><a/>
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/petermeissner/kafkaesque?branch=master&svg=true)](https://ci.appveyor.com/project/petermeissner/kafkaesque)
<a href="https://codecov.io/gh/petermeissner/kafkaesque"><img src="https://codecov.io/gh/petermeissner/kafkaesque/branch/master/graph/badge.svg" alt="Codecov" /></a>
<a href="https://cran.r-project.org/package=kafkaesque">
<img src="http://www.r-pkg.org/badges/version/kafkaesque"> </a>
<img src="http://cranlogs.r-pkg.org/badges/grand-total/kafkaesque">
<img src="http://cranlogs.r-pkg.org/badges/kafkaesque">

*lines of R code:* 357, *lines of test code:* 46

**Version**

0.1.0 ( 2020-10-03 03:25:05 )

**Description**

Provides R bindings via ‘rJava’ for Kafka. Kafka is a event log data
base to which messages can be published or read from topics subscribed
to. Kafka is distributed, highly scalable, provides persistent event
storage and is designed for high throughput.

**License**

GPL-3 <br>Peter Meissner \[aut, cre\], Marius Pirv \[aut\], virtual7
\[cph\]

**Citation**

``` r
citation("kafkaesque")
```

``` r
Meissner P, Pirv M (2020). kafkaesque: Kafka R Bindings via 'rJava'. R package version 0.1.0.
```

**BibTex for citing**

``` r
toBibtex(citation("kafkaesque"))
```

    @Manual{,
      title = {kafkaesque: Kafka R Bindings via 'rJava'},
      author = {Peter Meissner and Marius Pirv},
      year = {2020},
      note = {R package version 0.1.0},
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

# ToDos

``` r
kafkaesque::todo
```

    ## $consumer
    ## $consumer[[1]]
    ## [1] "change offset: first, last, i"
    ## 
    ## $consumer[[2]]
    ## [1] "otpions/proporties"
    ## 
    ## $consumer[[3]]
    ## [1] "pin point and solve encoding problems "
    ## 
    ## 
    ## $general
    ## $general[[1]]
    ## [1] "serialize records back and forth: "

# Content

``` r
library(kafkaesque)
```

    ## Loading required package: rJava

    ## Loading required package: kafkaesquejars

``` r
ls("package:kafkaesque")
```

    ## [1] "%>%"                  "java_class"           "java_methods"         "kafka_consumer"      
    ## [5] "kafka_consumer_class" "kafka_producer"       "kafka_set_log_level"  "todo"

# Usage

## Start Consumer (… Stop, Status)

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

## Properties aka Config

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
    ## [1] "2417f3e9-7944-474b-a8df-044d2d231754"
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
    ## [1] "2417f3e9-7944-474b-a8df-044d2d231754"
    ## 
    ## $bootstrap.servers
    ## [1] "localhost:9092"
    ## 
    ## $auto.offset.reset
    ## [1] "earliest"
    ## 
    ## $client.id
    ## [1] "kafkaesque_consumer"

## Topics and Subscriptions

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

## Retrieving a Message

``` r
# retrieve next message
consumer$consume_next()
```

    ##         topic partition offset    timestamp timestampType serializedKeySize serializedValueSize value
    ## 1: test500000         0      0 1.601696e+12   CREATE_TIME                -1                   2   1\r
    ##    leaderEpoch
    ## 1:           0

## Looping over Messages and Executing Code

``` r
# loop over messages and execute code
res <- 
  consumer$consume_loop(
    expr  = expression(print(msgs)),
    check = expression(counter < 4)
  )
```

    ##         topic partition offset    timestamp timestampType serializedKeySize serializedValueSize value
    ## 1: test500000         0      1 1.601696e+12   CREATE_TIME                -1                   2   2\r
    ##    leaderEpoch
    ## 1:           0
    ##         topic partition offset    timestamp timestampType serializedKeySize serializedValueSize value
    ## 1: test500000         0      2 1.601696e+12   CREATE_TIME                -1                   2   3\r
    ##    leaderEpoch
    ## 1:           0
    ##         topic partition offset    timestamp timestampType serializedKeySize serializedValueSize value
    ## 1: test500000         0      3 1.601696e+12   CREATE_TIME                -1                   2   4\r
    ##    leaderEpoch
    ## 1:           0
    ##         topic partition offset    timestamp timestampType serializedKeySize serializedValueSize value
    ## 1: test500000         0      4 1.601696e+12   CREATE_TIME                -1                   2   5\r
    ##    leaderEpoch
    ## 1:           0

``` r
# having a look at the statistics
res
```

    ## $start_time
    ## [1] "2020-10-03 05:51:06 CEST"
    ## 
    ## $end_time
    ## [1] "2020-10-03 05:51:07 CEST"
    ## 
    ## $n
    ## [1] 4

## Looping over Batches of Messages and Executing Code

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

    ##           topic partition offset    timestamp timestampType serializedKeySize serializedValueSize value
    ##   1: test500000         0      5 1.601696e+12   CREATE_TIME                -1                   2   6\r
    ##   2: test500000         0      6 1.601696e+12   CREATE_TIME                -1                   2   7\r
    ##   3: test500000         0      7 1.601696e+12   CREATE_TIME                -1                   2   8\r
    ##   4: test500000         0      8 1.601696e+12   CREATE_TIME                -1                   2   9\r
    ##   5: test500000         0      9 1.601696e+12   CREATE_TIME                -1                   3  10\r
    ##  ---                                                                                                   
    ## 491: test500000         0    495 1.601696e+12   CREATE_TIME                -1                   4 496\r
    ## 492: test500000         0    496 1.601696e+12   CREATE_TIME                -1                   4 497\r
    ## 493: test500000         0    497 1.601696e+12   CREATE_TIME                -1                   4 498\r
    ## 494: test500000         0    498 1.601696e+12   CREATE_TIME                -1                   4 499\r
    ## 495: test500000         0    499 1.601696e+12   CREATE_TIME                -1                   4 500\r
    ##      leaderEpoch
    ##   1:           0
    ##   2:           0
    ##   3:           0
    ##   4:           0
    ##   5:           0
    ##  ---            
    ## 491:           0
    ## 492:           0
    ## 493:           0
    ## 494:           0
    ## 495:           0
    ## 
    ##           topic partition offset    timestamp timestampType serializedKeySize serializedValueSize  value
    ##   1: test500000         0    500 1.601696e+12   CREATE_TIME                -1                   4  501\r
    ##   2: test500000         0    501 1.601696e+12   CREATE_TIME                -1                   4  502\r
    ##   3: test500000         0    502 1.601696e+12   CREATE_TIME                -1                   4  503\r
    ##   4: test500000         0    503 1.601696e+12   CREATE_TIME                -1                   4  504\r
    ##   5: test500000         0    504 1.601696e+12   CREATE_TIME                -1                   4  505\r
    ##  ---                                                                                                    
    ## 496: test500000         0    995 1.601696e+12   CREATE_TIME                -1                   4  996\r
    ## 497: test500000         0    996 1.601696e+12   CREATE_TIME                -1                   4  997\r
    ## 498: test500000         0    997 1.601696e+12   CREATE_TIME                -1                   4  998\r
    ## 499: test500000         0    998 1.601696e+12   CREATE_TIME                -1                   4  999\r
    ## 500: test500000         0    999 1.601696e+12   CREATE_TIME                -1                   5 1000\r
    ##      leaderEpoch
    ##   1:           0
    ##   2:           0
    ##   3:           0
    ##   4:           0
    ##   5:           0
    ##  ---            
    ## 496:           0
    ## 497:           0
    ## 498:           0
    ## 499:           0
    ## 500:           0
    ## 
    ##           topic partition offset    timestamp timestampType serializedKeySize serializedValueSize  value
    ##   1: test500000         0   1000 1.601696e+12   CREATE_TIME                -1                   5 1001\r
    ##   2: test500000         0   1001 1.601696e+12   CREATE_TIME                -1                   5 1002\r
    ##   3: test500000         0   1002 1.601696e+12   CREATE_TIME                -1                   5 1003\r
    ##   4: test500000         0   1003 1.601696e+12   CREATE_TIME                -1                   5 1004\r
    ##   5: test500000         0   1004 1.601696e+12   CREATE_TIME                -1                   5 1005\r
    ##  ---                                                                                                    
    ## 496: test500000         0   1495 1.601696e+12   CREATE_TIME                -1                   5 1496\r
    ## 497: test500000         0   1496 1.601696e+12   CREATE_TIME                -1                   5 1497\r
    ## 498: test500000         0   1497 1.601696e+12   CREATE_TIME                -1                   5 1498\r
    ## 499: test500000         0   1498 1.601696e+12   CREATE_TIME                -1                   5 1499\r
    ## 500: test500000         0   1499 1.601696e+12   CREATE_TIME                -1                   5 1500\r
    ##      leaderEpoch
    ##   1:           0
    ##   2:           0
    ##   3:           0
    ##   4:           0
    ##   5:           0
    ##  ---            
    ## 496:           0
    ## 497:           0
    ## 498:           0
    ## 499:           0
    ## 500:           0

``` r
res
```

    ## $start_time
    ## [1] "2020-10-03 05:51:07 CEST"
    ## 
    ## $end_time
    ## [1] "2020-10-03 05:51:07 CEST"
    ## 
    ## $n
    ## [1] 1495

# Developement Notes

Java sources are in `./java/kafkaesque/` folder. Building Java sources
can be done via Maven: `mvn install` will compile everything and copy
the `kafkaesque.jar` into the package’s `./inst/java/` folder while all
dependencies are copied into the `./inst/java/` folder of the
{kafkaesquejars} package. Both packages should be placed within the same
folder to make this work properly.

After Java compilation, both R packages have to be build and installed -
first {kafkaesquejars} than {kafkaesque}.

If developing Java in VScode - as I did here - pressing Ctrl-Shift-B
should allow to select the two most important tasks: resolving
dependencies (these go into {kafkaesqujars}) and compiling the Java code
and distributing it to the right places as described above.
