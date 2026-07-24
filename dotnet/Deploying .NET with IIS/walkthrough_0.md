# Overview

## STEP 1: CONFIRM IF IT A MULTIPLE PROJECT.
Before deploying a .NET application, observe the project root, if there is `slns`. 

A .NET solution (.sln) groups one or more related .NET projects into a single workspace.

Check if the project contains a solution file:

```PowerShell
Get-ChildItem -Filter *.sln
```

```bash
grep -RIn "*.sln" .
```

If a .sln file exists, the application likely consists of multiple projects.

Next, identify the entry project by locating the project that contains Program.cs. Open its .csproj file to review the target framework and any <ProjectReference> entries, which show how the projects are connected.



## Step 2: Confirm the ORM

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

After identifying the database provider, proceed to the [Database Setup guide](./database.md) for the appropriate configuration steps based on the application's ORM and database engine.
