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
5. Dependency System

Units can depend on other units.

Example relationships:

Requires=
Wants=
After=
Before=
Conflicts=

Example:

[Unit]
Requires=network.target
After=network.target

Meaning:

service needs network

service starts after network

This dependency graph allows parallel boot.

6. Boot Is Parallel

Unlike old init systems:

systemd starts services in parallel whenever dependencies allow it.

This is why boot is much faster.

systemd builds a dependency tree and executes it concurrently.

7. Unit File Structure

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

If you'd like, I can also show you:

The 20% of systemd concepts that give 80% mastery (what Linux engineers actually use).
