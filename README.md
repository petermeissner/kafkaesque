
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- -->

<!-- FILL OUT OPTIONS !!! -->

<!-- -->

<!-- -->

<!-- -->

# Java Jars for the Package ‘kafkaesque’

**Status**

<a href="https://travis-ci.org/petermeissner/kafkaesquejars"><img src="https://api.travis-ci.org/petermeissner/kafkaesquejars.svg?branch=master"><a/>
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/petermeissner/kafkaesquejars?branch=master&svg=true)](https://ci.appveyor.com/project/petermeissner/kafkaesquejars)
<a href="https://codecov.io/gh/petermeissner/kafkaesquejars"><img src="https://codecov.io/gh/petermeissner/kafkaesquejars/branch/master/graph/badge.svg" alt="Codecov" /></a>
<a href="https://cran.r-project.org/package=kafkaesquejars">
<img src="http://www.r-pkg.org/badges/version/kafkaesquejars"> </a>
<img src="http://cranlogs.r-pkg.org/badges/grand-total/kafkaesquejars">
<img src="http://cranlogs.r-pkg.org/badges/kafkaesquejars">

*lines of R code:* 16, *lines of test code:* 5

**Version**

2.3.1 ( 2020-02-29 12:09:48 )

**Description**

Contents of ‘Kafka-clients’ & supporting Java archives
(<https://github.com/apache/kafka>). Version number reflects the version
number of the included ‘JAR’ file.

**License**

Apache License (\>= 2.0) | file LICENSE <br>Peter Meissner \[aut, cre\],
Marius Pirv \[aut\], virtual7 \[cph\], Apache Software Foundation
\[cph\] (Kafka), Facebook \[cph\] (For Zstandard software, BSD License),
Luben Karavelov \[cph\] (Zstd-jni: JNI bindings to Zstd Library, BSD
2-Clause License)

**Citation**

``` r
citation("kafkaesquejars")
```

``` r
Meissner P, Pirv M (2020). kafkaesquejars: Java Jars for the Package 'kafkaesque'. R package version 2.3.1.
```

**BibTex for citing**

``` r
toBibtex(citation("kafkaesquejars"))
```

    @Manual{,
      title = {kafkaesquejars: Java Jars for the Package 'kafkaesque'},
      author = {Peter Meissner and Marius Pirv},
      year = {2020},
      note = {R package version 2.3.1},
    }

**Installation**

Stable version from CRAN:

``` r
install.packages("kafkaesquejars")
```

Latest development version from Github:

``` r
devtools::install_github("petermeissner/kafkaesquejars")
```

# Content

## Not much to see

``` r
library(kafkaesquejars)
```

    ## Loading required package: rJava

``` r
ls("package:kafkaesquejars")
```

    ## [1] "%>%"              "test_method_call"

## Its all about the Java

### Kafka properties objects

``` r
props <- rJava::.jnew("kafkaesquejars.Kafka_props")

props$set_prop("my_key", "my_value")
props$set_prop("my_keynote", "my_valuables")

props$to_json() %>% 
  cat()
```

    ## {"my_keynote":"my_valuables","my_key":"my_value"}

``` r
props$from_json("{'a':'b', 'c':'d'}")

props$to_json() %>% 
  cat()
```

    ## {"my_keynote":"my_valuables","a":"b","c":"d","my_key":"my_value"}

``` r
props$to_json_pretty() %>% 
  cat()
```

    ## {
    ##   "my_keynote": "my_valuables",
    ##   "a": "b",
    ##   "c": "d",
    ##   "my_key": "my_value"
    ## }

### Kafka properties objects specific to producers

``` r
prod_props <- rJava::.jnew("kafkaesquejars.Kafka_producer_props")

prod_props$to_json_pretty() %>% 
  cat()
```

    ## {
    ##   "value.serializer": "org.apache.kafka.common.serialization.StringSerializer",
    ##   "bootstrap.servers": "localhost:9092",
    ##   "key.serializer": "org.apache.kafka.common.serialization.StringSerializer"
    ## }

### Kafka producer object

``` r
prod <- rJava::.jnew("kafkaesquejars.Kafka_producer")
cat(names(prod), sep="\n")
```

    ## props
    ## prod
    ## main(
    ## send_message(
    ## producer_close()
    ## producer_start()
    ## wait(
    ## wait(
    ## wait()
    ## equals(
    ## toString()
    ## hashCode()
    ## getClass()
    ## notify()
    ## notifyAll()
