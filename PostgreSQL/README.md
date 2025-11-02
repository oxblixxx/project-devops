Setting up postgresql 
```sh
sudo apt update
sudo apt install postgresql postgresql-contrib -y
```

To login
```sh
sudo -u postgres psql
```
# SECURE POSTGRESQL
🧭 Step 1: Locate and open pg_hba.conf

Find where PostgreSQL stores this file (it depends on your version):

```sh
sudo find /etc/postgresql -name pg_hba.conf
```

You’ll likely see something like:

```sh
/etc/postgresql/16/main/pg_hba.conf
```

Open it:

```sh
sudo nano /etc/postgresql/16/main/pg_hba.conf
```

🧩 Step 2: Find this line (near the top):

It likely looks like this:

```
local   all             postgres                                peer
local   all             all                                     peer
```
change peer to `md5`. Save and exit the file and restart postgresql. This secures postgresql and all users!!!

```sh
sudo systemctl restart postgresql
```

Then login into postgresql, with postgresql user

```sh
ALTER USER postgres WITH PASSWORD 'Y8Xxxxxxxxxx';
\q
```

Change peer → md5 (or scram-sha-256 if you want stronger hashing):

local   all             postgres                                md5
