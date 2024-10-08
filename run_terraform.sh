#!/bin/bash

terraform init 
terraform plan 
terraform fmt 
terraform validate 
tflint 
terraform apply -auto-approve