locals {
  confluent_schema_registry_allowed_ports = [22, var.confluent_schema_registry_port]
}
resource "aws_security_group" "confluent_schema_registry_sg" {
  vpc_id      = aws_vpc.kafka_cluster_vpc.id
  name        = "confluent-schema-registry-sg"
  description = "Allow SSH"

  dynamic "ingress" {
    for_each = local.confluent_schema_registry_allowed_ports
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
    Name    = "confluent-schema-registry-sg"
    Purpose = "Schema registry for kafka cluster"
  }
}

resource "aws_instance" "confluent_schema_registry_instance" {
  ami           = lookup(var.ec2_ami, var.region, "ami-0cdfcb9783eb43c45")
  instance_type = var.instance_type
  key_name      = aws_key_pair.kafka_cluster_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.confluent_schema_registry_sg.id]
  subnet_id              = aws_subnet.kafka_cluster_public_subnet[0].id

  associate_public_ip_address = true

  # User data script to install confluent schema registry
  user_data = file("scripts/confluent_schema_registry_user_data.sh")

  tags = {
    Name    = "confluent-schema-registry-EC2"
    Purpose = "Schema registry for kafka cluster"
  }
}

data "template_file" "confluent_schema_registry_properties" {
  template = file("${path.module}/confluent-config/schema-registry.properties.tpl")

  vars = {
    schema_registry_ip       = aws_instance.confluent_schema_registry_instance.public_ip
    schema_registry_port     = var.confluent_schema_registry_port
    schema_registry_listener = "http://${aws_instance.confluent_schema_registry_instance.public_ip}:${var.confluent_schema_registry_port}"
    brokers_list             = join(",", [for idx in range(length(aws_eip.kafka_cluster_eip)) : "${aws_eip.kafka_cluster_eip[idx].public_ip}:9092"])
  }
}

resource "null_resource" "confluent_schema_registry_server_properties_set" {
  depends_on = [aws_instance.confluent_schema_registry_instance]

  connection {
    type        = "ssh"
    user        = "ec2-user"                                                # Amazon Linux 2 uses 'ec2-user'
    private_key = tls_private_key.kafka_cluster_private_key.private_key_pem # Path to your private key
    host        = aws_instance.confluent_schema_registry_instance.public_ip # EC2 instance's public IP
  }

  provisioner "file" {
    content     = data.template_file.confluent_schema_registry_properties.rendered
    destination = "/home/ec2-user/schema-registry.properties"
  }

  provisioner "file" {
    source      = "confluent-config/schema-registry.service"
    destination = "/home/ec2-user/schema-registry.service"
  }

  provisioner "file" {
    source      = "scripts/confluent_schema_registry_server_up.sh"
    destination = "/home/ec2-user/confluent_schema_registry_server_up.sh"
  }
}

resource "null_resource" "confluent_schema_registry_server_daemon_run" {
  depends_on = [aws_instance.confluent_schema_registry_instance, null_resource.confluent_schema_registry_server_properties_set]

  connection {
    type        = "ssh"
    user        = "ec2-user"                                                # Amazon Linux 2 uses 'ec2-user'
    private_key = tls_private_key.kafka_cluster_private_key.private_key_pem # Path to your private key
    host        = aws_instance.confluent_schema_registry_instance.public_ip # EC2 instance's public IP
  }

  # Adding delay of 30 seconds
  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/confluent_schema_registry_server_up.sh",
      "sudo /home/ec2-user/confluent_schema_registry_server_up.sh > /home/ec2-user/confluent_schema_registry_server_up.log 2>&1"
    ]
  }
}



