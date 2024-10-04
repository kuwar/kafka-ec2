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