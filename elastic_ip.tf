resource "aws_eip" "kafka_cluster_eip" {
  count = var.apply_eip_resource ? 3 : 0

  tags = {
    Name = "kafka-cluster-eip-${count.index + 1}"
  }
}

