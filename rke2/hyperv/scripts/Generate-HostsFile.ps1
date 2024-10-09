# Define the VM names (replace these with your actual VM names)
$vmNames = @("master1", "master2", "master3", "worker1", "worker2","worker3", "loadbalancer")

# Define the output file
$outputFile = "hosts.txt"

# Clear the content of the file if it exists, or create a new one
if (Test-Path $outputFile) {
    Clear-Content $outputFile
} else {
    New-Item $outputFile -ItemType File
}

# Loop through each VM to get its IP address and write to the file
foreach ($vm in $vmNames) {
    # Get the IP address using Vagrant
    $ip = vagrant ssh $vm -c "hostname -I" | ForEach-Object { $_.Split(" ")[0] }
    
    # Format the output as "IP VM_Name"
    $line = "$ip $vm"
    
    # Write the formatted line to the file
    Add-Content -Path $outputFile -Value $line
    
    # Display the VM name and its corresponding IP address
    Write-Host "$line written to $outputFile"
}