#!/bin/bash
sleep 60
# 1. توجيه المخرجات للوج والوقوف عند أي خطأ
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -e  # السكريبت هيقف فوراً لو سطر فشل
# 1. تهيئة النظام
modprobe overlay
modprobe br_netfilter
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system

# 2. تثبيت Containerd
apt-get update -y
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sed -i 's/^disabled_plugins.*/disabled_plugins = []/' /etc/containerd/config.toml
systemctl restart containerd
apt-get update
#Install packages needed to use the Kubernetes apt repository:
apt-get install -y apt-transport-https ca-certificates curl gpg
#Download the public signing key for the Kubernetes package repositories.
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
#Add Kubernetes Repository:
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
#Update your existing packages:
apt-get update -y
#Install Kubeadm:
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
#Enable the kubelet service:
systemctl enable --now kubelet
#Enable the kubelet service:
systemctl enable --now kubelet
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
systemctl enable --now kubelet