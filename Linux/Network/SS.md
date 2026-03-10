## Overview

In Linux, there is an important distinction between:

1. **A port allowed by the firewall**
2. **A port that has a service actively listening**

A firewall can allow traffic to a port, but **if no process binds to that port, it is not considered listening**. Tools like `ss` only display **existing sockets**, not firewall rules.

---

# Understanding How Ports Work

When a client attempts to connect to a server port, the following happens:

1. The packet reaches the server.
2. The firewall determines whether the packet is allowed.
3. The kernel checks if any process is **listening on that port**.

Possible outcomes:

| Situation | Result |
|---|---|
| Firewall allows port + service listening | Connection succeeds |
| Firewall allows port + no service listening | Connection refused |
| Firewall blocks port | Connection timeout |

---

# Using `ss` to Check Listening Ports

`ss` (Socket Statistics) displays **active sockets**.

## Basic Command

```bash
ss -tuln
```
Meaning:
- -t → TCP
- -u → UDP
- -l → listening sockets
- -n → show numeric ports

## 2. Identify Which Process Is Using a Port
When two services conflict or a port is already in use.

```sh
ss -tulpn
```

## 3. See Active Connections to Your Server
To monitor who is connected to your server.

```sh
ss -tn
```

## 4. Investigate High Network Traffic
If your server has high load or suspicious traffic.

```bash
ss -s
```

## 5. Debug Application Connectivity
When an application cannot reach another service. For example **App cannot connect to Redis/Postgres**

```bash
ss -t state established
```

## 6. Filter Connections by Port

```bash
>check traffic on port 443
ss -tn sport = :443
```


## 7. Check Specific Connection States
For deeper debugging.

```sh
ss -tan state time-wait
```

## 8. Debug Kubernetes / Container Networking
In container environments you may want to check node-level sockets, maybe pods cannot reach service

```bash
ss -lntp
```

## 9. Find Suspicious Connections (Security)

```sh
ss -tnp
```

## 10. Monitor Real-Time Connections
Useful during production debugging for real-time

```sh
watch -n 1 ss -tuna
```

>NB
>1️⃣ Local Address:Port      `This is the IP address and port on your machine (the server where you ran ss).`
>2️⃣ Peer Address:Port   `This is the remote system and port you are connected to.`
