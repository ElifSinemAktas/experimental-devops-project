## Check VM setup

Once your VMs are up and running, follow these steps to verify everything is working as expected.

#### SSH Access

Ensure you can SSH into all VMs (control planes, workers, and load balancer)

```bash
vagrant ssh master1
vagrant ssh master2
vagrant ssh worker1
...
```

#### Network Connectivity

Check that all VMs can communicate with each other by their hostnames (configured via /etc/hosts). From any control plane or worker, ping the other nodes by their hostnames

```bash
ping master1
ping worker2
ping loadbalancer
```


#### Internet Access

Ensure that each VM has internet connectivity through Google DNS.

```bash
ping google.com
```

#### Firewall Configuration (UFW Disabled)

```bash
sudo ufw status
```

