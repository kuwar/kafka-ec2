#!/bin/bash

exec > >(tee /var/log/confluent-schema-registry.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

CONFLUENT_INSTALL_DIR="/usr/local/confluent"

# Create the confluent user
sudo useradd confluent
# Allow confluent user to run commands without password
echo "confluent ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/confluent

sudo yum update
sudo yum install java-21-amazon-corretto-devel -y
java -version

# Download and install confluent
wget https://packages.confluent.io/archive/7.5/confluent-7.5.0.tar.gz || { echo "confluent download failed"; exit 1; }
tar -xzf confluent-7.5.0.tar.gz

# if folder exist delete it
sudo rm -rf $CONFLUENT_INSTALL_DIR
sudo mv confluent-7.5.0 $CONFLUENT_INSTALL_DIR || { echo "confluent move failed"; exit 1; }
sudo rm -rf confluent-7.5.0.tar.gz
