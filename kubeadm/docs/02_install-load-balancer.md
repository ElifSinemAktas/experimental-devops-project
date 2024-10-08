## Install Load Balancer

- SSH to loadbalancer VM

```bash
vagrant ssh loadbalancer
```

- Install HAProxy on your Load Balancer VM
You can SSH into your load balancer VM and install HAProxy using the following commands:

```bash
sudo apt-get update
sudo apt-get install haproxy -y
```

- Configure HAProxy
Edit the HAProxy configuration file to set up load balancing for your Kubernetes API servers:

```bash
cat <<EOF | sudo tee /etc/haproxy/haproxy.cfg
frontend kubernetes
    bind 192.168.68.50:6443
    option tcplog
    mode tcp
    default_backend kubernetes-controlplane-nodes

backend kubernetes-controlplane-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server controlplane01 192.168.68.100:6443 check fall 3 rise 2
    server controlplane02 192.168.68.101:6443 check fall 3 rise 2
EOF

```

In this configuration:

- frontend k8s-api: HAProxy listens on port 6443, which is the Kubernetes API server port.
- backend k8s-masters: This section defines the control plane nodes (controlplane01, controlplane02) and their IP addresses. HAProxy will balance traffic between these servers.

- Restart HAProxy
After modifying the configuration, restart HAProxy to apply the changes:

```bash
sudo systemctl restart haproxy
```

- Test the Setup
To verify that HAProxy is correctly balancing the traffic, you can run the following command **from your worker nodes** or any machine that has access to the load balancer:

```bash
curl -k https://192.168.56.30:6443/healthz
```

- See haproxy documentation for more settings

https://github.com/kubernetes/kubeadm/blob/main/docs/ha-considerations.md#options-for-software-load-balancing