## Check VM setup

Once your virtual machines (VMs) are up and running, it’s important to verify that everything is configured correctly and the environment is functioning as expected. 

#### Verifying SSH Access

Ensure you can establish an SSH connection to all VMs, including control planes, workers, and the load balancer. This confirms that the VMs are properly initialized, and networking (including SSH) is configured.

```bash
vagrant ssh master1
vagrant ssh master2
vagrant ssh worker1
...
```

#### Checking Network Connectivity Between VMs

It's crucial that all VMs in the cluster can communicate with each other. Ping each VM by its hostname (configured in /etc/hosts or through DNS resolution) to verify that network connectivity is correctly set up.

```bash
ping master1
ping worker2
ping loadbalancer
...
```


#### Verifying Internet Access

To ensure the VMs have proper internet connectivity, test by pinging an external domain like Google. This step verifies that your VMs can access external resources, which is essential for downloading packages, container images, etc.

```bash
ping google.com
```

#### Checking Firewall Configuration (UFW Disabled)

Ensure that the firewall (UFW) is disabled on each VM. Firewalls can interfere with network communication between VMs and with external services. If UFW is enabled, it might block traffic between your nodes or to external resources.

```bash
sudo ufw status
```

#### Ensuring Swap is Disabled (Swap Disabled)

Kubernetes nodes require swap to be disabled for optimal performance and stability. This step ensures that swap is turned off on all VMs. Having swap enabled could cause Kubernetes nodes to fail to start, or other unexpected issues.

```bash
swapon --show
```