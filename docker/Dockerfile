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


# switch user and directory
USER docker
WORKDIR /home/docker


# Kafka
RUN wget https://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/kafka/2.6.0/kafka_2.13-2.6.0.tgz
RUN mkdir kafka
RUN tar -xzf kafka*.tgz --directory ./kafka --strip-components=1
RUN tar -xzf kafka*.tgz
RUN rm kafka*.tgz


# Kafka config
ADD ./docker/server.properties ./kafka/config/server.properties

# Tools 
ADD ./docker/.bashrc ./.bashrc
ADD ./docker/kafka_messages.txt ./
ADD ./docker/test_500_000.txt ./

# startup script
ADD ./docker/start.sh ./

# starting up services
EXPOSE 9092 2181
ENTRYPOINT [ "./start.sh && bash" ] 
