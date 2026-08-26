# Kubernetes Self-Managed Cluster

A hands-on Kubernetes project focused on building, operating, troubleshooting, and understanding a Kubernetes cluster from the ground up.

The goal of this project is not simply to deploy Kubernetes, but to develop a strong understanding of how Kubernetes works internally by manually building and managing the infrastructure.

> **Project Status:** 🚧 In Progress

---

## 🎯 Project Goals

This project is designed to build practical Kubernetes and cloud-native infrastructure skills by working with a self-managed cluster.

### Primary Goals

* Build a Kubernetes cluster from scratch using `kubeadm`
* Understand Kubernetes control-plane and worker-node architecture
* Configure and operate `containerd` as the container runtime
* Configure Kubernetes networking using a CNI
* Deploy and manage workloads using Kubernetes manifests
* Understand Pods, Deployments, ReplicaSets, Services and Namespaces
* Implement persistent storage with Longhorn
* Learn Kubernetes networking and service discovery
* Implement Ingress
* Configure resource requests and limits
* Implement health checks and probes
* Learn Kubernetes scheduling, taints and tolerations
* Implement RBAC
* Manage Secrets and ConfigMaps
* Monitor cluster and application health
* Implement logging and observability
* Practice cluster troubleshooting and failure recovery
* Automate Kubernetes deployments
* Document the architecture and operational procedures

---

## 🏗️ Planned Architecture

The initial cluster will consist of three Linux servers.

```text
                         Internet
                            │
                            ▼
                    ┌───────────────┐
                    │    Ingress    │
                    │   Controller  │
                    └───────┬───────┘
                            │
                    ┌───────▼───────┐
                    │   Kubernetes  │
                    │    Cluster    │
                    └───────┬───────┘
                            │
          ┌─────────────────┼─────────────────┐
          │                 │                 │
          ▼                 ▼                 ▼
   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
   │   Node 01   │   │   Node 02   │   │   Node 03   │
   │             │   │             │   │             │
   │ Control     │   │ Worker      │   │ Worker      │
   │ Plane       │   │             │   │             │
   │             │   │             │   │             │
   │ containerd  │   │ containerd  │   │ containerd  │
   │ Longhorn    │   │ Longhorn    │   │ Longhorn    │
   └─────────────┘   └─────────────┘   └─────────────┘
          │                 │                 │
          └─────────────────┼─────────────────┘
                            │
                     Longhorn Storage
                         Replicas
```

The architecture will evolve as additional Kubernetes components and infrastructure are introduced.

---

## 🖥️ Infrastructure

| Component         | Planned Configuration |
| ----------------- | --------------------- |
| Nodes             | 3                     |
| Control Plane     | 1                     |
| Worker Nodes      | 2                     |
| Operating System  | Ubuntu Linux          |
| Kubernetes        | v1.35.x               |
| Container Runtime | containerd            |
| Cluster Bootstrap | kubeadm               |
| CNI               | TBD                   |
| Ingress           | TBD                   |
| Storage           | Longhorn              |
| Monitoring        | TBD                   |
| Logging           | TBD                   |

---

# 🚀 Project Roadmap

## Phase 1 — Infrastructure Preparation

* [x] Provision Kubernetes servers
* [x] Install containerd
* [x] Configure containerd
* [x] Enable CRI
* [x] Enable `SystemdCgroup`
* [x] Install `kubeadm`
* [x] Install `kubelet`
* [x] Install `kubectl`
* [ ] Configure hostnames
* [ ] Configure `/etc/hosts` or DNS
* [ ] Configure firewall rules
* [ ] Verify node-to-node connectivity

---

## Phase 2 — Kubernetes Control Plane

* [x] Initialize control plane with `kubeadm`
* [ ] Configure `kubectl`
* [ ] Install CNI
* [ ] Verify CoreDNS
* [ ] Verify Kubernetes system Pods
* [ ] Generate worker join command
* [ ] Document control-plane components

The cluster is being bootstrapped using `kubeadm`, which is Kubernetes' official tool for creating a minimum viable Kubernetes cluster.

---

## Phase 3 — Worker Nodes

* [ ] Join worker node 01
* [ ] Join worker node 02
* [ ] Verify all nodes
* [ ] Verify node conditions
* [ ] Verify kubelet
* [ ] Verify container runtime
* [ ] Test Pod scheduling

Expected result:

```bash
kubectl get nodes
```

