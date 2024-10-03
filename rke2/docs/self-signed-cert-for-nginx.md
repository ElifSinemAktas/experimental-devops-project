#### Generate Self-Signed SSL Certificate

Create a directory to store the SSL certificate and private key.

```bash
sudo mkdir -p /etc/nginx/ssl
```
Run the following command to generate a self-signed SSL certificate and private key using OpenSSL. You will be prompted to enter information for the certificate.

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx-selfsigned.key \
-out /etc/nginx/ssl/nginx-selfsigned.crt
```

```
-x509: This option generates a self-signed certificate.
-nodes: This option means the private key should not be password protected.
-days 365: Specifies the validity of the certificate (in days).
-newkey rsa:2048: This option generates a new 2048-bit RSA key.
-keyout: Specifies where the private key will be saved.
-out: Specifies where the self-signed certificate will be saved.
```

Here’s an example of the information you will need to provide:

```
Country Name (2 letter code) [AU]:TR
State or Province Name (full name) [Some-State]:ANKARA
Locality Name (eg, city) []:ANKARA
Organization Name (eg, company) [Internet Widgits Pty Ltd]:AKTAS
Organizational Unit Name (eg, section) []:DEVOPS
Common Name (e.g. server FQDN or YOUR name) []:loadbalancer
Email Address []
```

We'll use this cert/key location in configuration of nginx

```
vagrant@loadbalancer:~$ ls /etc/nginx/ssl/
nginx-selfsigned.crt  nginx-selfsigned.key
```