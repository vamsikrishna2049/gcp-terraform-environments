#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: validate-vm-inputs.sh <terraform.tfvars>"
  exit 1
fi

terraform init -backend=false
terraform validate

if ! grep -q "web_vm_count" "$1"; then
  echo "web_vm_count is required in $1"
  exit 1
fi

echo "VM input validation complete"
