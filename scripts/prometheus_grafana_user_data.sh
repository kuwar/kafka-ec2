#!/bin/bash

exec > >(tee /var/log/prometheus-grafana-user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Hello from $(hostname -f)!"

# Update and install necessary packages
sudo yum update -y
sudo yum upgrade -y
sudo yum install wget -y

sudo useradd prometheus
# Allow prometheus user to run commands without password
echo "prometheus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/prometheus

PROMETHEUS_VERSION="2.54.1"
PROMETHEUS_DOWNLOAD_LINK="https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz"
PROMETHEUS_HOME="/etc/prometheus"

# Install Prometheus
cd /tmp
wget $PROMETHEUS_DOWNLOAD_LINK
tar -xvf prometheus-2.54.1.linux-amd64.tar.gz
sudo mv prometheus-2.54.1.linux-amd64 $PROMETHEUS_HOME

sudo chown -R prometheus:prometheus $PROMETHEUS_HOME

# prometheus data directory
sudo mkdir /var/lib/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Install Grafana
sudo tee /etc/yum.repos.d/grafana.repo<<EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

sudo yum install grafana -y
# Start and enable Grafana
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
