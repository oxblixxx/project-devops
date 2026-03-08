## Server Monitoring
After examining `ps` `top` and `htop` my preference is `htop` and `glances`. My preference is htop and glances comes next. Great feature I like `htop` for is the cpu cores bars.

## 1. htop
This is an Interactive, real-time monitoring of processes, CPU, memory, and system load. Great for spotting high CPU/memory usage quickly.

> While it comes by default in some distro, it require installation in others. Installation (Ubuntu/Debian):

```sh
sudo apt update
sudo apt install htop
```

Basic Usage:

```sh
htop
```

Key Features:

- CPU Bars: Shows usage per core, color-coded.
- Memory & Swap: Tracks usage in real-time.
- Process Management:
- F5 → Tree view (see process hierarchy)
- F6 → Sort by CPU, memory, etc.
- F9 → Kill a process
- F7/F8 → Renice (change priority)
- Search/filter: F3 to search for process by name.

Tips:

Press F2 → Setup → Meters to customize what info you see.


## 2. iotop

Monitors disk I/O usage per process in real-time. Helps identify which processes are causing high disk activity.

Installation (Ubuntu/Debian):
> While it comes by default in some distro, it require installation in others.  Installation (Ubuntu/Debian):

```sh
sudo apt update
sudo apt install iotop
sudo iotop
```
**sudo is required to see all processes.**

Key Features:

- TX / RX per process: Disk read/write in bytes/sec.
- Sort by I/O usage interactively.
- Monitor top offenders causing disk bottlenecks.

Tips:

**Use -o to show only processes actively doing I/O:**

```sh
sudo iotop -o
```

## 3. iftop

Monitor network bandwidth usage per connection in real-time. Useful for spotting IPs using high network traffic.

Installation (Ubuntu/Debian):

```sh
sudo apt update
sudo apt install iftop
sudo iftop
```

### Key Features:
- Shows SRC → DST, transmit (TX) and receive (RX) bytes.
- Color-coded bars for high traffic connections.
- Displays top network consumers in real-time.

Tips:

- Press t to toggle display of totals.
- Press n to toggle numeric IPs/hostnames.
- Press p to show ports.
- h for help


💡 Pro Tip:

htop = live, interactive overview.

iotop = live disk I/O per process.

iftop = live network per connection.

Combine these tools to quickly identify and respond to resource spikes.  Best practice is to setup a Prometheus/Grafana to visualize and just keep htop as your “PID inspector”, and Grafana as your long-term eyes.




Htop after Grafana alerts to inspect the PID causing a spike.
Use together with Grafana alerts to identify IP causing traffic spikes.
