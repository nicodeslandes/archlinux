# archlinux

Set of scripts and config files to setup an ArchLinux machine quickly

## Instructions

- Create the VM using an elevated PowerShell prompt:
```powershell
./Create-HyperV-VM.ps1 <vm_name> [<VmSwitch>] [<IsoPath>]
```
- Start the VM
- In the root prompt, run the following commands:
```bash
curl shorturl.at/GP379 -Lo install.sh
chmod +x install.sh
./install.sh <host_name>
```
