output "ec2_instance_public_ip" {
  value = aws_instance.kafka_cluster_instances[*].public_ip
}
output "ec2_instance_private_ip" {
  value = aws_instance.kafka_cluster_instances[*].private_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.kafka_cluster_instances[*].public_dns
}