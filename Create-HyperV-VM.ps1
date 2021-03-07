param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [string]$VmSwitch = "Local Net Switch",
    [string]$IsoPath = "C:\Users\ndesl\OneDrive\Isos\Linux\archlinux-2021.02.01-x86_64.iso")

$ErrorActionPreference = "Stop"

Write-Host -ForegroundColor Green Creating ArchLinux VM $Name

# Create VHD
$vhd = scripts/Create-HyperV-VM-Vhd.ps1 $Name -OutputVhd
# $VhdFolder = 'C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks'
# $Vhd = "$VhdFolder\$Name.vhdx"
# Write-Host -ForegroundColor Cyan Creating VHD $Vhd
# if (Test-Path $Vhd) { throw "VHD File $vhd already exists" }
# New-VHD -Path $vhd -SizeBytes 10GB -Dynamic -BlockSizeBytes 1MB | Out-Null

Write-Host -ForegroundColor Cyan Creating VM
New-VM $Name -Generation 2 -MemoryStartupBytes 1GB -SwitchName $VmSwitch -VHDPath $vhd.Path | Out-Null
Set-VM $Name -ProcessorCount 8 -DynamicMemory -MemoryMinimumBytes 32MB `
    -MemoryMaximumBytes 16GB -AutomaticCheckpointsEnabled $false

Write-Host -ForegroundColor Cyan Adding DVD drive and loading ArchLinux iso
Add-VMDvdDrive $Name -Path $IsoPath

Write-Host -ForegroundColor Cyan Configuring boot device and disabling Secure Boot
$bootEntries = Get-VMFirmware $Name | ForEach-Object BootOrder
Set-VMFirmware $Name -BootOrder (2, 0, 1 | ForEach-Object { $bootEntries[$_] }) -EnableSecureBoot Off

Write-Host -ForegroundColor Green VM $Name Successfully created!

Write-Host -ForegroundColor Green You can now start it and run the following commands to start the ArchLinux installation:`n
Write-Host "curl tinyurl.com/NicoArch -sL | bash
./install`n"