```text
NAME       STATUS   ROLES           AGE
node-01    Ready    control-plane   ...
node-02    Ready    <none>          ...
node-03    Ready    <none>          ...
```

---

# 🧠 Kubernetes Concepts

A major objective of this project is to understand Kubernetes rather than simply memorize commands.

## Cluster Architecture

The cluster consists of a control plane and worker nodes.

### Control Plane

The control plane manages the desired state of the cluster.

Key components:

* kube-apiserver
* etcd
* kube-scheduler
* kube-controller-manager

### Worker Nodes

Worker nodes run application workloads.

Key components include:

* kubelet
* kube-proxy
* container runtime

---

# 📦 Workloads

I will progressively deploy different Kubernetes workload types.

* [ ] Pod
* [ ] ReplicaSet
* [ ] Deployment
* [ ] StatefulSet
* [ ] DaemonSet
* [ ] Job
* [ ] CronJob

Example application:

```text
Deployment
    │
    ├── Pod
    ├── Pod
    └── Pod
```

Topics to investigate:

* Desired state
* Reconciliation
* Replica management
* Rolling updates
* Rollbacks
* Scaling
* Self-healing

---

# 🌐 Networking

## CNI

* [ ] Select CNI
* [ ] Install CNI
* [ ] Understand Pod CIDR
* [ ] Understand node networking
* [ ] Test Pod-to-Pod communication
* [ ] Test Pod-to-Service communication
* [ ] Test Service-to-Service communication

## Services

* [ ] ClusterIP
* [ ] NodePort
* [ ] LoadBalancer
* [ ] Headless Services

## Ingress

* [ ] Deploy Ingress Controller
* [ ] Configure HTTP routing
* [ ] Configure HTTPS
* [ ] Configure TLS certificates
* [ ] Route traffic to multiple applications

---

# 💾 Storage

Longhorn will be used to learn Kubernetes persistent storage and distributed storage.

## Longhorn

* [ ] Install Longhorn
* [ ] Configure storage disks
* [ ] Create StorageClass
* [ ] Create PersistentVolumeClaim
* [ ] Attach volume to Pod
* [ ] Test persistent data
* [ ] Test replica behavior
* [ ] Simulate node failure
* [ ] Recover workloads after node failure

Planned architecture:

```text
              Longhorn
                  │
       ┌──────────┼──────────┐
       │          │          │
       ▼          ▼          ▼
    Node 01    Node 02    Node 03
    Replica    Replica    Replica
       │          │          │
       └──────────┼──────────┘
                  │
             Kubernetes PVC
```

---

# 🔐 Security

* [ ] Understand Kubernetes authentication
* [ ] Configure RBAC
* [ ] Create ServiceAccounts
* [ ] Create Roles
* [ ] Create ClusterRoles
* [ ] Configure RoleBindings
* [ ] Manage Secrets
* [ ] Understand NetworkPolicies
* [ ] Secure Kubernetes API access
* [ ] Restrict administrative access

---

# 📊 Observability

## Monitoring

* [ ] Metrics Server
* [ ] Prometheus
* [ ] Grafana
* [ ] Node metrics
* [ ] Pod metrics
* [ ] Resource utilization
* [ ] Kubernetes alerts

## Logging

* [ ] Container logs
* [ ] Node logs
* [ ] Centralized logging
* [ ] Log aggregation
* [ ] Log querying

---

# ⚙️ Resource Management

* [ ] CPU requests
* [ ] CPU limits
* [ ] Memory requests
* [ ] Memory limits
* [ ] ResourceQuota
* [ ] LimitRange
* [ ] Horizontal Pod Autoscaler
* [ ] Vertical Pod Autoscaler

---

# 🧩 Scheduling

Topics to investigate:

* [ ] Node selectors
* [ ] Node affinity
* [ ] Pod affinity
* [ ] Pod anti-affinity
* [ ] Taints
* [ ] Tolerations
* [ ] Topology spread constraints
* [ ] Pod priority
* [ ] Scheduling failures

---

# 🔄 High Availability & Failure Testing

The cluster will be deliberately tested under failure conditions.

### Experiments

* [ ] Stop kubelet
* [ ] Stop containerd
* [ ] Kill a Pod
* [ ] Drain a node
* [ ] Cordon a node
* [ ] Shut down a worker
* [ ] Restore a worker
* [ ] Simulate storage failure
* [ ] Test Longhorn replica recovery
* [ ] Test application rescheduling

Example:

```bash
kubectl cordon node-02
kubectl drain node-02 --ignore-daemonsets
```

