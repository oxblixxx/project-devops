## 1. kill
kill sends a signal to a specific process using its Process ID (PID).

Syntax
```sh
kill [signal] PID
kill 1234
```

Common Signals
- Signal	Number	Description
- SIGTERM	15	Gracefully terminate process (default)
- SIGKILL	9	Force kill immediately
- SIGHUP	1	Reload configuration
- SIGSTOP	19	Pause process
- SIGCONT	18	Resume paused process

For a graceful termination for a pid `1234`

```sh
kill 1234
```

or

```sh
kill -15 1234
>Force kill a process
kill -9 1234
```
This cannot be ignored by the process.

### Reload a service
```sh
kill -HUP 1234
```
Often used for daemons like web servers to reload configuration.

## 2. pkill
pkill sends signals to processes based on their name or pattern, instead of using a PID. It is useful when you want to terminate multiple processes matching a name.

#### Syntax
pkill [signal] process_name,  to kill all nginx processes

```sh
pkill nginx
>Force kill
pkill -9 nginx
>Match full command
pkill -f python
```

The -f option matches the entire command line, not just the process name.

#### Related Command: `pgrep`

To list PIDs before killing them:

```sh
pgrep nginx
Show command details:
>pgrep -a nginx
```


## 3. nice
nice starts a process with a specific scheduling priority. Linux uses a niceness value to determine how much CPU time a process receives.

### Niceness Scale
1. -20	Highest priority
2. 0	Default
3. 19	Lowest priority
They can't go lower than -20 and higher than 19.

Higher niceness = less CPU priority

```sh
nice -n VALUE command
>Start a low-priority process. This ensures the script does not heavily compete for CPU.
nice -n 10 python3 script.py
>Start high priority process
sudo nice -n -5 python3 important_task.py
```
Only root can assign negative values.

## 4. renice
renice changes the priority of an already running process. Unlike nice, which starts a process with priority, renice modifies an existing one.

```sh
renice priority -p PID
>Lower priority of running process
renice 10 -p 1234
>Increase priority
sudo renice -5 -p 1234
```
Root privileges are required.
