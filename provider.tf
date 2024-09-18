terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allows updates for any 4.x.x version
    }

    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }

  required_version = ">= 1.0.0" # Ensures you are using a modern Terraform version
}

provider "aws" {
  region = var.region
}

provider "local" {
  # Configuration options
}

provider "tls" {
  # Configuration options
}
