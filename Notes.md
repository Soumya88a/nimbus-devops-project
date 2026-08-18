# Postmortem Notes

## Improvements with More Time
- Add automated scaling and alerting.
- Integrate a secrets manager (AWS Secrets Manager or Vault).

## Known Limitations
- Basic monitoring only; no alert thresholds.
- Manual rollback for database changes.

## Security Gaps
- No IAM role separation yet.
- Secrets rotation not automated.
