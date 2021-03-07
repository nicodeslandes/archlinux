param(
    [Parameter(Mandatory = $true)]
    [string]$Name,
    [switch]$OutputVhd)

$ErrorActionPreference = "Stop"

# Create VHD with 1MB Block Size

$VhdFolder = 'C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks'
$VhdPath = "$VhdFolder\$Name.vhdx"
Write-Host -ForegroundColor Cyan Creating VHD $VhdPath

if (Test-Path $VhdPath) {
    while ($true) {
        Write-Host -NoNewline -ForegroundColor Green "VHD File $VhdPath already exists.`nDo you want to delete it? [Y/n] "
        $response = Read-Host
        if ($response -ieq "Y" -or $null -eq $reponse) {
            Remove-Item $VhdPath
            break
        }
        elseif ($response -ieq "N") {
            throw "VHD Creation aborted"
        }
    }
 }

$Vhd = New-VHD -Path $VhdPath -SizeBytes 10GB -Dynamic -BlockSizeBytes 1MB
if ($OutputVhd) {
    Write-Output $Vhd
}