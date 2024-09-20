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

variable "ec2_instance_ip" {
  type = list(string)
}
variable "kraft_config_files" {
  type = list(string)
}