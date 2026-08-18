# GitHub setup

After `terraform apply`, create these repository **Variables** (not Secrets):

- `AWS_REGION`
- `AWS_DEPLOY_ROLE_ARN`
- `NIMBUS_INSTANCE_ID`

The workflow obtains temporary AWS credentials using GitHub OIDC.

For a real organization, pin GitHub Actions to commit SHAs and add environment protection rules before production deployment.
