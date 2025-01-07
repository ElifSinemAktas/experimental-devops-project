### Check all running pods
```bash
kubectl get pods --all-namespaces --field-selector metadata.namespace!=kube-system,metadata.namespace!=longhorn-system -o custom-columns="POD:metadata.name,NODE:spec.nodeName,STATUS:status.phase"
```

### Check Spesific node

```bash
kubectl get pods --all-namespaces --field-selector spec.nodeName=worker1 -o wide
```

### Check Resources 

```bash
kubectl top nodes
```

```bash
kubectl top pods -A
```