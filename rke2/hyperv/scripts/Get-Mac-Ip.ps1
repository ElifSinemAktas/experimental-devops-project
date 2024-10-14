# Define the VM names (replace these with your actual VM names)
$vmNames = @("master1", "master2", "master3", "worker1", "worker2", "worker3", "loadbalancer")

# Define the output file
$outputFile = "mac_ip_vm.txt"

# Clear the content of the file if it exists, or create a new one
if (Test-Path $outputFile) {
    Clear-Content $outputFile
} else {
    New-Item $outputFile -ItemType File
}

# Loop through each VM to get its IP address, MAC address, and write to the file
foreach ($vm in $vmNames) {
    # Get the IP address using Vagrant
    $ip = vagrant ssh $vm -c "hostname -I" | ForEach-Object { $_.Split(" ")[0] }
    
    # Get the MAC address using Vagrant (or you can fetch it from the host machine)
    $macAddress = vagrant ssh $vm -c "ip link show eth0" | ForEach-Object { $_ -match 'ether ([0-9a-f:]{17})'; $matches[1] }

    # Format the output as "MAC IP VM_Name"
    $line = "$macAddress $ip $vm"
    
    # Write the formatted line to the new file mac_ip_vm.txt
    Add-Content -Path $outputFile -Value $line
}