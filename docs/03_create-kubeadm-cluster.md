## Create highly available kubeadm cluster

- SSH to controlplane01

```bash
vagrant ssh controlplane01
```

- Init kubeadm cluster

```bash
sudo kubeadm init --control-plane-endpoint "192.168.56.40:6443" --apiserver-advertise-address "192.168.56.11" --pod-network-cidr=10.244.0.0/16 --upload-certs
```

## Troubleshooting

- Run kubeadm reset: This cleans up the previous Kubernetes configuration and resets the cluster:

```bash

sudo kubeadm reset
```
- Remove CNI Configuration: Clean up the CNI networking configuration:

```bash
sudo rm -rf /etc/cni/net.d
```
- Clear iptables: Reset the iptables rules to avoid networking issues:

```bash
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X
```

- Clean Up kubeconfig Files: Remove any leftover kubeconfig files from your home directory:

```bash
sudo rm -rf $HOME/.kube
```
This ensures that there are no old kubeconfig files interfering with the new cluster configuration.

- Reinitialize the Cluster with kubeadm init

