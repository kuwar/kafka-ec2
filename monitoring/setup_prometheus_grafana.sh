#!/bin/bash

exec > >(tee /var/log/prometheus-grafana-user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

# Update and install necessary packages
sudo yum update -y
sudo yum upgrade -y
sudo yum install wget -y

sudo useradd prometheus

PROMETHEUS_VERSION = "2.54.1"
PROMETHEUS_DOWNLOAD_LINK = "https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz"
PROMETHEUS_HOME = "/etc/prometheus"

# Install Prometheus
cd /tmp
wget $PROMETHEUS_DOWNLOAD_LINK
tar -xvf prometheus-2.54.1.linux-amd64.tar.gz
sudo mv prometheus-2.54.1.linux-amd64 $PROMETHEUS_HOME
sudo ln -s $PROMETHEUS_HOME/prometheus /usr/local/bin/prometheus
sudo ln -s $PROMETHEUS_HOME/promtool /usr/local/bin/promtool

# move prometheus.yml
sudo mv /home/ec2-user/prometheus.yml $PROMETHEUS_HOME/prometheus.yml
# Create Prometheus service
sudo mv /home/ec2-user/prometheus.service /etc/systemd/system/prometheus.service

sudo chown -R prometheus:prometheus $PROMETHEUS_HOME

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Install Grafana
wget https://dl.grafana.com/oss/release/grafana_11.2.2_amd64.deb
sudo dpkg -i grafana_11.2.2_amd64.deb

# Start and enable Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
