#!/bin/bash

exec > >(tee /var/log/kafka-cluster-user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

KAFKA_INSTALL_DIR="/usr/local/kafka"

sudo yum update
sudo yum install java-21-amazon-corretto-devel -y
java -version

# Download and install Kafka
wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz || { echo "kafka download failed"; exit 1; }
tar -xzf kafka_2.13-3.8.0.tgz

# if folder exist delete it
sudo rm -rf $KAFKA_INSTALL_DIR
sudo mv kafka_2.13-3.8.0 $KAFKA_INSTALL_DIR || { echo "kafka move failed"; exit 1; }
sudo rm -rf kafka_2.13-3.8.0.tgz

# making the kafka dir read, write and executable for all the users
sudo chmod -R 777 $KAFKA_INSTALL_DIR

# make data directory for kafka
sudo mkdir -p $KAFKA_INSTALL_DIR/data
sudo mkdir $KAFKA_INSTALL_DIR/data/broker
sudo mkdir $KAFKA_INSTALL_DIR/data/broker/logs

sudo rm -rf $KAFKA_INSTALL_DIR/data/broker/logs/*

# Replacing the kraft server.properties
sudo mv /home/ec2-user/server.properties $KAFKA_INSTALL_DIR/config/kraft/server.properties || { echo "server.properties move failed"; exit 1; }

# setting up kafka and kraft autostart services
sudo mv /home/ec2-user/kafka.service /etc/systemd/system/kafka.service || { echo "kafka service move failed"; exit 1; }

# making kafka daemon
# sudo systemctl daemon-reload

# sudo systemctl enable kafka
# sudo systemctl start kafka