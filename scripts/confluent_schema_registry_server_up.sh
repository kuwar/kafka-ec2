#!/bin/bash

# exec > >(tee /var/log/confluent_schema_registry_server_up.log|logger -t user-data -s 2>/dev/console) 2>&1
# echo "Hello from $(hostname -f)!"

CONFLUENT_INSTALL_DIR="/usr/local/confluent"

# moving confluent schema-registry.properties file in the respective directory
sudo mv /home/ec2-user/schema-registry.properties $CONFLUENT_INSTALL_DIR/etc/schema-registry/schema-registry.properties || { echo "schema-registry.properties move failed"; exit 1; }
# setting up confluent schema-registry autostart services
sudo mv /home/ec2-user/schema-registry.service /etc/systemd/system/schema-registry.service || { echo "confluent schema-registry.service move failed"; exit 1; }


# making the confluent dir read, write and executable for all the users
# sudo chmod -R 777 $CONFLUENT_INSTALL_DIR
sudo chown -R confluent:confluent $CONFLUENT_INSTALL_DIR

# making confluent schema-registry daemon
sudo systemctl daemon-reload
sudo systemctl start schema-registry
sudo systemctl enable schema-registry