# Creating a Variable for ami of type map
variable "ec2_ami" {
  type = map(any)

  default = {
    eu-west-3 = "ami-0cdfcb9783eb43c45"
  }
}

# Creating a Variable for region
variable "region" {
  type    = string
  default = "eu-west-3"
}


# Creating a Variable for instance_type
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "apply_eip_resource" {
  type    = bool
  default = false
}

variable "kafka_cluster_id" {
  type    = string
  default = ""
}

variable "total_node" {
  type    = number
  default = 3
}

variable "kafka_install_path" {
  type    = string
  default = "/usr/local/kafka"
}

variable "kafka_log_path" {
  type    = string
  default = "/usr/local/kafka/data/broker/logs"
}

variable "offsets_topic_replication_factor" {
  type    = number
  default = 2
}

variable "transaction_state_log_replication_factor" {
  type    = number
  default = 2
}