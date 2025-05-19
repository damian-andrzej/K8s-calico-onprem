#!/bin/bash

# ====== Shared Setup for ALL Nodes ======

echo "[1/9] Configuring network interface ens33..."

cat <<EOF | sudo tee /etc/systemd/network/10-ens33.network
[Match]
Name=ens33

[Network]
DHCP=yes
EOF

sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd

echo "[2/9] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "[3/9] Installing kubeadm, kubelet, kubectl..."
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[4/9] System setup complete. Please continue based on the node type (master or worker)."

# ====== Master Node Specific ======

if [[ "$1" == "master" ]]; then
  echo "[5/9] Initializing Kubernetes Master Node..."
  sudo kubeadm init --pod-network-cidr=192.168.0.0/16

  echo "[6/9] Setting up kubectl for the master user..."
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  echo "[7/9] Installing Calico networking..."
  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

  echo "[8/9] Kubernetes master initialized. Use the following to join workers:"
  kubeadm token create --print-join-command

# ====== Worker Node Specific ======

elif [[ "$1" == "worker" ]]; then
  echo "[5/9] Please enter the kubeadm join command you got from the master node:"
  read -rp "kubeadm join command: " JOIN_CMD
  echo "[6/9] Joining the cluster..."
  sudo $JOIN_CMD

else
  echo "[!] Please specify 'master' or 'worker' as the first argument."
  echo "Example: sudo bash k8s-cluster-setup.sh master"
  echo "         sudo bash k8s-cluster-setup.sh worker"
fi
