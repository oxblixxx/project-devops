# Infrastructure Backup & Security Strategy

## 1. Introduction
This setup provides a robust, file-level backup strategy focused on **Application Critical Data**. Unlike full-disk cloning, this approach targets specific high-value artifacts to optimize storage and recovery speed. 

### Core Targets:
* **Databases:** Automated dumps for MySQL and PostgreSQL.
* **Logs:** System and application logs.
* **Directories:** Critical configuration and data folders.

### Security "Shift-Left"
This strategy integrates security early in the process. A dedicated system service user and enforce **Least Privilege Access** at the database level.

---

## 2. Deployment Phase 1: Infrastructure Automation
The Ansible script handles the "plumbing" of the system. It installs the necessary clients, configures secure SMTP for notifications, and sets up the cron lifecycle.

**Action:** Execute the playbook to prepare the environment.
```bash
ansible-playbook -i inventory.ini deploy_backup.yml
```

## 3. Deployment Phase 2: Database "ClickOps"
After the configuration is provisioned, configuration of the database users is the next action.

#### A. MySQL User Configuration

```SQL
-- Create the dedicated backup service user
CREATE USER 'backupsvc'@'localhost' IDENTIFIED BY 'YOUR_SECURE_PASSWORD';

-- Grant permissions for logical backups
GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backupsvc'@'localhost';

FLUSH PRIVILEGES;
```
#### B. PostgreSQL User Configuration
PostgreSQL requires access permissions for both the connection and the specific schemas being backed up.

```Bash
# Create the user
sudo -u postgres psql -c "CREATE USER backupsvc WITH PASSWORD 'YOUR_SECURE_PASSWORD';"

# Grant CONNECT to all existing databases
sudo -u postgres psql -t -A -q -c "SELECT datname FROM pg_database WHERE datistemplate = false;" | \
while IFS= read -r db; do
  sudo -u postgres psql -d "$db" -c "GRANT CONNECT ON DATABASE \"$db\" TO backupsvc;"
done
```
#### Step 2: Grant Data Read permissions (Run within the target database):
```SQL
-- Allow schema usage
GRANT USAGE ON SCHEMA public TO backupsvc;

-- Allow reading tables and sequences for dumps
GRANT SELECT ON ALL TABLES IN SCHEMA public TO backupsvc;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO backupsvc;

-- For PostgreSQL 14+, use the global read role for simplicity
GRANT pg_read_all_data TO backupsvc;
```
