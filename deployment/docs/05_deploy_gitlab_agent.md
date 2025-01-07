## Deploy gitlab agent

![alt text](../images/gitlab-agent-0.png)

![alt text](../images/gitlab-agent-1.png)

![alt text](../images/gitlab-agent-2.png)

![alt text](../images/gitlab-agent-3.png)

```bash
kubectl get po -n gitlab-agent-wol-agent
```
Output: 

```
NAME                                         READY   STATUS    RESTARTS   AGE
wol-agent-gitlab-agent-v2-549c55c844-l2h2v   1/1     Running   0          2m20s
wol-agent-gitlab-agent-v2-549c55c844-rgwcm   1/1     Running   0          2m20s
```

