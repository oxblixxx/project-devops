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




#### HERE IS STEPS FOR MY PROXMOX HOMELAB ON MY HARDWARE
Proxmox Lab on Legacy Hardware
This document describes how I built my Proxmox homelab  on an older host without working KVM hardware virtualization.

```sh
1. Host Overview and Limits
Hardware: AMD Athlon II X2 (2 cores), ~8 GB RAM.​

Virtualization: AMD‑V present but KVM acceleration not usable for guests; VMs run with software emulation.​
```


2. Fixing KVM Errors on Old CPUs
Symptom
Starting any VM shows:

TASK ERROR: KVM virtualisation configured, but not available. Either disable in VM configuration or enable in BIOS.​

or:

kvm: CPU model 'host' requires KVM or HVF in the task log.

Diagnosis
On the Proxmox node:

bash
egrep -i 'vmx|svm' /proc/cpuinfo   # shows svm (AMD‑V present)
lsmod | egrep 'kvm'               # shows kvm_amd and kvm
These confirm the CPU supports virtualization, but the platform still cannot expose working KVM to guests.

Workaround (per VM)
In the VM configuration:

Disable hardware virtualization

VM → Options → KVM hardware virtualization → set to No.

Use a generic CPU model

VM → Hardware → Processors:

Type = kvm64 not host.

Result: VMs start successfully using pure QEMU emulation, at the cost of performance.

3. Using Ubuntu Cloud Images Instead of Installer ISOs
Previously I had full live server iso, so I had to install a cloud img. [Cloud images](https://cloud-images.ubuntu.com/) are preinstalled minimal systems designed for automation and Cloud‑Init.

Downloaded
For Ubuntu 22.04 (Jammy) AMD64:
Download jammy-server-cloudimg-amd64.img from the Jammy cloud-images directory.
Upload and Import
Upload to ISO storage:
Datacenter → node → local (directory) → ISO Images → Upload jammy-server-cloudimg-amd64.img.

Import into LVM storage as a VM disk:

```sh
qm importdisk <VMID> /var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img local-lvm
Replace <VMID> with the VM number.
```

Attach Disk and Fix PXE Loop
Symptom

Console shows: “Boot from Hard Disk… not a bootable disk… iPXE… Nothing to boot; No such file or directory”, looping.

Cause

The cloud image was attached as a CD/DVD instead of a boot disk, so BIOS falls back to PXE.

Fix

VM → Hardware → Remove the CD/DVD that points to jammy-server-cloudimg-amd64.img.

In Hardware, select the imported unused disk (e.g. vm-100-disk-1), click Edit / Add → Existing Disk, and:

Bus/Device: SCSI 0 on VirtIO SCSI single.

VM → Options → Boot Order:

Put the SCSI0 cloud-image disk first.


4. Enabling Login with Cloud‑Init
Ubuntu cloud images do not ship with a default password; password login was enabled and credentials must be set by Cloud‑Init.

Add Cloud‑Init Drive
VM → Hardware → Add → CloudInit Drive.

Bus/Device: IDE 0 (simple and safe).​

Storage: local (directory storage is fine for this tiny drive).

Now the Cloud‑Init tab no longer shows “No CloudInit Drive found”.

Configure User and Regenerate Image
VM → Cloud‑Init tab → Edit:

User: e.g. ubuntu or your name.

Password: set a lab password.

(Optional) set static IP, DNS, and SSH public key.

Click Regenerate Image on the Cloud‑Init tab to rebuild the config ISO.

Power‑cycle the VM:

Shutdown (if running) → Start again. Cloud‑Init reads the config only at boot.

Result: log in on the console with the user/password you configured; SSH login with your key also works if provided.

5. Storage Layout: local vs local-lvm
local (directory)

Use for ISO images, cloud images before import, templates, and small Cloud‑Init drives.

local-lvm (LVM-thin)

Use for VM system and data disks (including imported cloud-image disks). Supports snapshots and efficient thin provisioning.

This layout keeps the root filesystem from filling and makes VM management easier.
