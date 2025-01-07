## Deploy Postgresql with Helm

Add bitnami helm repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Check if repo is added 

```bash
helm repo list
```

Output:
```
NAME    URL
bitnami https://charts.bitnami.com/bitnami
```

You can see the bitnami helm repo
```bash
helm search repo bitnami
```

Output:
```
.....
bitnami/phpbb                                   19.0.4          3.3.12          DEPRECATED phpBB is a popular bulletin board th...
bitnami/phpmyadmin                              18.0.0          5.2.1           phpMyAdmin is a free software tool written in P...
bitnami/pinniped                                2.3.5           0.35.0          Pinniped is an identity service provider for Ku...
bitnami/postgresql                              16.2.2          17.2.0          PostgreSQL (Postgres) is an open source object-...
bitnami/postgresql-ha                           15.0.1          17.2.0          This PostgreSQL cluster solution includes the P...
....
```

Update repo if necessary
```bash
helm repo update
```

## Create Test Postgresql Instance

```bash
kubectl create namespace wol-test
```

Create configmap to pass script while installing. (Secret would be secure!)

```bash
kubectl create configmap psql-test-init `
  --namespace wol-test `
  --from-file=scripts/psql_test_init.sql
```

```shell
helm install test-db bitnami/postgresql `
  --namespace wol-test `
  --set auth.postgresPassword=pass `
  --set primary.persistence.size=1Gi `
  --set primary.resources.requests.cpu=100m `
  --set primary.resources.requests.memory=256Mi `
  --set primary.resources.limits.cpu=500m `
  --set primary.resources.limits.memory=512Mi `
  --set primary.initdb.scriptsConfigMap=psql-test-init
```

```bash
kubectl get po -n wol-test
```

Output:
```
NAME                   READY   STATUS    RESTARTS   AGE
test-db-postgresql-0   1/1     Running   0          62s
```

## Create Prod Postgresql Instance

```bash
kubectl create namespace wol-prod
```

```bash
kubectl create configmap psql-prod-init `
  --namespace wol-prod `
  --from-file=scripts/psql_prod_init.sql
```

```shell
helm install prod-db bitnami/postgresql `
  --namespace wol-prod `
  --set auth.postgresPassword=pass `
  --set primary.persistence.size=1Gi `
  --set primary.resources.requests.cpu=100m `
  --set primary.resources.requests.memory=256Mi `
  --set primary.resources.limits.cpu=500m `
  --set primary.resources.limits.memory=512Mi `
  --set primary.initdb.scriptsConfigMap=psql-prod-init
```

```bash
kubectl get po -n wol-prod
```

Output:
```
NAME                   READY   STATUS    RESTARTS   AGE
prod-db-postgresql-0   1/1     Running   0          26s
```

## Port Forwarding to Test

If you want to connect via SQL Editor (Dbeaver etc), perform port-forwarding

```bash
kubectl port-forward test-db-postgresql-0 5432:5432 -n wol-test
```

```bash
kubectl port-forward prod-db-postgresql-0 5432:5432 -n wol-prod
```
Then you can reach from "localhost:5342"


## Getting hostname and creating connection string

You're going to need hostname of postgresql instance within the cluster. 

Check service name first:

```bash
kubectl get svc -n wol-test
```
```
NAME                    TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE
test-db-postgresql      ClusterIP   10.43.96.34   <none>        5432/TCP   2d21h
```

Hostname will be: **<service-name>.<namespace>.svc.cluster.local**

```
test-db-postgresql.wol-test.svc.cluster.local
```

Connection string: **postgresql://<user-name>:<user-password>@<hostname>:<port>/<database>**

Same for prod instance...