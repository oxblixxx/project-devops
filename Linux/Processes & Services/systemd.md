For understanding of systemd, the [man page](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html?__goaway_challenge=meta-refresh&__goaway_id=79e3a67f24229b0c9cc295f771ef2ae3&__goaway_referer=https%3A%2F%2Fmedium.com%2F%40charlessampa%2Fintroduction-to-systemd-in-linux-a-beginners-guide-29cbdef42ad5) is looked into
Here are Key Takeaways from the systemd Man Pages
# 1. What systemd Is
systemd is the init s# ystem and service manager for Linux. It is the first process started by the kernel and becomes PID 1.

Its responsibilities:
- Start and stop services
- Mount filesystems
- Manage system state
- Handle dependencies between services
- Provide logging
- Manage devices and sessions

So instead of scripts controlling boot, systemd orchestrates everything.

# 2. Everything is a Unit
The most important concept, systemd manages units.
A unit = a configuration object that systemd manages.

## Examples of unit types:

- Unit Type	Purpose
- service	system service
- socket	socket activation
- mount	filesystem mount
- automount	automatic mount
- target	group of units
- device	hardware device
- timer	scheduled job
- path	trigger when file changes
- slice	resource control

## Example:
- nginx.service
- ssh.service
- home.mount
- multi-user.target

## Unit files live in:

- /etc/systemd/system/
- /usr/lib/systemd/system/
- /run/systemd/system/

## Priority:
- /etc > /run > /usr/lib

## 3. Services Replace Init Scripts
Traditional Linux:

```sh
/etc/init.d/service start
```

With systemd:

```sh
systemctl start service
```

Common commands:

```sh
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl status nginx
systemctl enable nginx
systemctl disable nginx
```

Key idea:

systemctl is the main interface to systemd.

## 4. Targets Replace Runlevels

Old Linux used runlevels:

0 halt
1 single user
3 multi user
5 graphical
6 reboot

systemd replaces these with targets.

Example targets:

- Target	Meaning
- rescue.target	single user
- multi-user.target	normal server mode
- graphical.target	GUI
- reboot.target	reboot
- poweroff.target	shutdown

Example:

systemctl isolate multi-user.target
## 5. Dependency System

Units can depend on other units.

Example relationships:

- Requires=
- Wants=
- After=
- Before=
- Conflicts=

Example:

[Unit]
Requires=network.target
After=network.target

Meaning:

service needs network

service starts after network

This dependency graph allows parallel boot.

## 6. Boot Is Parallel

Unlike old init systems:

systemd starts services in parallel whenever dependencies allow it.

This is why boot is much faster.

systemd builds a dependency tree and executes it concurrently.

## 7. Unit File Structure

A typical service file:

/etc/systemd/system/myapp.service

Example:

[Unit]
Description=My Application
After=network.target

[Service]
ExecStart=/usr/bin/myapp
Restart=always

[Install]
WantedBy=multi-user.target

Sections:

Section	Purpose
Unit	metadata and dependencies
Service	service behavior
Install	how it is enabled
8. Enabling vs Starting

These are different.

Start:

systemctl start nginx

Starts now.

Enable:

systemctl enable nginx

Starts automatically at boot.

Enable works by creating symlinks in target directories.

9. Logging With journald

systemd provides a logging system:

journald

View logs:

journalctl

Examples:

journalctl -u nginx
journalctl -b
journalctl -f

Features:

structured logs

indexed

boot-aware

centralized

10. Timers Replace Cron (Optionally)

systemd timers schedule jobs.

Example:

backup.timer

Equivalent to cron but integrated with systemd.

Example timer unit:

[Timer]
OnCalendar=daily
Persistent=true
11. systemd Tracks Processes

systemd tracks services using cgroups.

This means:

it knows every process a service spawns

it can kill the whole service tree

Example:

systemctl kill nginx

Kills all processes belonging to that unit.

12. Reloading systemd

If you modify a unit file:

systemctl daemon-reload

This reloads unit definitions.

Without this, systemd will not see your changes.

13. Inspecting Units

Useful commands:

systemctl list-units
systemctl list-unit-files
systemctl show nginx
systemctl cat nginx
systemctl status nginx

These help debug systemd behavior.

14. Masking a Service

You can completely disable a service:

systemctl mask nginx

This prevents any service from starting it, even manually.

15. systemd Is Modular

systemd includes several subsystems:

Component	Purpose
systemd	init system
journald	logging
logind	login/session manager
udev	device management
resolved	DNS resolver
timedated	time management
networkd	networking
Mental Model

Think of systemd as:

A dependency-based orchestration engine for system resources.

Where units are nodes and dependencies are edges.

If You Want to Go Deeper

The most important man pages:

man systemd
man systemctl
man systemd.unit
man systemd.service
man systemd.target
man systemd.timer
man journalctl



1. Units (Everything in systemd is a Unit)

The fundamental concept.

systemd manages units, which are configuration objects.

Common ones you will use:

Unit	What it manages
.service	services/processes
.target	boot states
.timer	scheduled jobs
.mount	filesystems
.socket	socket activation
.path	file change triggers

Examples:

nginx.service
ssh.service
multi-user.target
backup.timer

Check running units:

systemctl list-units

Check all installed units:

systemctl list-unit-files
2. systemctl (Main Control Command)

