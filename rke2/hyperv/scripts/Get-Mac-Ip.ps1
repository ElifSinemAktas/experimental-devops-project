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
    Write-Host "Fetching MAC and IP for $vm..."

    # Get the IP address using Vagrant
    $ip = vagrant ssh $vm -c "hostname -I" | ForEach-Object { $_.Split(" ")[0] }

    # Initialize a variable to store the MAC address
    $macAddress = $null

    # Get the MAC address using Vagrant
    vagrant ssh $vm -c "ip link show eth0" | ForEach-Object {
        if ($_ -match 'ether ([0-9a-f:]{17})') {
            $macAddress = $matches[1]
        }
    }

    # If no MAC address was found, provide feedback
    if (-not $macAddress) {
        Write-Host "No MAC address found for $vm"
    }

    # If MAC address or IP is null, skip writing to the file
    if (-not $macAddress -or -not $ip) {
        Write-Host "Skipping $vm due to missing MAC or IP address."
        continue
    }

    # Format the output as "MAC IP VM_Name"
    $line = "$macAddress $ip $vm"

    # Write the formatted line to the new file mac_ip_vm.txt
    Add-Content -Path $outputFile -Value $line
}

Write-Host "MAC and IP address information has been saved to $outputFile."