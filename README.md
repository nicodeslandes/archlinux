# archlinux

Set of scripts and config files to setup an ArchLinux machine quickly

## Instructions

- Create a VHD using an elevated PowerShell prompt:

```powershell
./Create-HyperV-Vhd.ps1 <vm_name>
```

- Create the VM using the Hyper-V manager, and using the generated VHD as the main disk
- Add a DVD Drive and load the ArchLinux Live CD Iso
- Start the VM
- In the root prompt, run the following commands:

```bash
curl -O https://raw.githubusercontent.com/nicodeslandes/archlinux/main/install.sh
chmod +x install.sh
./install.sh <host_name>
```
