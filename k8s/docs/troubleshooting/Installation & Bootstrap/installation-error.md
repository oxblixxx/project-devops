# Kubernetes Installation Troubleshooting

This document records issues encountered while installing and bootstrapping Kubernetes with `kubeadm`.

---

## 1. Kubernetes APT Repository GPG Error

### Problem

While installing the Kubernetes packages:

```bash
sudo apt install kubeadm kubelet kubectl
```

APT returned a GPG signature error:

```text
The following signatures couldn't be verified because the public key is not available:
NO_PUBKEY 234654DA9A296436

W: GPG error: https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.35/deb InRelease:
The following signatures couldn't be verified because the public key is not available:
NO_PUBKEY 234654DA9A296436

E: The repository 'https://pkgs.k8s.io/core:/stable:/v1.35/deb InRelease' is not signed.

N: Updating from such a repository can't be done securely, and is therefore disabled by default.
```

### Cause

The Kubernetes APT repository was configured, but the system did not have the correct Kubernetes repository signing key available to APT.

### Fix

Remove the existing Kubernetes repository configuration:

```bash
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
```

Create the APT keyrings directory:

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings
```

Download and install the Kubernetes repository signing key:

```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Set the appropriate permissions:

```bash
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

Recreate the Kubernetes repository:

```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

Update the package index:

```bash
sudo apt update
```

### Verification

After running `apt update`, the GPG error was resolved and the Kubernetes repository could be accessed successfully.

---

# 2. kubeadm Init — CRI Runtime Error

### Problem

After installing Kubernetes, running:

```bash
sudo kubeadm init
```

returned:

```text
I0826 13:19:56.453242 4090267 version.go:260] remote version is much newer: v1.36.4; falling back to: stable-1.35
[init] Using Kubernetes version: v1.35.8
[preflight] Running pre-flight checks
[preflight] Some fatal errors occurred:
        [ERROR CRI]: could not connect to the container runtime:
        failed to create new CRI runtime service:
        validate service connection:
        validate CRI v1 runtime API for endpoint
        "unix:///var/run/containerd/containerd.sock":
        rpc error: code = Unimplemented desc = unknown service runtime.v1.RuntimeService

        [ERROR ContainerRuntimeVersion]: could not connect to the container runtime:
        failed to create new CRI runtime service:
        validate service connection:
        validate CRI v1 runtime API for endpoint
        "unix:///var/run/containerd/containerd.sock":
        rpc error: code = Unimplemented desc = unknown service runtime.v1.RuntimeService
```

### Important Note

The following message was **not the problem**:

```text
remote version is much newer: v1.36.4; falling back to: stable-1.35
[init] Using Kubernetes version: v1.35.8
```

`kubeadm` detected a newer Kubernetes version but correctly selected the `stable-1.35` version because the configured repository was for Kubernetes 1.35.

The actual problem was the CRI runtime error:

```text
unknown service runtime.v1.RuntimeService
```

### Investigation

Check whether the containerd CRI plugin is disabled:

```bash
sudo grep -n "disabled_plugins" /etc/containerd/config.toml
```

The output showed:

```text
15:disabled_plugins = ["cri"]
```

### Cause

The CRI plugin was explicitly disabled in the containerd configuration:

```toml
disabled_plugins = ["cri"]
```

Kubernetes uses the **Container Runtime Interface (CRI)** to communicate with containerd.

Because the CRI plugin was disabled, `kubeadm` could connect to the containerd socket but could not access the CRI v1 RuntimeService.

### Fix

Back up the existing containerd configuration:

```bash
sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.bak
```

Make sure CRI is not disabled.

Check:

```bash
sudo grep -n "disabled_plugins" /etc/containerd/config.toml
```

If the configuration contains:

```toml
disabled_plugins = ["cri"]
```

remove `cri` or remove the `disabled_plugins` configuration entirely.

Restart containerd:

```bash
sudo systemctl restart containerd
```

Verify that containerd is running:

```bash
sudo systemctl status containerd
```

Verify that the CRI plugin is active:

```bash
sudo ctr plugins ls | grep cri
```

The CRI plugin should show an `ok` status.

### Verify CRI

If `crictl` is installed:

```bash
sudo crictl info
```

The command should return information about the container runtime instead of the `unknown service runtime.v1.RuntimeService` error.

### Retry kubeadm

Once the CRI is working:

```bash
sudo kubeadm init
```

The Kubernetes control plane should now initialize successfully.

---


# Lessons Learned

### 1. APT repository errors

Kubernetes packages require a correctly configured repository and signing key. A missing GPG key prevents APT from securely verifying the repository.

### 2. Container runtime ≠ CRI

Having containerd installed and running does not automatically mean Kubernetes can use it.

Kubernetes communicates with containerd through the **Container Runtime Interface (CRI)**.

```text
Kubernetes
     │
     │ CRI
     ▼
  containerd
     │
     ▼
 Containers
```

### 3. Check the runtime before blaming kubeadm

When `kubeadm init` reports:

```text
unknown service runtime.v1.RuntimeService
```

investigate the container runtime and CRI configuration first.

Useful checks:

```bash
sudo systemctl status containerd
sudo ctr plugins ls | grep cri
sudo crictl info
```

### 4. Don't ignore CRI preflight errors

Do **not** solve this by using:

```bash
--ignore-preflight-errors=CRI
```

The CRI is fundamental to Kubernetes' ability to run containers. The correct approach is to fix the runtime configuration.

---

# Troubleshooting Pattern

For future Kubernetes installation problems, follow this general process:

```text
Installation Failure
        │
        ▼
Read the exact error
        │
        ▼
Identify the failing component
        │
        ├── APT?
        │
        ├── kubeadm?
        │
        ├── kubelet?
        │
        ├── containerd?
        │
        ├── CRI?
        │
        ├── networking?
        │
        └── configuration?
        │
        ▼
Inspect configuration/logs
        │
        ▼
Identify root cause
        │
        ▼
Apply targeted fix
        │
        ▼
Verify component
        │
        ▼
Retry installation
```

The objective is not just to make the installation work, but to understand **why it failed and how to diagnose the same class of problem in the future**.
