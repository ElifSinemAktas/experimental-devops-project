import subprocess

# Define the VM names (replace these with your actual VM names)
vm_names = ["master1", "master2", "master3", "worker1", "worker2", "worker3", "loadbalancer"]

# Define the output file
output_file = "hosts.txt"

# Clear the content of the file if it exists, or create a new one
with open(output_file, 'w') as f:
    pass  # This will create the file or clear its content if it exists

# Function to get the IP address of a VM
def get_ip(vm_name):
    try:
        result = subprocess.run(
            ["vagrant", "ssh", vm_name, "-c", "hostname -I"],
            capture_output=True, text=True, check=True
        )
        # Extract the first IP address
        ip = result.stdout.split()[0]
        return ip
    except subprocess.CalledProcessError as e:
        print(f"Error retrieving IP for {vm_name}: {e}")
        return None

# Loop through each VM to get its IP address and write to the file
with open(output_file, 'a') as f:
    for vm in vm_names:
        ip = get_ip(vm)
        if ip:
            line = f"{ip} {vm}"
            f.write(line + "\n")
            print(f"{line} written to {output_file}")