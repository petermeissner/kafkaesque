FROM ubuntu:20.04

# activate debian non interactiv mode
ARG DEBIAN_FRONTEND=noninteractive


# set locale info
ENV TZ=Europe/Berlin

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install locales -y


# Java
RUN apt-get install default-jre -y


# tools
RUN apt-get install wget -y


# diagnostic tools
RUN apt-get install telnet -y
RUN apt-get install kafkacat -y


# user / home and working directory
RUN chmod 1777 /tmp
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff


# switch directory
WORKDIR /home/docker
# switch user
USER docker


# Kafka
RUN wget --no-verbose https://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/kafka/2.6.1/kafka_2.13-2.6.1.tgz
RUN mkdir kafka
RUN tar -xzf kafka*.tgz --directory ./kafka --strip-components=1
RUN tar -xzf kafka*.tgz
RUN rm kafka*.tgz


# Kafka config
ADD ./server.properties ./kafka/config/server.properties


# Tools
ADD ./.bashrc ./.bashrc
ADD ./kafka_messages.txt ./
ADD ./test_500_000.txt ./


# startup script
USER root

ADD ./start.sh ./
RUN chown root:docker ./start.sh
RUN chmod 770 ./start.sh

USER docker
WORKDIR /home/docker


# starting up services
EXPOSE 9092 2181
CMD ./start.sh
