# Deploying a .NET Application with IIS

## Overview

This document outlines the basic steps required to deploy a modern ASP.NET application (e.g., net6.0, net8.0, net10.0) to Internet Information Services (IIS) on Windows.


## Prerequisites

Before deploying, ensure the following are installed:

- Windows Server or Windows with IIS enabled
- IIS (Internet Information Services)
- .NET Hosting Bundle matching the application's target framework
- Application published using dotnet publish

## Project-Structure

Typical Project Structure
```sh
MyApplication/
│
├── Program.cs                  ← Application entry point
├── appsettings.json            ← Application configuration and the logs directory is here.
├── appsettings.Development.json
├── MyApplication.csproj        ← Project definition
├── Properties/
│   └── launchSettings.json     ← Local development settings
│
├── wwwroot/                    ← Static files (CSS, JS, Images)
├── bin/                        ← Compiled output (generated)
├── obj/                        ← Intermediate build files (generated)
└── README.md
```

## Database in a .NET Application

The application needs a connection string to communicate with the database. Connection strings are typically stored in `appsettings.json`

```json
  "ConnectionStrings": {
    "DefaultConnection": "Server=VM5\\SQLEXPRESS;Database=Xxxxx;UserId=xxxxx;Password=iOxxxxxx8dW4a;Encrypt=False;TrustServerCertificate=True;Timeout=60;MultipleActiveResultSets=true"
  },
```




