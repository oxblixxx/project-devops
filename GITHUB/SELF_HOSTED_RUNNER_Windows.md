# Windows Self-Hosted GitHub Actions Runner Deployment Guide

# Overview

This document outlines the setup and troubleshooting process for a Windows self-hosted GitHub Actions runner used to deploy a .NET application to IIS.

---

## 1. Configure the GitHub Runner

Follow the provided steps by Github to configure the runner:

When prompted:

```
User account to use for the service
```

Enter:

```
.\<username>
```

or

```
<username>
```

Then provide the Windows password for the account.

---

## 2. Verify the Runner Service

```powershell
Get-Service | Where-Object {
    $_.DisplayName -like "*GitHub*" -or
    $_.Name -like "*actions*"
}
```

---

## 3. Restart the Runner

```powershell
Restart-Service "actions.runner.<runner-name>"
```

or

```powershell
Stop-Service "actions.runner.<runner-name>"
Start-Service "actions.runner.<runner-name>"
```

---



# TROUBLESHOOTING

## 4. If the Service Will Not Start

Check the service configuration:

```powershell
Get-CimInstance Win32_Service |
Where-Object {$_.Name -like "actions.runner*"} |
Select Name, StartName, State, ExitCode
```


## 5. Verify Git Installation

```powershell
git --version
```

If PowerShell cannot find Git:

```powershell
& "C:\Program Files\Git\cmd\git.exe" --version
```

Expected:

```
git version 2.55.0.windows.3
```

---


## 6. Verify Git Is On PATH

Check:

```powershell
$env:PATH
```

Should contain:

```
C:\Program Files\Git\cmd
```

Verify:

```powershell
where.exe git
```

Expected:

```
C:\Program Files\Git\cmd\git.exe
```

---

## 7. Add Git to PATH (Temporary)

```powershell
$env:PATH="C:\Program Files\Git\cmd;$env:PATH"
```

---

## Permission Denied (.git/FETCH_HEAD)

```
cannot open '.git/FETCH_HEAD'
```

Cause:

- Runner service running under a different account than the repository owner.

Fix:

- Configure the runner service to run as the same Windows user that owns the repository.

---

