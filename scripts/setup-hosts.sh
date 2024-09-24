#!/usr/bin/env bash

# Set up /etc/hosts so we can resolve all the nodes
set -e

# Arguments passed from Vagrantfile
IP_NW=$1  # Network prefix (e.g., 192.168.1)
NUM_WORKER_NODES=$2
MASTER_IP_START=$3
NODE_IP_START=$4
MONITOR_IP_START=$5
LOAD_BALANCER_IP_START=$6

# Remove unwanted entries (cleans up default hostname entries)
sed -e '/^.*ubuntu-jammy.*/d' -i /etc/hosts
sed -e "/^.*${HOSTNAME}.*/d" -i /etc/hosts

# Update /etc/hosts about control plane, worker nodes, monitoring, and load balancer
echo "${IP_NW}.${MASTER_IP_START} controlplane" >> /etc/hosts
echo "${IP_NW}.${MONITOR_IP_START} monitoring" >> /etc/hosts
echo "${IP_NW}.${LOAD_BALANCER_IP_START} loadbalancer" >> /etc/hosts

# Loop to add worker nodes
for i in $(seq 1 $NUM_WORKER_NODES); do
    num=$(($NODE_IP_START + $i - 1))  # Adjusts IPs to start from NODE_IP_START
    echo "${IP_NW}.${num} node0${i}" >> /etc/hosts
done
