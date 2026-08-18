# Nimbus Rollback Plan

## Application-only rollback

Nimbus images are immutable and tagged with the Git commit SHA.

Example:

```bash
./scripts/rollback.sh 9f3c2a1
```

The script:
1. Pulls the selected ECR image.
2. Rewrites the staging image reference.
3. Restarts only the API container.
4. Waits for the healthcheck.
5. Reports the resulting image.

## Automatic rollback

The deployment script records the current image tag before changing it. If the new container fails its healthcheck, it attempts to restore the previous tag.

The CI job remains failed even if rollback succeeds. Recovery is not the same as successful delivery.

## Database/data rollback

Do **not** automatically roll back the application if a deployment also performed an incompatible data migration.

Classify the migration:

- Backward-compatible schema change: application rollback may be safe.
- Expand/contract migration: old application can usually continue while the new schema is present.
- Destructive migration: do not blindly roll back. Restore from a verified backup or perform a forward fix.
- Data corruption: stop writes if necessary, preserve evidence, identify the affected time window, restore to a safe point, and reconcile lost writes.

For production, I would require:
- automated encrypted backups
- point-in-time recovery
- migration versioning
- pre-deploy backup verification
- explicit approval for destructive migrations
- a tested disaster-recovery runbook

## Rollback verification

```bash
curl -fsS http://STAGING_HOST/health
docker compose ps
docker compose logs --tail=100 api
```

Success criteria:
- API health is OK.
- Error rate returns to baseline.
- Application image is the intended SHA.
- Database remains consistent.
- No new restart loop is present.
