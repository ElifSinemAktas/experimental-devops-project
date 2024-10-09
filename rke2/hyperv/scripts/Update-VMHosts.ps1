# Define the VM names (replace these with your actual VM names)
$vmNames = @("master1", "master2", "master3", "worker1", "worker2", "worker3", "loadbalancer")

# Path to the hosts.txt file that contains the IPs and VM names
$hostsFile = "hosts.txt"

# Read the contents of the hosts.txt file
$hostsContent = Get-Content -Path $hostsFile

# Loop through each VM
foreach ($vm in $vmNames) {
    Write-Host "Updating /etc/hosts on $vm..."

    # Fetch the current IP and hostname of the VM
    $currentIp = vagrant ssh $vm -c "hostname -I" | ForEach-Object { $_.Split(" ")[0] }
    $currentHostname = $vm

    # Filter out the current machine's IP/hostname from hosts.txt content
    $filteredContent = $hostsContent | Where-Object { $_ -notmatch "$currentIp" -and $_ -notmatch "$currentHostname" }

    # If there's any content left after filtering, append it to the /etc/hosts file
    if ($filteredContent) {
        $filteredContentString = $filteredContent -join "`n"
        vagrant ssh $vm -c "echo '$filteredContentString' | sudo tee -a /etc/hosts > /dev/null"
        Write-Host "Updated /etc/hosts on $vm without its own entry."
    } else {
        Write-Host "No new entries to add to $vm."
    }
}