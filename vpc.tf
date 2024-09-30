# Create a VPC in eu-west-3 region

resource "aws_vpc" "kafka_cluster_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "kafka-cluster-vpc"
  }
}

# Subnets for each AZ
resource "aws_subnet" "kafka_cluster_subnet" {
  count             = 3
  vpc_id            = aws_vpc.kafka_cluster_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.kafka_cluster_vpc.cidr_block, 8, count.index)
  availability_zone = element(["eu-west-3a", "eu-west-3b", "eu-west-3c"], count.index)
  tags = {
    Name = "kafka-cluster-subnet-${count.index + 1}"
  }
}

# Create an Internet Gateway to allow instances in the VPC to access the Internet
resource "aws_internet_gateway" "kafka_cluster_igw" {
  vpc_id = aws_vpc.kafka_cluster_vpc.id

  tags = {
    Name = "kafka-cluster-igw"
  }
}

# Create a route table for the public subnets to route traffic through the Internet Gateway
resource "aws_route_table" "kafka_cluster_public_rt" {
  vpc_id = aws_vpc.kafka_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafka_cluster_igw.id
  }

  tags = {
    Name = "kafka-cluster-public-route-table"
  }
}

# Associate subnets with the route table
resource "aws_route_table_association" "kafka_cluster_route_table_assoc" {
  count          = 3
  subnet_id      = aws_subnet.kafka_cluster_subnet[count.index].id
  route_table_id = aws_route_table.kafka_cluster_public_rt.id
}
