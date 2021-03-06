read -p "Enter the machine hostname [archie]: " HOSTNAME
if [ -z $HOSTNAME ]
then HOSTNAME=archie
fi

echo Starting ArchLinux installation for host $HOSTNAME
exit 0

# Setup disk partitions
curl https://raw.githubusercontent.com/nicodeslandes/archlinux/main/sda.sfdisk | sfdisk /dev/sda

# Format EFI partition
mkfs.fat -F32 /dev/sda1

# Format main linux partition (best practice for hyper-v: set nb of groups to 4096)
mkfs.ext4 -G 4096 /dev/sda2

# Mount the partitions in /mnt
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Kick off the installation (not including linux-firmware as this is for VMs)
pacstrap /mnt base linux

# Setup fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot into the new file system and run the rest of the install script
curl https://raw.githubusercontent.com/nicodeslandes/archlinux/main/chroot_setup.sh -o /mnt/root/chroot_setup.sh
chmod +x /mnt/root/chroot_setup.sh
arch-chroot /mnt /root/chroot_setup.sh $HOSTNAME
rm /mnt/root/chroot_setup.sh

# Setup EFI Boot Manager
# Get the Linux partition UID
LINUX_PARTUUID=`lsblk -dno PARTUUID /dev/sda2`

# Create a new entry, and set it as the first boot option
efibootmgr --create --label "Arch Linux" --loader /vmlinuz-linux --unicode "root=PARTUUID=$LINUX_PARTUUID rw initrd=\\initramfs-linux.img" --verbose
efibootmgr -o 3,2,1 -n 3

# And reboot
echo -n Press Enter to reboot
read
reboot