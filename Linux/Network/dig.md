## INTRODUCTION
Dig is a command-line tools used to query DNS servers to troubleshoot domain name resolution, it's more powerful, script-friendly, preferred by engineers.

```bash
dig [domain]
dig google.com
```

## 1 . Query a Specific Record Type
To query A Record (IPv4), AAAA Record (IPv6), MX Record (Mail server), TXT Record, NS Record (nameservers)
```bash
dig google.com A
dig google.com AAAA
dig google.com MX
dig google.com TXT
dig google.com NS
```

## 3. Query a Specific DNS Server
Useful when debugging DNS propagation.

```bash
dig google.com @8.8.8.8
```

```bash
dig google.com @1.1.1.1
```

## 4. Short Output (Cleaner)

```bash
dig google.com +short
>142.250.190.14
```

## 5. Trace DNS Resolution Path
Shows the full DNS chain from root → TLD → authoritative server.

```bash
dig google.com +trace
```

## 5. Show Only the Answer Section
Sometimes you want to remove the extra DNS metadata.

```BASH
dig google.com +noall +answer
>google.com.  300  IN  A  142.250.190.14
```

## 6. Show Only the Question Section
```BASH
dig google.com +noall +question
>;google.com.   IN   A
```

## 7. Show Authority Section
Shows extra DNS data returned.
```BASH
dig google.com +noall +authority
```

## 8. Show Additional Section

```BASH
dig google.com +noall +additional
```

## 9. Query Multiple Domains

```BASH
dig google.com yahoo.com amazon.com
```

## 10. Query Multiple Record Types

```BASH
dig google.com A MX NS
```

## 11. Change DNS Port
Useful if testing non-standard DNS servers. Default DNS port = 53
```BASH
dig google.com @8.8.8.8 -p 53
```

## 12. Set Query Timeout
Wait 2 seconds before timeout.
```BASH
dig google.com +time=2
```

## 12. DNSSEC Validation
Check DNS security signatures.

```BASH
dig google.com +dnssec
```

## 13. Check SOA Record (Start of Authority)
Important for DNS zone debugging.
```BASH
dig google.com SOA
>google.com. 60 IN SOA ns1.google.com. dns-admin.google.com.
```

Shows:
- primary nameserver
- admin contact
- serial number
- refresh times

