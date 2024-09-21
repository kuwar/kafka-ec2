#!/bin/bash

exec > >(tee /var/log/kafka-cluster-user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

sudo yum update
sudo yum install java-21-amazon-corretto-devel -y
java -version

# Download and install Kafka
wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz || { echo "kafka download failed"; exit 1; }
tar -xzf kafka_2.13-3.8.0.tgz
sudo mv kafka_2.13-3.8.0.tgz /usr/local/kafka || { echo "kafka move failed"; exit 1; }
sudo rm -rf kafka_2.13-3.8.0.tgz

# make data directory for kafka
sudo mkdir -p /usr/local/kafka/data
sudo mkdir /usr/local/kafka/data/broker
sudo mkdir /usr/local/kafka/data/broker/logs

sudo rm -rf /usr/local/kafka/data/broker/logs/*

# Replacing the kraft server.properties
sudo mv /home/ec2-user/server.properties /usr/local/kafka/config/kraft/server.properties

# setting up kafka and kraft autostart services
sudo mv /home/ec2-user/kafka.service /etc/systemd/system/kafka.service || { echo "kafka service move failed"; exit 1; }

KAFKA_CLUSTER_ID="WbwIBObxTu6uaOlkwPwZeg0"
/usr/local/kafka/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /usr/local/kafka/config/kraft/server.properties

# making kafka daemon
sudo systemctl daemon-reload

sudo systemctl enable kafka
sudo systemctl start kafka