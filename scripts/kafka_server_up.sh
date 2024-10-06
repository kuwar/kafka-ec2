#!/bin/bash

# exec > >(tee /var/log/kafka_server_up.log|logger -t user-data -s 2>/dev/console) 2>&1
# echo "Hello from $(hostname -f)!"

KAFKA_INSTALL_DIR="/usr/local/kafka"
JMX_JAR_FOLDER="${KAFKA_INSTALL_DIR}/prometheus"

# moving kraft's server.properties file in the respective directory
sudo mv /home/ec2-user/server.properties $KAFKA_INSTALL_DIR/config/kraft/server.properties || { echo "server.propertiesls move failed"; exit 1; }
# setting up kafka and kraft autostart services
sudo mv /home/ec2-user/kafka.service /etc/systemd/system/kafka.service || { echo "kafka service move failed"; exit 1; }
# JMX Exporter configuration
sudo mv /home/ec2-user/kafka_jmx_config.yml $JMX_JAR_FOLDER || { echo "Kafka JMX config move failed"; exit 1; }

# JMX exporter setup
# export KAFKA_OPTS="-javaagent:${JMX_JAR_FOLDER}/jmx_prometheus_javaagent-1.0.1.jar=7071:${JMX_JAR_FOLDER}/kafka_jmx_config.yml"

# making the kafka dir read, write and executable for all the users
# sudo chmod -R 777 $KAFKA_INSTALL_DIR
sudo chown -R kafka:kafka $KAFKA_INSTALL_DIR

# making kafka daemon
sudo systemctl daemon-reload
sudo systemctl start kafka
sudo systemctl enable kafka