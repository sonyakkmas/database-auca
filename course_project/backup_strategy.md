**Backup & Recovery Strategy – Pharmacy DB**

**1. Goals**

* RPO: ≤ 5–15 min.
* RTO: ≤ 2–4 h.
* No loss of: patients, prescriptions, sales, inventory, insurance, users/RBAC.

---

**2. Backups**

**Logical (pg_dump)**

* Daily full dump (night):

```bash
pg_dump -U pharmacy_app -d pharmacy_db -F c \
  -f /backups/daily/pharmacy_$(date +%F).dump
```

* Weekly dump:

```bash
pg_dump -U pharmacy_app -d pharmacy_db -F c -s \
  -f /backups/schema/pharmacy_schema_$(date +%F).dump
```

**Continious (Physical + WAL)**

* `archive_mode = on`
* `archive_command = 'cp %p /backups/wal/%f'`
* Base backup every 6 hour (4 per day) with continous backups for Point in Time Recovery.

```bash
pg_basebackup -U replication_user \
  -D /backups/base/$(date +%F) -F tar -z -X stream -P
```

---

**3. Retention & Storage**

* Daily: store last 30 days on a backup server for fast recovery
* Weekly: store in cloud for 5+ years for compliance
* Continous: last day locally on backup server

---

**4. Daily backup job**

1. Check DB up + disk space.
2. Run `pg_basebackup`.
3. Run daily `pg_dump`.
4. Verify (exit codes, `pg_restore --list`).
5. Sync to backup server + cloud.
6. Delete old backups per retention.

---

**5. Recovery**

**Logical restore**

* For bad migration / deletes:

  * Restore dump to new DB:

  ```bash
  createdb pharmacy_restore

  pg_restore -U postgres -d pharmacy_restore \
    /backups/daily/pharmacy_YYYY-MM-DD.dump
  ```

  * Validate, then switch app or copy needed data.

**Full server failure (PITR)**

1. New Postgres instance.
2. Restore latest base backup to data dir.
3. Configure:

```conf
restore_command = 'cp /backups/wal/%f %p'
recovery_target_time = 'YYYY-MM-DD HH:MI:SS'
```

4. Start Postgres, let WAL replay.
5. Sanity checks, then point app to new server.
