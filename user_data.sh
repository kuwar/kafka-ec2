#!/bin/bash

exec > >(tee /var/log/kafka-cluster-user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

KAFKA_INSTALL_DIR="/usr/local/kafka"

# Create the kafka user
sudo useradd kafka

# Allow kafka user to run commands without password
echo "kafka ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kafka

sudo yum update
sudo yum install java-21-amazon-corretto-devel -y
java -version

# Download and install Kafka
wget https://downloads.apache.org/kafka/3.6.2/kafka_2.13-3.6.2.tgz || { echo "kafka download failed"; exit 1; }
tar -xzf kafka_2.13-3.6.2.tgz

# if folder exist delete it
sudo rm -rf $KAFKA_INSTALL_DIR
sudo mv kafka_2.13-3.6.2 $KAFKA_INSTALL_DIR || { echo "kafka move failed"; exit 1; }
sudo rm -rf kafka_2.13-3.6.2.tgz

# make data directory for kafka
sudo mkdir -p $KAFKA_INSTALL_DIR/data
sudo mkdir $KAFKA_INSTALL_DIR/data/broker
sudo mkdir $KAFKA_INSTALL_DIR/data/broker/logs

sudo rm -rf $KAFKA_INSTALL_DIR/data/broker/logs/*

# moving kraft's server.properties file in the respective directory
sudo mv /home/ec2-user/server.properties $KAFKA_INSTALL_DIR/config/kraft/server.properties || { echo "server.propertiesls move failed"; exit 1; }
# setting up kafka and kraft autostart services
sudo mv /home/ec2-user/kafka.service /etc/systemd/system/kafka.service || { echo "kafka service move failed"; exit 1; }

# Setting up JMX Exporter
JMX_JAR_FOLDER = "/usr/local/kafka/prometheus"
JMX_DOWNLOAD_URL = "https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar"
sudo mkdir $JMX_JAR_FOLDER
sudo mv /home/ec2-user/kafka_jmx_config.yml $JMX_JAR_FOLDER || { echo "Kafka JMX config move failed"; exit 1; }
wget $JMX_DOWNLOAD_URL
sudo mv jmx_prometheus_javaagent-1.0.1.jar $JMX_JAR_FOLDER

# making the kafka dir read, write and executable for all the users
# sudo chmod -R 777 $KAFKA_INSTALL_DIR
sudo chown -R kafka:kafka $KAFKA_INSTALL_DIR

# making kafka daemon
sudo systemctl daemon-reload

sudo systemctl enable kafka
sudo systemctl start kafka
