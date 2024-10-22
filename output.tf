output "eip_public_ip" {
  value = aws_eip.kafka_cluster_eip[*].public_ip
}
output "ec2_instance_private_ip" {
  value = aws_instance.kafka_cluster_instances[*].private_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.kafka_cluster_instances[*].public_dns
}

output "kafka_cluster_brokers" {
  value = join(",", [for idx in range(length(aws_eip.kafka_cluster_eip)) : "${aws_eip.kafka_cluster_eip[idx].public_ip}:9092"])
}

output "prometheus_grafana_instance_public_ip" {
  value = aws_instance.prometheus_grafana_instance.public_ip
}

output "prometheus_url" {
  value = "${aws_instance.prometheus_grafana_instance.public_ip}:9090"
}

output "grafana_url" {
  value = "${aws_instance.prometheus_grafana_instance.public_ip}:3000"
}

output "confluent_schema_registry_url" {
  value = "${aws_instance.confluent_schema_registry_instance.public_ip}:${var.confluent_schema_registry_port}"
}