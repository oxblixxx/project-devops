# KUBERNETS

## Table of Contents
- [`error: You must be logged in to the server (the server has asked for the client to provide credentials)`](#error: You must be logged in to the server (the server has asked for the client to provide credentials))

## error: You must be logged in to the server (the server has asked for the client to provide credentials)
In this issue encountered, whenever I run this command `kubectl get nodes` or `kubectl get ns`. So what I did was to backup the config file `cp ~/.kube/config config.bck1` then  `rm -rf ~/.kube/config` Then i ran the below command to fix it.
```sh
 sudo cp /etc/kubernetes/admin.conf ~/.kube/config
```

