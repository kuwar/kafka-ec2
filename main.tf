# Create Private key
# Store it to local file in same module
# Create a key pair
resource "tls_private_key" "kafka_cluster_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "kafka_cluster_private_key_save" {
  filename = "${path.module}/kafka-cluster-key.pem"
  content  = tls_private_key.kafka_cluster_private_key.private_key_pem

  # Set file permissions
  file_permission = "0600"
}

resource "aws_key_pair" "kafka_cluster_key_pair" {
  key_name   = "kafka-cluster-key"
  public_key = tls_private_key.kafka_cluster_private_key.public_key_openssh
}

resource "aws_cloudwatch_log_group" "kafka_cluster_log_group" {
  name = "kafka-cluster-logs"
}

# Create a security group for SSH access
resource "aws_security_group" "kafka_cluster_sg" {
  name        = "kafka-cluster-sg"
  description = "Allow inbound/outbound traffic for Kafka"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open SSH from anywhere; restrict if necessary
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Kafka broker port (update with your IP)
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Zookeeper port (update with your IP)
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

resource "aws_instance" "kafka_cluster_instances" {
  # Creates 3 identical aws ec2 instances
  count = 3

  key_name        = aws_key_pair.kafka_cluster_key_pair.key_name # Attach the existing key pair
  security_groups = [aws_security_group.kafka_cluster_sg.name]   # Attach the security group

  # All 3 instances will have the same ami and instance_type
  ami           = lookup(var.ec2_ami, var.region, "ami-0cdfcb9783eb43c45")
  instance_type = var.instance_type # 
  tags = {
    # The count.index allows you to launch a resource 
    # starting with the distinct index number 0 and corresponding to this instance.
    Name      = "test-kafka-cluster-${count.index}"
    Stack     = "Datascience"
    Developer = "Shaurave"
    Purpose   = "Testing kafka cluster in AWS EC2"
  }

  provisioner "file" {
    source      = "zookeeper.txt"
    destination = "/home/ec2-user/zookeeper.txt"

    connection {
      type        = "ssh"
      user        = "ec2-user"  
      private_key = tls_private_key.kafka_cluster_private_key.private_key_pem   
      host        = self.public_ip   
    }
  }

  # User data (optional) for EC2 instance initialization
  # install additional software and packages
  user_data = file("${path.module}/user_data.sh")

}

