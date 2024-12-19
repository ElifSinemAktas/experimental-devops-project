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

Create helm chart

```bash
helm create user-service
```

Perform basic necessary changes (Take a look helm chart [in this directory](../../development/wol-user-service/helm-chart/)). You can always overwrite by using values.yaml.
- Image name is changed
- secret.yaml is added
- secrets field is added to values.yaml
- envs are added to deployment.yaml

Check if there is a problem in the chart (run the command in the helm directory)
```bash
helm lint
```

Provide release name and envs (wol-user-service) and install
```bash
helm install wol-user-service . -n works-on-local --set secrets.DATABASE_URL=postgresql://user_service_user:user_service_pass@db-0-postgresql.shared-services.svc.cluster.local:5432/user_service_db --set secrets.SECRET_KEY=PshDMr4yrwXgCTmMpjIO1_Ll3LrDeKWvIaUntACc0Bc --set secrets.ALGORITHM=HS256 --set secrets.ACCESS_TOKEN_EXPIRE_MINUTES=30
```

If you get error, uninstall, fix and install again

```bash
helm uninstall wol-user-service -n works-on-local 
```

### Temporary port-forwarding to test

Get the pod name 
```bash
kubectl get po -n works-on-local
```

Run the command below (change pod name in the command)
```bash
kubectl port-forward pod/wol-user-service-7669dd957d-cw7n9 8000:8000 -n works-on-local
```
