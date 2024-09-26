# Network parameters for BRIDGE mode (Static IPs)
IP_NW = "192.168.56"  # This will need to match your local network
MASTER_IP_START = 10
NODE_IP_START = 20
LOAD_BALANCER_IP_START = 30

# Host operating system detection
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

# Determine host adapter for bridging in BRIDGE mode
def get_bridge_adapter()
  if OS.windows?
    # For Windows, use PowerShell to find the default network adapter
    return %x{powershell -Command "Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Get-NetAdapter | Select-Object -ExpandProperty InterfaceDescription"}.chomp
  elsif OS.linux?
    # For Linux, use ip route command to get the default network interface
    return %x{ip route | grep default | awk '{ print $5 }'}.chomp
  elsif OS.mac?
    # For macOS, use networksetup to find the active network adapter (Wi-Fi or Ethernet)
    return %x{networksetup -listallhardwareports | awk '/Wi-Fi|Ethernet/{getline; print $2}'}.chomp
  end
end

# Sets up hosts file and DNS
def setup_dns(node)
  node.vm.provision "setup-hosts", :type => "shell", :path => "scripts/setup-hosts.sh", run: "always" do |s|
    # Pass the network prefix (IP_NW) and other parameters to the setup-hosts.sh script
    s.args = [IP_NW, MASTER_IP_START, NODE_IP_START, LOAD_BALANCER_IP_START]
  end
end

# Runs provisioning steps that are required by control plane and worker nodes
def provision_kubernetes_node(node)
  setup_dns node
  node.vm.provision "setup-ssh", :type => "shell", :path => "scripts/setup-ssh.sh"
  node.vm.provision "install-k8s", :type => "shell", :path => "scripts/install-k8s.sh"
end

# Vagrant configuration
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 900
  config.vm.box_check_update = false

  # Provision Control Plane Nodes
  (1..2).each do |i|
    config.vm.define "controlplane0#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "controlplane0#{i}"
        vb.memory = 2048    # 2 GB RAM
        vb.cpus = 2         # 2 CPU for both control planes
      end
      node.vm.hostname = "controlplane0#{i}"
      node.vm.network :public_network, ip: "#{IP_NW}.#{MASTER_IP_START + i - 1}", bridge: get_bridge_adapter()
      provision_kubernetes_node node
    end
  end

  # Provision 2 Worker Nodes
  (1..2).each do |i|
    config.vm.define "worker0#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "worker0#{i}"
        vb.memory = 3072  # 3 GB RAM for worker nodes to handle apps and monitoring
        vb.cpus = 2       # 2 CPUs for worker nodes
      end
      node.vm.hostname = "worker0#{i}"
      node.vm.network :public_network, ip: "#{IP_NW}.#{NODE_IP_START + i - 1}", bridge: get_bridge_adapter()
      provision_kubernetes_node node
    end
  end

  # Provision Load Balancer Node
  config.vm.define "loadbalancer" do |node|
    node.vm.provider "virtualbox" do |vb|
      vb.name = "loadbalancer"
      vb.memory = 1024  # 1 GB RAM for load balancer
      vb.cpus = 1       # 1 CPU for load balancer
    end
    node.vm.hostname = "loadbalancer"
    node.vm.network :public_network, ip: "#{IP_NW}.#{LOAD_BALANCER_IP_START}", bridge: get_bridge_adapter()
    setup_dns node
  end
end
