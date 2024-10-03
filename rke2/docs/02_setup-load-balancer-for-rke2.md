
##  Setup Loadbalancer

Now that you're moving forward with setting up the NGINX load balancer.

#### SSH into your load balancer VM and install NGINX.

```bash
vagrant ssh loadbalancer
```

```bash
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
```

```bash
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
|       sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```

```bash
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
```

To set up the apt repository for stable nginx packages, run the following command

```bash
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```

Set up repository pinning to prefer our packages over distribution-provided ones

```bash
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
| sudo tee /etc/apt/preferences.d/99nginx
```

Install NGINX Open Source

```bash
sudo apt update
sudo apt install nginx
```
```bash
sudo nginx
```

#### Verify stream module

```bash
nginx -V 2>&1 | grep -o with-stream
```

If the output includes with-stream, then the module is available.

#### Configure NGINX as a Load Balancer**

Edit the NGINX configuration to route traffic to your master nodes.

```
cat <<EOF | sudo tee /etc/nginx/nginx.conf
# Number of CPU cores
worker_processes 2;

# Maximum number of open file descriptors
worker_rlimit_nofile 10240;

# Maximum number of connections per worker
events {
    worker_connections 2048;
}

stream {
    # Layer 4 (TCP) load balancing for Kubernetes API (port 6443)
    upstream rke2_api {
        least_conn;
        server master1:6443 max_fails=3 fail_timeout=5s;
        server master2:6443 max_fails=3 fail_timeout=5s;
        server master3:6443 max_fails=3 fail_timeout=5s;
    }

    server {
        listen 6443;
        proxy_pass rke2_api;
    }

    # Layer 4 (TCP) load balancing for RKE2 Supervisor (port 9345)
    upstream rke2_supervisor {
        least_conn;
        server master1:9345 max_fails=3 fail_timeout=5s;
        server master2:9345 max_fails=3 fail_timeout=5s;
        server master3:9345 max_fails=3 fail_timeout=5s;
    }

    server {
        listen 9345;
        proxy_pass rke2_supervisor;
    }
}
EOF
```

> [!NOTE]
> If you have problem with the code above, please use vi or nano to copy/paste the content of configuration.

Save the configuration and exit.


#### Test, Restart and Control NGINX

Check for any syntax errors and restart NGINX to apply the configuration.

```bash
sudo nginx -t
```

Restart nginx
```bash
sudo systemctl restart nginx
```

Check status
```bash
sudo systemctl status nginx
```