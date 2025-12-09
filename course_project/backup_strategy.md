# Backup and Recovery Strategy for Pharmacy Management Database

This document outlines the backup and recovery strategy for the PostgreSQL-based pharmacy management system database. It focuses on regular backups, secure storage, and tested recovery procedures.

## Objectives
- **Data Protection**: Safeguard against data loss from hardware failures, human errors, cyberattacks, or disasters.
- **Recovery Time Objective (RTO)**: Aim for recovery within 4 hours for critical incidents.
- **Recovery Point Objective (RPO)**: Limit data loss to 1 hour (via continuous archiving) or 24 hours (via daily backups).
- **Compliance**: Encrypt backups and maintain audit logs for sensitive health data.
- **Testing**: Regularly test restores to ensure reliability.

## Backup Types and Tools
We use PostgreSQL's built-in tools for backups:
1. **Logical Backups** (using `pg_dump` and `pg_dumpall`):
   - Exports schema and data in SQL format.
   - Suitable for smaller databases or migrations.
   - Advantages: Portable, compressible; can restore to different PostgreSQL versions.
   - Disadvantages: Slower for large databases; doesn't include server configs.

2. **Physical Backups** (using `pg_basebackup`):
   - Copies the entire data directory (base backup).
   - Combined with Write-Ahead Log (WAL) archiving for Point-in-Time Recovery (PITR).
   - Advantages: Faster restores; supports PITR.
   - Disadvantages: Larger files; version-specific.

3. **WAL Archiving**:
   - Continuous archiving of transaction logs (enabled via `archive_mode = on` in `postgresql.conf`).
   - Allows recovery to any point in time between backups.

## Backup Schedule
- **Daily Logical Backups**: Run `pg_dump` nightly (e.g., via cron job at 2:00 AM) for the entire database. Compress with `gzip`.
- **Weekly Physical Backups**: Run `pg_basebackup` every Sunday, including WAL files.
- **Continuous WAL Archiving**: Archive WAL segments every 5 minutes to a dedicated directory.
- **Retention Policy**:
  - Keep 7 daily backups.
  - Keep 4 weekly backups.
  - Keep 12 monthly backups (archive the last weekly of each month).
  - Automatically purge older backups using scripts.


## Storage and Security
- **On-Site Storage**: Store backups on a separate disk or NAS within the server room.
- **Off-Site Storage**: Replicate backups to cloud storage (e.g., AWS S3 or Google Cloud Storage) using encrypted transfers (HTTPS/TLS).
- **Encryption**: Use `pg_dump` with `--format=c` for compressed dumps; encrypt files with GPG or AES-256 before off-site transfer.
- **Access Controls**: Restrict backup directories to root/postgres user; use multi-factor authentication for cloud access.
- **Monitoring**: Use tools like Nagios or Prometheus to alert on backup failures.

## Recovery Procedures
1. **Full Restore from Logical Backup**:
   - Stop the application.
   - Drop and recreate the database: `dropdb pharmacy_db; createdb pharmacy_db`.
   - Restore: `gunzip -c backup.sql.gz | psql -U postgres -d pharmacy_db`.
   - Test data integrity and restart services.

2. **Point-in-Time Recovery (PITR) from Physical Backup**:
   - Restore base backup: Copy files to data directory or use `pg_basebackup` in recovery mode.
   - Configure `recovery.conf` (or `postgresql.conf` in newer versions) with `restore_command` to fetch WAL files.
   - Set `recovery_target_time` to the desired timestamp.
   - Start PostgreSQL in recovery mode; it will replay WAL logs up to the target.

3. **Partial Recovery**:
   - For specific tables/objects: Use `pg_restore` with `--table` or `--schema` flags on custom-format dumps.


## Testing and Maintenance
- **Quarterly Drills**: Simulate failures and perform full restores on a test server. Document time taken and issues.
- **Annual Review**: Update strategy based on database growth (current size: ~500 MB; monitor via `pg_database_size`).
- **Automation**: Use tools like pgBackRest or Barman for advanced management if the system scales.
- **Documentation**: Maintain logs of all backups/restores in a secure repository.

## Risks and Mitigations
- **Risk: Backup Corruption**: Mitigate by verifying backups post-creation (e.g., `pg_restore --list`).
- **Risk: Downtime During Backup**: Use streaming replication for hot backups if high availability is needed.
- **Risk: Data Breach**: Encrypt all backups and monitor access logs.
