locals {
  publicIPs  = [aws_instance.kafka_cluster_instances[0].public_ip, aws_instance.kafka_cluster_instances[1].public_ip, aws_instance.kafka_cluster_instances[2].public_ip]
  privateIPs = [aws_instance.kafka_cluster_instances[0].private_ip, aws_instance.kafka_cluster_instances[1].private_ip, aws_instance.kafka_cluster_instances[2].private_ip]
}

output "ec2_instance_public_ip" {
  value = local.publicIPs
}
output "ec2_instance_private_ip" {
  value = local.privateIPs
}