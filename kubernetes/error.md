# KUBERNETS

## Table of Contents
- [`error: You must be logged in to the server (the server has asked for the client to provide credentials)`](#error: You must be logged in to the server (the server has asked for the client to provide credentials))

## error: You must be logged in to the server (the server has asked for the client to provide credentials)
In this issue encountered, whenever I run this command `kubectl get nodes` or `kubectl get ns`. So what I did was to backup the config file `cp ~/.kube/config config.bck1` then  `rm -rf ~/.kube/config` Then i ran the below command to fix it.
```sh
 sudo cp /etc/kubernetes/admin.conf ~/.kube/config
```

So basically quick one, k8s control plane wasnt fully upgraded. It shows this 
```sh
 kubectl get nodes
NAME                            STATUS   ROLES           AGE    VERSION
k8scn.datanotchconsulting.com   Ready    control-plane   433d   v1.30.14
wrk1.datanotchconsulting.com    Ready    <none>          433d   v1.30.14
wrk2.datanotchconsulting.com    Ready    <none>          433d   v1.30.14
```
So, i had tried to upgrade to v1.31, then I got this error 
```sh
 sudo kubeadm upgrade apply v1.31.10
[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade/init config] FATAL: this version of kubeadm only supports deploying clusters with the control plane version >= 1.30.0. Current version: v1.29.13
To see the stack trace of this error execute with --v=5 or higher
```
and this result is because it in a partially upgraded state.
I confirmed the version, then I got this
```sh
kubectl version
Client Version: v1.30.14
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.29.13
```

So I had to revert ```sudo nano /etc/apt/sources.list.d/kubernetes.list``` to version 1.30, then I ran this command ``` sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y``` then this ```sudo apt-cache madison kubeadm```  then this ``` sudo apt install -y kubeadm=1.30.14-1.1 --allow-downgrades``` Then i had to run ``` sudo kubeadm upgrade apply v1.30.14``` and boom!!! The error was fixed. 


I also got this error 
```sh
 sudo kubeadm upgrade apply v1.32.6
[upgrade] Reading configuration from the "kubeadm-config" ConfigMap in namespace "kube-system"...
[upgrade] Use 'kubeadm init phase upload-config --config your-config.yaml' to re-upload it.
[upgrade] FATAL: failed to get config map: Get "https://172.16.30.106:6443/api/v1/namespaces/kube-system/configmaps/kubeadm-config?timeout=10s": dial tcp 172.16.30.106:6443: connect: connection refused
To see the stack trace of this error execute with --v=5 or higher
```
i DONT KNOW WHAT HAPPENED, I RAN THE COMMAND kubeadm init phase upload-config --config your-config.yaml, AND I GOT AN ERROR, THEN I RAN THE UPGRADE APPLY COMMAND AND IT WORKS
