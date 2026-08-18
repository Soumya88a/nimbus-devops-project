#!/usr/bin/env bash
set -euo pipefail

TAG="${1:?usage: ./scripts/deploy.sh <image-tag>}"
REGION="${AWS_REGION:?set AWS_REGION}"
INSTANCE_ID="${NIMBUS_INSTANCE_ID:?set NIMBUS_INSTANCE_ID}"

aws ssm send-command \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --comment "Nimbus deploy ${TAG}" \
  --parameters "commands=[
    \"set -e\",
    \"echo Deploying ${TAG}\",
    \"sed -i 's|^NIMBUS_IMAGE=.*|NIMBUS_IMAGE=${NIMBUS_ECR_REPOSITORY}:${TAG}|' /opt/nimbus/.env\",
    \"cd /opt/nimbus\",
    \"docker compose pull api\",
    \"docker compose up -d api\",
    \"docker compose ps\",
    \"curl -fsS http://127.0.0.1:8000/health\"
  ]"
