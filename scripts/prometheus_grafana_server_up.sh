#!/bin/bash

PROMETHEUS_HOME="/etc/prometheus"

# move prometheus.yml
sudo mv /home/ec2-user/prometheus.yml $PROMETHEUS_HOME/prometheus.yml
# Create Prometheus service
sudo mv /home/ec2-user/prometheus.service /etc/systemd/system/prometheus.service

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus