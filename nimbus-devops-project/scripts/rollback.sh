#!/usr/bin/env bash
set -euo pipefail

TAG="${1:?usage: ./scripts/rollback.sh <known-good-sha>}"
REGION="${AWS_REGION:?set AWS_REGION}"
INSTANCE_ID="${NIMBUS_INSTANCE_ID:?set NIMBUS_INSTANCE_ID}"
REPO="${NIMBUS_ECR_REPOSITORY:?set NIMBUS_ECR_REPOSITORY}"

aws ssm send-command \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --comment "Nimbus rollback ${TAG}" \
  --parameters "commands=[
    \"set -e\",
    \"cd /opt/nimbus\",
    \"sed -i 's|^NIMBUS_IMAGE=.*|NIMBUS_IMAGE=${REPO}:${TAG}|' /opt/nimbus/.env\",
    \"docker compose pull api\",
    \"docker compose up -d api\",
    \"curl -fsS http://127.0.0.1:8000/health\"
  ]"