Everything you do with systemd goes through systemctl.

Essential commands:

Start service:

systemctl start nginx

Stop service:

systemctl stop nginx

Restart service:

systemctl restart nginx

View status:

systemctl status nginx
3. Enable vs Start (Very Important)

Many engineers confuse this.

Start:

systemctl start nginx

Starts right now.

Enable:

systemctl enable nginx

Starts at boot.

Disable:

systemctl disable nginx

Doesn't start on boot.

Under the hood:

enable creates symlinks to targets.

4. Service File Structure

Most real work is editing service files.

Typical location:

/etc/systemd/system/myapp.service

Basic service example:

[Unit]
Description=My App
After=network.target

[Service]
ExecStart=/usr/bin/python app.py
Restart=on-failure
User=www-data

[Install]
WantedBy=multi-user.target

Key options to remember:

Option	Meaning
Description	service description
ExecStart	command to run
Restart	restart behavior
User	run as user
After	dependency
5. daemon-reload (Critical)

Whenever you modify a service file:

systemctl daemon-reload

This tells systemd to reload unit definitions.

Then restart the service:

systemctl restart myapp
6. Targets (Replacement for Runlevels)

Targets represent system states.

Common targets:

Target	Meaning
multi-user.target	server mode
graphical.target	desktop
rescue.target	maintenance mode
reboot.target	reboot
poweroff.target	shutdown

Default boot target:

systemctl get-default

Change boot target:

systemctl set-default multi-user.target
7. Journald (systemd Logging)

systemd includes its own logging system.

View logs:

journalctl

View logs for a service:

journalctl -u nginx

View logs for current boot:

journalctl -b

Follow logs live:

journalctl -f
8. Dependencies (Service Ordering)

systemd uses dependency graphs.

Common directives:

Directive	Meaning
After	start after another unit
Requires	must have this unit
Wants	optional dependency
Before	start before another unit

Example:

[Unit]
After=network.target
Requires=network.target

Meaning:

Service needs network and starts after it.

Bonus: 3 Things That Make systemd Powerful

These are worth knowing but slightly more advanced.

1️⃣ Timers (Cron replacement)

Example:

backup.timer

Schedules services.

2️⃣ Socket Activation

systemd starts services only when traffic arrives.

Example:

nginx.socket
nginx.service
3️⃣ cgroups

systemd tracks services using Linux control groups.

Meaning:

If a service spawns 10 child processes, systemd still manages them.

Real Mental Model

Think of systemd like this:

Units = objects
Targets = system states
systemctl = control interface
journald = logs
dependencies = execution order



1. systemctl status

The first command you should always run.

systemctl status nginx

Shows:

service state

main PID

last logs

exit codes

restart attempts

Example output clues:

failed

exit-code

permission denied

No such file or directory

Tip:

systemctl status nginx -l

-l prevents line truncation.

2. journalctl -u

View logs for a specific service.

journalctl -u nginx

Most common debugging command.

Useful variations:

journalctl -u nginx -n 50

Last 50 logs.

journalctl -u nginx -f

Live logs.

3. journalctl -xe

Shows recent system errors with explanations.

journalctl -xe

Helpful when:

service won't start

permission errors

dependency failures

-x adds explanations from systemd.

4. systemctl cat

Shows the exact service file systemd is using.

systemctl cat nginx

Very useful because services may have:

override files

drop-in configurations

Example:

/etc/systemd/system/nginx.service
/usr/lib/systemd/system/nginx.service
5. systemctl show

Displays all properties of a service.

systemctl show nginx

Useful fields:

MainPID
ExecStart
Restart
TimeoutStartUSec
ActiveState
SubState

You can filter:

systemctl show nginx | grep Exec
6. systemctl list-dependencies

Shows dependency tree.

systemctl list-dependencies nginx

Useful when:

services start in wrong order

dependencies missing

target problems

Example:

nginx.service
 ├─network.target
 └─system.slice
7. systemctl daemon-reexec

Rare but powerful.

systemctl daemon-reexec

This restarts systemd itself without rebooting the system.

Useful when:

systemd state becomes inconsistent

service manager bugs appear

8. systemctl is-active

Quick health check.

systemctl is-active nginx

Output:

active
inactive
failed

Very useful in scripts.

Example:

systemctl is-active nginx && echo OK
9. systemctl list-units --failed

Shows all failed services.

systemctl list-units --failed

Example output:

nginx.service        loaded failed failed
mysql.service        loaded failed failed

Great for system audits.

10. systemd-analyze blame

Shows which services slow down boot.

systemd-analyze blame

Example:

4.211s mysql.service
2.315s nginx.service
1.889s docker.service

Useful for performance debugging.

Bonus (Very Useful)
Show boot critical chain
systemd-analyze critical-chain

Shows boot dependency delays.

Verify service file
systemd-analyze verify myapp.service

Checks for:

syntax errors

invalid directives

dependency issues

Real Debugging Workflow

When a service fails, the typical workflow is:

Step 1
systemctl status service
Step 2
journalctl -u service
Step 3
systemctl cat service
Step 4
systemctl list-dependencies service
Step 5
systemd-analyze verify service
Pro Tip (Very Useful in Production)

Watch logs while restarting a service:

journalctl -fu nginx

Then in another terminal:

systemctl restart nginx

You see real-time startup failures.
