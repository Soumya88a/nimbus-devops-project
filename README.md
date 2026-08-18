# Nimbus DevOps Project
End-to-end DevOps pipeline for a 2-tier SaaS web app (API + DB + cache).

## Highlights
- Containerized with Docker (multi-stage build, non-root user)
- Infrastructure provisioned via Terraform (AWS free tier)
- CI/CD pipeline using GitHub Actions
- Monitoring with Prometheus + Grafana
- Rollback strategy via image versioning

## Run Locally
docker compose up

## Deploy
terraform apply

## Rollback
Refer to ROLLBACK.md
