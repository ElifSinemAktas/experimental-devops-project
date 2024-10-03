To set up key-based SSH access

Generate an SSH key pair

```bash
ssh-keygen -t rsa 
```
Copy the public key to each master and worker node

```bash
ssh-copy-id master1
ssh-copy-id master2
```

Test SSH access 

```bash
ssh master1
```
