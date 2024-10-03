#!/bin/bash

# Update and install necessary packages
sudo yum update -y
sudo yum upgrade -y
sudo yum install wget -y

PROMETHEUS_VERSION = "2.54.1"
PROMETHEUS_DOWNLOAD_LINK = "https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz"
PROMETHEUS_HOME = "/etc/prometheus"

# Install Prometheus
cd /tmp
wget $PROMETHEUS_DOWNLOAD_LINK
tar -xvf prometheus-2.54.1.linux-amd64.tar.gz
sudo mv prometheus-2.54.1.linux-amd64.tar $PROMETHEUS_HOME
sudo ln -s /etc/prometheus/prometheus /usr/local/bin/prometheus
sudo ln -s /etc/prometheus/promtool /usr/local/bin/promtool

# Create Prometheus service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Install Grafana
wget https://dl.grafana.com/oss/release/grafana_11.2.2_amd64.deb
sudo dpkg -i grafana_11.2.2_amd64.deb

# Start and enable Grafana
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
