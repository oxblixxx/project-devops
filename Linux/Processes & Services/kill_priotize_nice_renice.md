1. kill
Overview

kill sends a signal to a specific process using its Process ID (PID).

Despite its name, kill does not always terminate a process. It simply sends signals, which the process may handle differently.

Syntax
kill [signal] PID

Example:

kill 1234
Common Signals
Signal	Number	Description
SIGTERM	15	Gracefully terminate process (default)
SIGKILL	9	Force kill immediately
SIGHUP	1	Reload configuration
SIGSTOP	19	Pause process
SIGCONT	18	Resume paused process
Examples
Graceful termination
kill 1234

or

kill -15 1234
Force kill a process
kill -9 1234

This cannot be ignored by the process.

Reload a service
kill -HUP 1234

Often used for daemons like web servers to reload configuration.

2. pkill
Overview

pkill sends signals to processes based on their name or pattern, instead of using a PID.

It is useful when you want to terminate multiple processes matching a name.

Syntax
pkill [signal] process_name
Examples
Kill all nginx processes
pkill nginx
Force kill
pkill -9 nginx
Match full command
pkill -f python

The -f option matches the entire command line, not just the process name.

Related Command: pgrep

To list PIDs before killing them:

pgrep nginx

Show command details:

pgrep -a nginx
3. nice
Overview

nice starts a process with a specific scheduling priority.

Linux uses a niceness value to determine how much CPU time a process receives.

Niceness Scale
Niceness	Priority
-20	Highest priority
0	Default
19	Lowest priority

Higher niceness = less CPU priority

Syntax
nice -n VALUE command
Examples
Start a low-priority process
nice -n 10 python3 script.py

This ensures the script does not heavily compete for CPU.

Start high priority process
sudo nice -n -5 python3 important_task.py

Only root can assign negative values.

4. renice
Overview

renice changes the priority of an already running process.

Unlike nice, which starts a process with priority, renice modifies an existing one.

Syntax
renice priority -p PID
Examples
Lower priority of running process
renice 10 -p 1234
Increase priority
sudo renice -5 -p 1234

Root privileges are required.
