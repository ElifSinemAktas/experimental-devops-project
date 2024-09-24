#!/bin/bash

IP_NW=$1
NUM_WORKER_NODES=$2
MASTER_IP_START=$3
NODE_IP_START=$4
MONITOR_IP_START=$5
LOAD_BALANCER_IP_START=$6

# Add the control plane, worker nodes, monitoring, and load balancer entries to /etc/hosts
cat <<EOF >> /etc/hosts
$IP_NW.$MASTER_IP_START controlplane
$IP_NW.$MONITOR_IP_START monitoring
$IP_NW.$LOAD_BALANCER_IP_START loadbalancer
EOF

for i in $(seq 1 $NUM_WORKER_NODES); do
  NODE_IP=$(($NODE_IP_START + $i))
  echo "$IP_NW.$NODE_IP node0$i" >> /etc/hosts
done