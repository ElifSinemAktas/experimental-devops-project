## Deploy Longhorn with helm

Most Kubernetes clusters rely on a storage provisioner (e.g., for local disks, cloud provider volumes, or external storage systems) to dynamically allocate Persistent Volumes (PVs) for Persistent Volume Claims (PVCs).


Run this command to install Longhorn (a dynamic storage provisioner) in your cluster.

Add longhorn repo

```bash
helm repo add longhorn https://charts.longhorn.io
```

Create namespace
```bash
kubectl create namespace longhorn-system
```

Install longhorn
```bash
helm install longhorn longhorn/longhorn --namespace longhorn-system
```