# Overview

Before deploying a .NET application, identify:

1. Which database engine it connects to (SQL Server, PostgreSQL, MySQL, etc.).
2. Ensure the application has a database user with the required permissions.

## Step 1: Confirm the ORM

The quickest way to determine the ORM is to inspect the project dependencies.

Open the project's .csproj file and look for the Entity Framework provider package.

1. SQL Server
```sh
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="*" />
```

2. PostgreSQL
```sh
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="*" />
```

3. MySQL / MariaDB

```sh
<PackageReference Include="Pomelo.EntityFrameworkCore.MySql" Version="*" />
```

4. SQLite

```sh
<PackageReference Include="Microsoft.EntityFrameworkCore.Sqlite" Version="*" />
```


