#!/bin/bash

# Enable IPv4 packet forwarding
echo "Enabling IPv4 packet forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

# Persist the packet forwarding setting across reboots
sudo sh -c "echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf"

# Apply the changes
sudo sysctl -p

# Install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# Create keyring directory for Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update apt package index
sudo apt-get update

# Install containerd.io package from Docker repo
sudo apt-get install -y containerd.io

# Overwrite the content of the config.toml file with required configuration
sudo tee /etc/containerd/config.toml > /dev/null <<EOF
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF

# Restart containerd to apply changes
sudo systemctl restart containerd

# Enable and start containerd
sudo systemctl enable containerd

# Add Kubernetes package repositories and GPG key for Kubernetes v1.31
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index and install Kubernetes packages
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

# # Enable and start kubelet service
# sudo systemctl enable --now kubelet
