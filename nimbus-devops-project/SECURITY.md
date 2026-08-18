# Security Strategy

## Secrets

No credentials are committed to Git.

Local development uses `.env`, which is ignored by Git. `.env.example` contains placeholders only.

Staging:
- GitHub Actions uses OIDC to assume an AWS deployment role.
- The EC2 instance uses an IAM role for ECR and SSM.
- PostgreSQL credentials are generated on the host during bootstrap.
- The generated environment file is owned by root and has mode `0600`.
- The database password is not passed as a Docker build argument and is not present in the image.

## Least privilege

The GitHub deployment role can:
- push to the Nimbus ECR repository
- send SSM commands to the Nimbus staging instance

The EC2 role can:
- pull from the Nimbus ECR repository
- communicate with SSM

It does not receive broad administrator permissions.

## Future improvement

For production, retrieve application/database secrets at runtime from AWS Secrets Manager or SSM Parameter Store using an instance/task role. Avoid putting secret values into Terraform state.

## Image hygiene

The Dockerfile:
- uses a multi-stage build
- copies only required runtime files
- runs as a non-root UID
- has no secret build arguments
- uses a `.dockerignore`

Before production, add:
- Trivy/image scanning
- SBOM
- signed images/attestations
- pinned base-image digests
