resource "aws_cloudwatch_log_group" "kafka_cluster_log_group" {
  name = "kafka-cluster-logs"
}

resource "aws_instance" "kafka_cluster_instances" {
  # Creates 3 identical aws ec2 instances
  count = var.total_node

  associate_public_ip_address = true

  key_name               = aws_key_pair.kafka_cluster_key_pair.key_name           # Attach the existing key pair
  subnet_id              = aws_subnet.kafka_cluster_public_subnet[count.index].id # Assign different subnet based on count index
  vpc_security_group_ids = [aws_security_group.kafka_cluster_sg.id]               # Attach the security group

  # All 3 instances will have the same ami and instance_type
  ami           = lookup(var.ec2_ami, var.region, "ami-0cdfcb9783eb43c45")
  instance_type = var.instance_type # 
  tags = {
    # The count.index allows you to launch a resource 
    # starting with the distinct index number 0 and corresponding to this instance.
    Name      = "kafka-cluster-${count.index + 1}"
    Stack     = "Datascience"
    Developer = "Shaurave"
    Purpose   = "Testing kafka cluster in AWS EC2"
  }

  # User data (optional) for EC2 instance initialization
  # install additional software and packages
  user_data = file("${path.module}/scripts/kafka_user_data.sh")

}

resource "aws_eip_association" "kafka_cluster_eip_assoc" {
  count         = length(aws_instance.kafka_cluster_instances)
  instance_id   = aws_instance.kafka_cluster_instances[count.index].id
  allocation_id = aws_eip.kafka_cluster_eip[count.index].id
}


data "template_file" "kafka_cluster_server_properties_config" {
  count    = length(aws_instance.kafka_cluster_instances)
  template = file("${path.module}/kafka-config/kraft/server.properties.tpl")

  vars = {
    node_id                                  = count.index + 1
    controller_quorum_voters                 = join(",", [for idx in range(length(aws_instance.kafka_cluster_instances)) : "${idx + 1}@${aws_instance.kafka_cluster_instances[idx].private_ip}:9093"])
    instance_private_ip                      = aws_instance.kafka_cluster_instances[count.index].private_ip
    instance_public_ip                       = aws_eip.kafka_cluster_eip[count.index].public_ip
    instance_public_dns                      = aws_instance.kafka_cluster_instances[count.index].public_dns
    log_dirs                                 = var.kafka_log_path
    num_partitions                           = length(aws_instance.kafka_cluster_instances) * 2
    offsets_topic_replication_factor         = var.offsets_topic_replication_factor
    transaction_state_log_replication_factor = var.transaction_state_log_replication_factor
  }
}

resource "null_resource" "kafka_cluster_server_properties_set" {
  depends_on = [aws_instance.kafka_cluster_instances]
  count      = length(aws_instance.kafka_cluster_instances)
  connection {
    type        = "ssh"
    user        = "ec2-user"                                                # Amazon Linux 2 uses 'ec2-user'
    private_key = tls_private_key.kafka_cluster_private_key.private_key_pem # Path to your private key
    host        = aws_eip.kafka_cluster_eip[count.index].public_ip          # EC2 instance's public IP
  }

  provisioner "file" {
    content     = data.template_file.kafka_cluster_server_properties_config[count.index].rendered
    destination = "/home/ec2-user/server.properties"
  }

  provisioner "file" {
    source      = "kafka-config/kafka.service"
    destination = "/home/ec2-user/kafka.service"
  }

  provisioner "file" {
    source      = "kafka-config/kafka_jmx_config.yml"
    destination = "/home/ec2-user/kafka_jmx_config.yml"
  }

  provisioner "file" {
    source      = "scripts/kafka_server_up.sh"
    destination = "/home/ec2-user/kafka_server_up.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/kafka_server_up.sh",
      "sudo /home/ec2-user/kafka_server_up.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"                                                # Amazon Linux 2 uses 'ec2-user'
      private_key = tls_private_key.kafka_cluster_private_key.private_key_pem # Path to your private key
      host        = aws_eip.kafka_cluster_eip[count.index].public_ip          # EC2 instance's public IP
    }
  }
}