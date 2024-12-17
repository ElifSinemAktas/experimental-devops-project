## Test Images and Helm Manually

Login docker (if you're not logged in)

```bash
docker login
```

Create image and push to dockerhub

```bash
docker build -t docker.io/<your-docker-username>/wol-user-service:0.1.0 .
```

```bash
docker push docker.io/<your-docker-username>/wol-user-service:0.1.0 .
```

Create namespace

```bash
kubectl create namespace works-on-local
```

```bash
kubectl get ns
```

Output:
```
NAME              STATUS   AGE
default           Active   62d
kube-node-lease   Active   62d
kube-public       Active   62d
kube-system       Active   62d
longhorn-system   Active   18d
shared-services   Active   18d
works-on-local    Active   6s
```

Take a look helm chart [in this directory](../../development/wol-user-service/helm-chart/).

```bash
helm create user-service
```

Perform basic necessary changes (Take a look helm chart [in this directory](../../development/wol-user-service/helm-chart/)). You can always overwrite by using values.yaml.
- Image name is changed
- secret.yaml is added
- secrets field is added to values.


Provide release name (wol-user-service) and install
```bash
helm install wol-user-service . -n works-on-local --set secrets.DATABASE_URL='postgresql://user:password@host:port/dbname'
```

If you get error, uninstall, fix and install again

```bash
helm uninstall wol-user-service -n works-on-local 
```
