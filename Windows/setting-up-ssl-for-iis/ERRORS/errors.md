# Table of Contents

* [Overview](#overview)
* [Resolving a Win-ACME ARI Renewal Conflict on IIS](#Resolving-a-Win-ACME-ARI-Renewal-Conflict-on-IIS)

# Resolving a Win-ACME ARI Renewal Conflict on IIS

## Overview

A staging SSL certificate failed to renew which is managed by Win-ACME where the scheduled renewal task executed successfully, but certificate renewal consistently failed.

## Environment

* Web Server: Microsoft IIS
* Certificate Client: Win-ACME v2.2.9.1701
* Certificate Authority: Let's Encrypt

## Verifying Automatic Renewal

I first confirmed that Win-ACME had a renewal configuration configured by opening the renewal manager:

```text
A
```

The renewal history showed multiple successful renewals, confirming that the certificate had been renewed automatically in the past.

I also verified that the Windows Scheduled Task responsible for renewals existed:

```powershell
Get-ScheduledTask | Where-Object {$_.TaskName -match "acme|wacs"}
```

The scheduled task was present and in the **Ready** state.

To inspect its execution status, I ran:

```powershell
Get-ScheduledTask -TaskName "win-acme renew (acme-v02.api.letsencrypt.org)" | Get-ScheduledTaskInfo
```

The output indicated:

* The scheduled task had executed.
* The next execution time was correctly scheduled.
* The last execution returned an error code.

## Error Encountered

Attempting to run the renewal manually produced the following error:

```text
[HTTP] Request completed with status Conflict

Failed to create order:
Could not validate ARI 'replaces' field ::
cannot indicate an order replaces certificate with serial "...",
which already has a replacement order

Renewal for [IIS] RFC, (any host) failed, will retry on next run.

Unable to create order.
No certificate generated.
```

## Root Cause

This was an ACME Renewal Information (ARI) conflict between Win-ACME and Let's Encrypt.

Let's Encrypt had already associated the existing certificate with a replacement order. When Win-ACME attempted to create another replacement order, the ACME server rejected the request with an HTTP **409 Conflict**.

The issue was not caused by:

* IIS configuration
* Certificate bindings
* Windows Scheduled Task
* Automatic renewal configuration

Instead, it was caused by stale renewal metadata maintained by Win-ACME.

## Resolution

To resolve the issue, I recreated the renewal configuration.

### Step 1 – Open the Renewal Manager

```text
A
```

### Step 2 – Select the Existing Renewal

Select the renewal entry from the list.

### Step 3 – Cancel the Renewal Configuration

```text
C
```

This removes only the Win-ACME renewal configuration. It does **not** delete the certificate currently installed in IIS.

### Step 4 – Create a New Renewal

Return to the main menu and create a new certificate configuration:

```text
N
```

Win-ACME then recreated the renewal configuration using the current IIS site configuration.

## Result

Recreating the renewal configuration cleared the stale ARI state, allowing Win-ACME to establish a fresh renewal configuration with Let's Encrypt.

The scheduled task remained in place and continued to manage certificate renewals automatically.

## Key Takeaways

* Verify that the Windows Scheduled Task exists before troubleshooting certificate renewal issues.
* An HTTP **409 Conflict** with the message `Could not validate ARI 'replaces' field` indicates an ACME renewal metadata conflict rather than an IIS or SSL configuration problem.
* Canceling and recreating the Win-ACME renewal configuration is an effective way to resolve stale renewal metadata while preserving the installed certificate.
* Recreating the renewal configuration does not remove the existing certificate from IIS; it only rebuilds the renewal metadata used by Win-ACME.
