# Kubernetes Cluster Setup with Kubeadm (VM-Based)

This repository provides step-by-step instructions and a setup script to deploy a **Kubernetes cluster** using **kubeadm** on **3 Ubuntu VMs**:

- **1 Master Node**
- **2 Worker Nodes**
- All VMs use **bridge-mode networking** with interface `ens33`

---

##  Prerequisites

- 3 Ubuntu virtual machines
- All VMs should use bridged networking
- You have `sudo` access on all machines
- Internet access is available on the VMs

---

## Files in This Repository

- `k8s-cluster-setup.sh` – Script to configure and deploy Kubernetes components

---

##  Setup Overview

### Network Configuration (All Nodes)

Ensure `ens33` (or your interface name) gets a bridged IP every time:

```ini
# /etc/systemd/network/10-ens33.network
[Match]
Name=ens33

[Network]
DHCP=yes
```

## Validation

Check kube api connection to master and worker nodes - those commands displays all the existing pods and its state 

```bash
kubectl get nodes
kubectl get pods -A
```
