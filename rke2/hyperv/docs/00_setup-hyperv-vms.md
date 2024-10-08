## Set-Up Hyper-V VM's

- Set up Virtual Switch

    ![alt text](./images/image.png)

    ![alt text](./images/image-8.png)


> [!NOTE]
> While using Hyper-v with Vagrant, you need admin priviliges, run powershell as administrator and go to the file Vagrantfile location in the powershell.

![alt text](image-1.png)

- Bring up machines.

    ```
    vagrant up 
    ```

> [!NOTE]
> Vagrant will ask you which virtual switch to use. You can avoid it adding network setting for switch **"config.vm.network "public_network", bridge: "kubernetes"** into Vagrantfile.

> [!NOTE]
> Vagrant has limitations for networking settings in Hyper-v (Please see [Vagrant official document](https://developer.hashicorp.com/vagrant/docs/providers/hyperv/limitations)). 

> [!NOTE]
> We need static ip for our nodes, you can use DHCP reservation. Do do that, you need current MAC address and IP of VM.  

![alt text](image_mac.png)

> Setting address reservation is similar on each modem/router. See the example below.

![alt text](image.png)

> [!NOTE]
> I have router in my location and machines getting ip from this router. The range is 192.168.68.0/22. You'll see different IP range in my case.