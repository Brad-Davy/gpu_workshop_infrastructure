#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <aws-region>"
  echo "Example: $0 us-east-1"
  exit 1
fi

REGION="$1"
PARAM_PATH="/aws/service/deeplearning/ami/x86_64/base-oss-nvidia-driver-gpu-ubuntu-22.04/latest/ami-id"

echo "Fetching latest GPU AMI for region: $REGION"
echo "SSM Parameter: $PARAM_PATH"
echo

AMI_ID=$(aws ssm get-parameter \
  --name "$PARAM_PATH" \
  --region "$REGION" \
  --query "Parameter.Value" \
  --output text || echo "")

if [[ "$AMI_ID" == "" || "$AMI_ID" == "None" ]]; then
  echo "❌ Error: Could not retrieve AMI ID. Check region or permissions."
  exit 1
fi

echo "Success! Latest GPU-ready Ubuntu AMI:"
echo "$AMI_ID"
echo
echo "You can now use this AMI ID in Terraform:"
echo "ami = \"$AMI_ID\""

