# Nimbus — Postmortem / Engineering Notes

## Summary

The goal was to convert a laptop-only application into a reproducible staging service with automated delivery, basic observability, and a recoverable deployment path.

## What went well

- The runtime is reproducible through Docker Compose.
- CI gates deployment on lint and tests.
- Image tags use the Git commit SHA, avoiding mutable-only deployment references.
- AWS authentication uses GitHub OIDC instead of a long-lived AWS access key.
- SSM removes the need to distribute SSH keys.
- Application health and readiness are explicit.
- Logs are available through Loki/Grafana.

## Known limitations

1. Staging uses one EC2 instance, so there is no high availability.
2. PostgreSQL runs on the same host as the application. A host failure can affect both.
3. There is no ALB or TLS termination in the baseline deployment.
4. There are no application metrics/alerts beyond health and logs.
5. Loki storage is local to the staging host.
6. Database backups are not automated in this take-home version.
7. There is no automated database migration framework yet.
8. The repository supplied in the assignment was not available in this environment, so the application is a representative Nimbus API rather than the hidden starter application.
9. The assignment mentions an existing flaky/known-bug test. Because the starter repository was not provided, that specific defect could not be reproduced. In a real submission I would capture the failing test, isolate whether it is product or test nondeterminism, and document the temporary mitigation rather than silently weakening the test gate.

## Security gaps / next steps

- Move database credentials to AWS Secrets Manager or SSM Parameter Store with runtime retrieval.
- Use private subnets for application/database resources.
- Put the service behind an HTTPS ALB.
- Add WAF and rate limiting.
- Add ECR image scanning and SBOM generation.
- Pin GitHub Actions to immutable commit SHAs.
- Add dependency and IaC security scans.
- Add CloudWatch metrics/alarms.
- Add automated encrypted database backups.
- Add multi-AZ managed PostgreSQL.
- Add deployment approvals for production.

## 10x traffic plan

First bottleneck: single EC2 and PostgreSQL.

Priority order:
1. Measure CPU, memory, request latency, error rate, DB connections and slow queries.
2. Move PostgreSQL to RDS.
3. Add ALB and at least two application instances/tasks.
4. Add autoscaling based on CPU/request latency.
5. Tune DB indexes and connection pooling.
6. Scale Redis and review cache hit ratio.
7. Add asynchronous workers for slow/non-critical operations.

## Data rollback warning

An application rollback is not a data rollback. If a deployment changes schema or data, first determine whether the old application can safely read the new schema. Prefer expand/contract migrations. For destructive changes, use a backup/restore or forward-fix strategy rather than pretending the previous container image can reverse the database.
