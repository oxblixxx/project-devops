The following steps outline the basic SQL Server configuration required before deploying the application.
---

# Step 1: SQL Server Setup
Verify the SQL Server Instance

Open PowerShell:

```powershell
Get-Service -Name MSSQL*,SQLBrowser
```

Example:

|Status  | Name              | DisplayName                              |
|--------|-------------------|------------------------------------------|
|Running||  MSSQL$SQLEXPRESS | |SQL Server (SQLEXPRESS)                 |
|Running | MSSQLFDLauncher.. | SQL Full-text Filter Daemon Launcher...  |
|Running |  MSSQLLaunchpad$..| SQL Server Launchpad (SQLEXPRESS)        |    
|Stopped |  SQLBrowser       |  SQL Server Browser                      |

From this output, the SQL Server instance name is:

>SQLEXPRESS

# SQL Server Configuration

## Determine the SQL Server Server Name

The application connects using the value specified in the connection string:

```text
Server=<ServerName>\<InstanceName>;
```

Examples:

```text
Server=VM5\SQLEXPRESS;
```

```text
Server=<ComputerName>\SQLEXPRESS;
```

To confirm the computer name, run:

```powershell
$env:COMPUTERNAME
```

If SQL Server is hosted on a different server, use the remote server's hostname or IP address instead.

Examples:

```text
Server=192.168.1.100\SQLEXPRESS;
```

or

```text
Server=DBSERVER\SQLEXPRESS;
```

If SQL Server is installed on the same machine as the application, you can also use:

```text
Server=localhost\SQLEXPRESS;
```

---

## Create the SQL Login

```sql
CREATE LOGIN OXBLIXXXX
WITH PASSWORD = 'ixxxx618dW4a';
GO
```

---

## Create the Database User

```sql
USE oxblixxx_db;
GO

CREATE USER OXBLIXXXX
FOR LOGIN OXBLIXXXX;
GO
```

---

## Grant Database Permissions

Grant the user the `db_owner` role on the application database:

```sql
ALTER ROLE db_owner
ADD MEMBER OXBLIXXXX;
GO
```

>Note: db_owner provides full control over the database. In production, follow the principle of least privilege and grant only the permissions the application requires.

# Step 2: PostgreSQL Setup

1. Connect as a PostgreSQL superuser:

```sh
psql -U postgres
```

2. Create the application role:

```sh
CREATE DATABASE IIS;

CREATE USER IIS_USER WITH PASSWORD 'your_secure_password';

GRANT ALL PRIVILEGES ON DATABASE IIS TO IIS_USER;

\c IIS

ALTER SCHEMA public OWNER TO IIS_USER;
GRANT ALL PRIVILEGES ON SCHEMA public TO IIS_USER;
```
