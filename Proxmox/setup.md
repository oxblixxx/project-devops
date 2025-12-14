---

# **Proxmox VM Setup – Working Configuration Guide**

This documentation provides the **exact working configuration** used to successfully create and run a Linux virtual machine on Proxmox without CPU feature errors and with fully functional networking, storage, and system components.

---

## **1. General VM Settings**

| Setting       | Value                                         |
| ------------- | --------------------------------------------- |
| **Name**      | Any (e.g., `linux-test-vm`)                   |
| **Guest OS**  | Linux                                         |
| **Version**   | Default / 6.x or higher                       |
| **ISO Image** | Linux distribution ISO (Ubuntu, Debian, etc.) |

---

## **2. System Configuration**

### **Machine**

* `i440fx` (default)
* Reason: Most compatible with all Linux distros.

### **BIOS**

* `SeaBIOS`
* Reason: Simple, stable, avoids UEFI-specific complications unless required.

### **Graphics Card**

* `Default`
* Reason: Works well for CLI or basic GUI use.

### **SCSI Controller**

* `VirtIO SCSI`
* Reason: Best performance, fully supported by modern Linux.

### **QEMU Guest Agent**

* **Enabled**
* Enables graceful shutdown, IP reporting, and better backup handling.

### **TPM**

* **Disabled**
* Only needed for Windows 11 or security-reliant systems.

---

## **3. CPU Configuration**

| Setting     | Value    |
| ----------- | -------- |
| **Sockets** | `1`      |
| **Cores**   | `1`      |
| **Type**    | `qemu64` |

### **Why qemu64?**

Using `x86-64-v2-AES`, `host`, or other advanced models caused errors:

```
kvm: host doesn't support requested feature: CPUID.01H:ECX.sse4.1
kvm: host doesn't support requested feature: CPUID.01H:ECX.aes
```

`qemu64` avoids unsupported CPU instructions and ensures successful boot.

---

## **4. Memory Configuration**

| Setting          | Value                        |
| ---------------- | ---------------------------- |
| **Memory (RAM)** | `1 GB` (recommended minimum) |

### Notes:

* 1 GB is fine for CLI/server-only Linux distros.
* Increase to **2–4 GB** for GUI environments.

---

## **5. Disk Configuration**

| Setting          | Value                        |
| ---------------- | ---------------------------- |
| **Bus/Device**   | `SCSI 0`                     |
| **Disk Size**    | `12 GB`                      |
| **Cache**        | Default (`No cache`)         |
| **Discard**      | Enabled (optional)           |
| **Storage Type** | Thin-provisioned recommended |

### **Discard**

Enable if your Proxmox storage is:

* ZFS
* LVM-thin
* Any thin-provisioned backend

This allows TRIM inside the VM and frees unused space.

---

## **6. Network Configuration**

### **Network Device**

* Model: `VirtIO (paravirtualized)`
* Bridge: `vmbr0` (or any LAN-connected bridge)
* VLAN Tag: leave empty unless required

### Assigning Private IP Inside the VM

#### Example (Ubuntu/Debian using Netplan):

```
nano /etc/netplan/01-netcfg.yaml
```

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens18:
      addresses: [192.168.1.50/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

Apply with:

```bash
sudo netplan apply
```

#### Verify:

```bash
ip a
ping 192.168.1.1
```

---

## **7. Inside the VM – QEMU Agent Installation**

### Install QEMU Guest Agent

```bash
sudo apt update
sudo apt install qemu-guest-agent -y
sudo systemctl enable --now qemu-guest-agent
```

This enables IP reporting, proper shutdown, and better backups.

---

## **8. Summary of Working Configuration**

```
Machine:           i440fx
BIOS:              SeaBIOS
SCSI Controller:   VirtIO SCSI
Graphics:          Default
Agent:             Enabled
TPM:               Disabled

CPU Type:          qemu64
Sockets:           1
Cores:             1

RAM:               1 GB

Disk:              12 GB, SCSI 0
Cache:             Default
Discard:           Enabled (optional)

Network:           VirtIO, vmbr0
Private IP:        Static via Netplan
```

This configuration boots cleanly without:

* CPU instruction errors
* KVM feature errors
* Boot failures
* Unsupported host feature issues

---

If you want, I can also generate:

* a **Proxmox CLI qm command** to create this VM automatically
* a **cloud-init template**
* or a **full network design for multiple private VM ranges**

Just tell me.


```
TASK ERROR: KVM virtualisation configured, but not available. Either disable in VM configuration or enable in BIOS.
```

I go this error and the fix was simply to go to the bios of my baremetal and enable hypervisor. Go to SEcurity > System security, the save and restart the baremetal.

Download cloud init images `https://cloud-images.ubuntu.com/`
