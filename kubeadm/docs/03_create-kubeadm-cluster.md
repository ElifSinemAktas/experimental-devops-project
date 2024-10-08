## Create highly available kubeadm cluster

- SSH to controlplane01

```bash
vagrant ssh controlplane01
```

- Init kubeadm cluster

```bash
sudo kubeadm init --control-plane-endpoint="192.168.68.50:6443" \
                  --pod-network-cidr=10.32.0.0/12 \
                  --apiserver-advertise-address=192.168.68.100 \
                  --upload-certs \
                  --v=5
```


```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```


## Troubleshooting

- Run kubeadm reset: This cleans up the previous Kubernetes configuration and resets the cluster

```bash
sudo kubeadm reset
```

- Reinitialize the Cluster with kubeadm init

