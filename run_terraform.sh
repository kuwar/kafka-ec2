#!/bin/bash

terraform init && terraform apply && terraform fmt && terraform validate && tflint && terraform appl