Then observe how Kubernetes responds.

---

# 🛠️ Troubleshooting Lab

A major part of this project will be intentionally troubleshooting broken components.

Examples:

```text
Pod stuck in Pending
        │
        ├── insufficient resources?
        ├── taint?
        ├── affinity?
        └── PVC problem?

Pod stuck in ContainerCreating
        │
        ├── CNI?
        ├── volume?
        ├── image?
        └── runtime?

Pod CrashLoopBackOff
        │
        ├── application?
        ├── configuration?
        ├── Secret?
        └── dependency?
```

Every significant failure will be documented with:

1. Problem
2. Symptoms
3. Investigation
4. Root cause
5. Fix
6. Prevention

---

# 📚 Commands & Notes

Useful commands will be documented here as the project progresses.

### Cluster

```bash
kubectl get nodes
kubectl get pods -A
kubectl get namespaces
kubectl cluster-info
```

### Workloads

```bash
kubectl get pods
kubectl get deployments
kubectl get replicasets
kubectl describe pod <pod>
kubectl logs <pod>
```

### Nodes

```bash
kubectl describe node <node>
kubectl cordon <node>
kubectl uncordon <node>
kubectl drain <node>
```

### Debugging

```bash
kubectl describe <resource> <name>
kubectl get events --sort-by=.lastTimestamp
kubectl logs <pod>
```

---

# 📁 Repository Structure

```text
kubernetes-project/
│
├── README.md
│
├── cluster/
│   ├── kubeadm/
│   ├── networking/
│   └── nodes/
│
├── manifests/
│   ├── namespaces/
│   ├── deployments/
│   ├── services/
│   ├── configmaps/
│   ├── secrets/
│   └── ingress/
│
├── storage/
│   └── longhorn/
│
├── monitoring/
│   ├── prometheus/
│   └── grafana/
│
├── applications/
│
├── scripts/
│
└── docs/
    ├── architecture/
    ├── troubleshooting/
    └── experiments/
```

---

# 🧪 Experiments

This section will contain hands-on experiments performed on the cluster.

| Experiment         | Objective                        | Status |
| ------------------ | -------------------------------- | ------ |
| Cluster bootstrap  | Build cluster with kubeadm       | 🚧     |
| CNI deployment     | Establish Pod networking         | ⏳      |
| Worker joining     | Add worker nodes                 | ⏳      |
| Deployment scaling | Understand replicas              | ⏳      |
| Rolling update     | Understand deployments           | ⏳      |
| Service discovery  | Understand Kubernetes networking | ⏳      |
| Persistent storage | Deploy Longhorn                  | ⏳      |
| Node failure       | Test workload recovery           | ⏳      |
| RBAC               | Implement least privilege        | ⏳      |
| Monitoring         | Monitor cluster                  | ⏳      |
| Logging            | Centralize logs                  | ⏳      |

---

# 🎯 Learning Outcome

By the end of this project, I want to be able to confidently:

* Build a Kubernetes cluster from scratch
* Explain Kubernetes architecture
* Troubleshoot Kubernetes without blindly copying commands
* Deploy and operate applications
* Debug networking problems
* Debug storage problems
* Understand scheduling decisions
* Secure workloads with RBAC and NetworkPolicies
* Monitor cluster health
* Perform node maintenance
* Recover from common failures
* Understand how Kubernetes components communicate
* Operate Kubernetes in a production-like environment

The objective is **operational understanding**, not simply completing a Kubernetes tutorial.

---

# 📖 References

* [Kubernetes Documentation](https://kubernetes.io/docs/)
* [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
* [Kubernetes Cluster Architecture](https://kubernetes.io/docs/concepts/architecture/)
* [kubeadm Documentation](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
* [Creating a Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

---

## 🚧 Current Status

**Current phase:** Cluster Bootstrap

### Completed

* Kubernetes package repository configured
* containerd installed
* containerd CRI issue identified and fixed
* `disabled_plugins = ["cri"]` removed
* `SystemdCgroup = true` configured
* containerd restarted successfully
* CRI verified

### Next Steps

1. Initialize the control plane
2. Configure `kubectl`
3. Install a CNI
4. Join the two worker nodes
5. Verify the cluster
6. Deploy the first workload
7. Begin Kubernetes networking experiments
8. Deploy Longhorn
9. Begin failure-testing experiments

---

**Project Status:** 🚧 Building

**Focus:** Kubernetes | Containerd | Networking | Storage | Security | Observability | Troubleshooting
