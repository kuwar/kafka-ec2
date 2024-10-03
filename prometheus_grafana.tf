locals {
  prometheus_grafana_allowed_ports = [22, 3000, 9090]
}
resource "aws_security_group" "prometheus_grafana_sg" {
  vpc_id      = aws_vpc.kafka_cluster_vpc.id
  name        = "prometheus-grafana-sg"
  description = "Allow Prometheus, Grafana, and SSH"

  dynamic "ingress" {
    for_each = local.prometheus_grafana_allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "prometheus-grafana-sg"
    Purpose = "Monitor the kafka cluster"
  }
}

resource "aws_instance" "prometheus_grafana_instance" {
  ami           = lookup(var.ec2_ami, var.region, "ami-0cdfcb9783eb43c45")
  instance_type = var.instance_type
  key_name      = aws_key_pair.kafka_cluster_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.kafka_cluster_sg.id]
  subnet_id              = aws_subnet.kafka_cluster_public_subnet[0].id

  associate_public_ip_address = true

  # User data script to install Prometheus and Grafana
  user_data = file("monitoring/setup_prometheus_grafana.sh")

  tags = {
    Name    = "Prometheus-Grafana-EC2"
    Purpose = "Monitor the kafka cluster"
  }
}

data "template_file" "prometheus_yml_config" {
  template = file("${path.module}/monitoring/prometheus.yml.tpl")

  vars = {
    brokers_list                 = [for idx in range(length(aws_eip.kafka_cluster_eip)) : "${aws_eip.kafka_cluster_eip[idx].public_ip}:7071"]
  }
}

resource "null_resource" "prometheus_yml_set" {
    triggers = {
    always_run = timestamp()
  }
  
  connection {
    type        = "ssh"
    user        = "ec2-user"                                                  # Amazon Linux 2 uses 'ec2-user'
    private_key = tls_private_key.kafka_cluster_private_key.private_key_pem   # Path to your private key
    host        = aws_instance.prometheus_grafana_instance.public_ip # EC2 instance's public IP
  }

  provisioner "file" {
    content     = data.template_file.prometheus_yml_config.rendered
    destination = "/home/ec2-user/prometheus.yml"
  }

  provisioner "file" {
    source      = "monitoring/prometheus.service"
    destination = "/home/ec2-user/prometheus.service"
  }
}

