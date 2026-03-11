## INTRODUCTION
Uncomplicated Firewall(UFW) is a user-friendly frontend to iptables designed to make firewall management simple.

## Check UFW Status
It essential to check the status of UFW before running allowing/denying any rule with UFW.
```bash
sudo ufw status
```
By default, it comes installed on Debian distros, otherwise install with.

```sh
sudo ufw install ufw
```

## DEFAULT POLICIES
Before adding rules, set UFW default rules to only allow outgoing traffic and deny incoming traffic by default!!

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

## ENABLING UFW
If UFW is installed and inactive, it's required to enable UFW for usage. 
>NB: BEFORE RUNNING THE `ufw enable` command, ensure that `sudo ufw allow 22` has been executed to prevent been locked from the server.

```bash
sudo ufw allow 22
sudo ufw enable
sudo ufw status
```

## ENABLING OTHER PORTS
There are quite some necessarry ports to be opened, this is optional and not necessarily in order after enabling UFW, likes of HTTP, HTTPS could be allowed.

```bash
sudo ufw allow http
sudo ufw allow https
```

## DENY RULE
To deny drop/deny unwanted incomming traffic to a port, simple run

```bash
sudo ufw deny <port-number>
sudo ufw deny 21
```

## Allow / Deny by IP Address
To allow specific IP:

```sh
sudo ufw allow from 192.168.1.50
```
while this is insecure as it allows the incoming requests from the IP to all port. This should only be done for `TRUSTED MACHINES`

Instead, allow specific IP to a port:
```bash
sudo ufw allow from 192.168.1.50 to any port 22
```

## ALLOW A RANGE OF PORT
To allow a range of ports
```bash
sudo ufw allow 1000:2000/tcp  
```

## 6. Allow / Deny by Subnet
Allowing a subnet allows the ips within the range of the subnet

```bash
sudo ufw allow from 192.168.1.0/24 to any port 80
```

## LOGGING
Loggin is essential in every infrastructure, to enable UFW logging, simple do:

```bash
sudo ufw logging on
sudo ufw logging high
sudo ufw logging medium
sudo ufw logging off
```
Then logs appear in /var/log/ufw.log


## 8. Delete / Remove Rules
To delete a rule, run:

```bash
sudo ufw status numbered
>then choose the number assigned to the rule
sudo ufw delete 6
```
It's to not that the number ordering changes after delete a rule.

## 9. Advanced Features
Limit connections (prevent brute-force attacks)

```bash
sudo ufw limit ssh/tcp
```

## 10. IPv6 Support
By default, a ufw rule is created for both IPV4 and IPV6, to disable IPV6 incase it's not in need

```bash
sudo nano etc/default/ufw:
>modify the line below
IPV6=yes
```

## 12. Reset UFW
Reseting the UFW undoes the current rule set and saves a backup of the rule in a directory which will be shown on the screen after resetting.

```bash
sudo ufw reset
```
