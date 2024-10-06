# Create a security group for SSH access
locals {
  allowed_ports = [22, 80, 8080, 443, 7071, 7072, 9092, 9093]
}

resource "aws_security_group" "kafka_cluster_sg" {
  vpc_id = aws_vpc.kafka_cluster_vpc.id

  name        = "kafka-cluster-sg"
  description = "Allow inbound/outbound traffic for Kafka"

  dynamic "ingress" {
    for_each = local.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Egress Rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Kafka-cluster-SG"
  }
}