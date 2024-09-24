# Define the number of worker nodes
NUM_WORKER_NODES = 2

# Network parameters for BRIDGE mode (Static IPs)
IP_NW = "192.168.1"  # This will need to match your local network
MASTER_IP_START = 11
NODE_IP_START = 20
MONITOR_IP_START = 30
LOAD_BALANCER_IP_START = 40

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
    s.args = [NUM_WORKER_NODES, MASTER_IP_START, NODE_IP_START, MONITOR_IP_START, LOAD_BALANCER_IP_START]
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

  # Provision Control Plane Node
  config.vm.define "controlplane" do |node|
    node.vm.provider "virtualbox" do |vb|
      vb.name = "controlplane"
      vb.memory = 4096
      vb.cpus = 2
    end
    node.vm.hostname = "controlplane"
    node.vm.network :public_network, ip: "#{IP_NW}.#{MASTER_IP_START}", bridge: get_bridge_adapter()
    provision_kubernetes_node node
  end

  # Provision Worker Nodes
  (1..NUM_WORKER_NODES).each do |i|
    config.vm.define "node0#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "node0#{i}"
        vb.memory = 2048
        vb.cpus = 2
      end
      node.vm.hostname = "node0#{i}"
      node.vm.network :public_network, ip: "#{IP_NW}.#{NODE_IP_START + i - 1}", bridge: get_bridge_adapter()
      provision_kubernetes_node node
    end
  end

  # Provision Monitoring Node
  config.vm.define "monitoring" do |node|
    node.vm.provider "virtualbox" do |vb|
      vb.name = "monitoring"
      vb.memory = 2048
      vb.cpus = 2
    end
    node.vm.hostname = "monitoring"
    node.vm.network :public_network, ip: "#{IP_NW}.#{MONITOR_IP_START}", bridge: get_bridge_adapter()
    setup_dns node
  end

  # Provision Load Balancer Node
  config.vm.define "loadbalancer" do |node|
    node.vm.provider "virtualbox" do |vb|
      vb.name = "loadbalancer"
      vb.memory = 2048
      vb.cpus = 2
    end
    node.vm.hostname = "loadbalancer"
    node.vm.network :public_network, ip: "#{IP_NW}.#{LOAD_BALANCER_IP_START}", bridge: get_bridge_adapter()
    setup_dns node
  end
end
