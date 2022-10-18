#!/bin/sh

if [ -z "$1" ]
  then
    echo "Usage: $0 <host_name>"
    exit 1
fi

HOSTNAME=$1
PACMAN_INSTALL='pacman -Sy --noconfirm'

# Setup London time zone and setup /etc/adjtime
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Setup locales
#  - uncomment the following locales from /etc/locale.gen
#       - en_US.UTF-8 UTF-8 (already uncommented)
#       - en_GB.UTF-8 UTF-8
#  - generate corresponding locales
#  - enable =en_GB.UTF-8 as the default locale
sed -i 's/^#\(en_GB.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo 'LANG=en_GB.UTF-8' > /etc/locale.conf

# Set console keyboard layout to uk
echo 'KEYMAP=uk' > /etc/vconsole.conf

# Network config
# Enable eth0
ip link set eth0 up

echo $HOSTNAME > /etc/hostname
cat > /etc/hosts <<EOL
127.0.0.1   localhost
::1		    localhost
127.0.1.1	$HOSTNAME.local	$HOSTNAME
EOL

# Setup dhcp
$PACMAN_INSTALL dhcpcd
systemctl enable dhcpcd
# disable ARP probing
cat >> /etc/dhcpcd.conf <<EOL

# Disable ARP probing
noarp
EOL

# Setup ssh
$PACMAN_INSTALL openssh
systemctl enable sshd

# Install basic tools
$PACMAN_INSTALL vim nano man-db htop which

# Setup vim
ln -sf /usr/bin/vim /usr/bin/vi

# Setup root password
echo -n 'Setting up root password. '
passwd

# Create new user
read -p "Enter new username [nico]: " USERNAME
if [ -z $USERNAME ];
then
  USERNAME=nico
fi

useradd $USERNAME
mkdir /home/$USERNAME
chown $USERNAME:$USERNAME /home/$USERNAME
echo -n "Setting up password for user $USERNAME. "
passwd $USERNAME

# Setup sudo for user
$PACMAN_INSTALL sudo

# Add user to sudoers group
groupadd sudo
usermod $USERNAME -G sudo
sed -i -E 's/^#\s*(%sudo\s+ALL=\(ALL:ALL\)\s+ALL)/\1/' /etc/sudoers
