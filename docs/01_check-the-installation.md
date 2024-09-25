## Check the installation

- Connect vm

```bash
vagrant ssh <vm-name> #(controlplane, node01 etc.)
```

- Control containerd
```bash
sudo systemctl status containerd
```

- Control kubeadm 
```bash
kubeadm version
```

- Control kubectl
```bash
kubectl version --client
```

- Control kubelet
```bash
kubelet --version
```

- Control ip. Under the enp0s8 you'll see defined ip in configuration.

```bash
ip a
```

- Control hosts

```bash
cat /etc/hosts
```

Output  includes the entries below:

```
192.168.56.10 controlplane01
192.168.56.11 controlplane02
192.168.56.30 loadbalancer
192.168.56.20 worker01
192.168.56.21 worker02
```