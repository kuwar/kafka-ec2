#!/bin/bash

exec > >(tee /var/log/kafka-cluster-user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

sudo yum update
sudo yum install java-21-amazon-corretto-devel -y
java -version

# Download and install Kafka
wget https://downloads.apache.org/kafka/3.7.1/kafka_2.13-3.7.1.tgz || { echo "kafka download failed"; exit 1; }
tar -xzf kafka_2.13-3.7.1.tgz
sudo mv kafka_2.13-3.7.1 /usr/local/kafka || { echo "kafka move failed"; exit 1; }
sudo rm -rf kafka_2.13-3.7.1.tgz

# setting up kafka and zookeeper autostart services
sudo mv /home/ec2-user/zookeeper.service /etc/systemd/system/zookeeper.service || { echo "zookeeper service move failed"; exit 1; }
sudo mv /home/ec2-user/kafka.service /etc/systemd/system/kafka.service || { echo "kafka service move failed"; exit 1; }

# making kafka and zookeeper daemon
sudo systemctl daemon-reload

sudo systemctl enable zookeeper
sudo systemctl start zookeeper

sudo systemctl enable kafka
sudo systemctl start kafka