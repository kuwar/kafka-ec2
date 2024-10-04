#!/bin/bash

exec > >(tee /var/log/prometheus_grafana_server_up.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

PROMETHEUS_HOME="/etc/prometheus"

# move prometheus.yml
sudo mv /home/ec2-user/prometheus.yml $PROMETHEUS_HOME/prometheus.yml || { echo "prometheus.yml move failed"; exit 1; }
# Create Prometheus service
sudo mv /home/ec2-user/prometheus.service /etc/systemd/system/prometheus.service || { echo "prometheus.service move failed"; exit 1; }

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
