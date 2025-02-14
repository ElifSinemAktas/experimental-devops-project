## Deploy Longhorn with helm

Most Kubernetes clusters rely on a storage provisioner (e.g., for local disks, cloud provider volumes, or external storage systems) to dynamically allocate Persistent Volumes (PVs) for Persistent Volume Claims (PVCs). In documentation they describe: 

```
Longhorn is a lightweight, reliable and easy-to-use distributed block storage system for Kubernetes.

Longhorn is free, open source software. Originally developed by Rancher Labs, it is now being developed as a incubating project of the Cloud Native Computing Foundation.

With Longhorn, you can:

- Use Longhorn volumes as persistent storage for the distributed stateful applications in your Kubernetes cluster
- Partition your block storage into Longhorn volumes so that you can use Kubernetes volumes with or without a cloud provider
- Replicate block storage across multiple nodes and data centers to increase availability
- Store backup data in external storage such as NFS or AWS S3
- Create cross-cluster disaster recovery volumes so that data from a primary Kubernetes cluster can be quickly recovered from backup in a second Kubernetes cluster
- Schedule recurring snapshots of a volume, and schedule recurring backups to NFS or S3-compatible secondary storage
- Restore volumes from backup
- Upgrade Longhorn without disrupting persistent volumes
```

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
