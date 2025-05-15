1. VMs 1 for cluster 2 for workernodes
    Network interfaces in NAT mode
    we need to ensure ens33 interface gets NAT IP every time
    ad1. create a file /etc/systemd/networkd/10-ens33.network where ens33 is your int name
    ad2. enable networkd during boot - systemctl enable systemd-networkd
   
3. Install kubeadm on master node
4. init a cluster
5. join worker nodes to cluster
6. validate
7. install argocd
