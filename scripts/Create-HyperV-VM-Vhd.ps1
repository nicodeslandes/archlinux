param(
    [Parameter(Mandatory = $true)]
    [string]$Name)

$ErrorActionPreference = "Stop"

Write-Host -ForegroundColor Green Creating VHD for VM $Name

# Create VHD with 1MB Block Size
$VhdFolder = 'C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks'
$Vhd = "$VhdFolder\$Name.vhdx"

if (Test-Path $Vhd) { throw "VHD File $vhd already exists" }

Write-Host -ForegroundColor Cyan Creating VHD $Vhd
New-VHD -Path $vhd -SizeBytes 10GB -Dynamic -BlockSizeBytes 1MB | Out-Null

Write-Host -ForegroundColor Green VHD successfully created at $vhd !