#!/usr/bin/env bash

# Set up /etc/hosts so we can resolve all the nodes
set -e

# Arguments passed from Vagrantfile
IP_NW=$1  # Network prefix (e.g., 192.168.1)
MASTER_IP_START=$2
NODE_IP_START=$3
LOAD_BALANCER_IP_START=$4

# Remove unwanted entries (cleans up default hostname entries)
sed -e '/^.*ubuntu-jammy.*/d' -i /etc/hosts
sed -e "/^.*${HOSTNAME}.*/d" -i /etc/hosts

# Loop to add control plane nodes (assumes 2 control plane nodes)
for i in $(seq 1 2); do
    num=$(($MASTER_IP_START + $i - 1))  # Adjusts IPs for control plane nodes
    if ! grep -q "controlplane0${i}" /etc/hosts; then  # Avoid duplicating entries
        echo "${IP_NW}.${num} controlplane0${i}" >> /etc/hosts
    fi
done

# Add load balancer entry if it doesn't already exist
if ! grep -q "loadbalancer" /etc/hosts; then
    echo "${IP_NW}.${LOAD_BALANCER_IP_START} loadbalancer" >> /etc/hosts
fi

# Loop to add 2 worker nodes
for i in $(seq 1 2); do
    num=$(($NODE_IP_START + $i - 1))  # Adjusts IPs to start from NODE_IP_START
    if ! grep -q "worker0${i}" /etc/hosts; then  # Avoid duplicating entries
        echo "${IP_NW}.${num} worker0${i}" >> /etc/hosts
    fi
done

# Set Google's DNS server (8.8.8.8) in /etc/systemd/resolved.conf
sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf

# Restart the systemd-resolved service to apply changes
service systemd-resolved restart

# Install socat
sudo apt-get update
sudo apt-get install -y socat

# Check internet connectivity
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo "Internet connectivity is working."
else
    echo "No internet connectivity detected. Please check your network configuration."
fi
