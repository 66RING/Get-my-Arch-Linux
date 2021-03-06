#!/bin/sh

###
### 实验阶段
###

# 先手动分区

$netcard
$wifi
$wfpw
$diskboot
$diskmain
$diskswap
$hostname
$passwd

ip link set $netcard up

wpa_passphrase $wifi $wfpw > internet.conf
wpa_supplicant -c internet.conf -i $netcard &
dhcpcd &

#定义分区格式

mkfs.fat -F32 $diskboot
mkfs.ext4 $diskmain               
mkswap $diskswap                  
swapon $diskswap

grep "^Color" /etc/pacman.conf >/dev/null || sed -i "s/^#Color/Color/" /etc/pacman.conf
#grep "ILoveCandy" /etc/pacman.conf >/dev/null || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

mkdir /mnt/boot           
mount $diskmain /mnt      
mount $diskboot /mnt/boot 

pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

grep "en_US.UTF-8 UTF-8" /mnt/etc/locale.gen >/dev/null || sed -i "s/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8" /mnt/etc/locale.gen

echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

echo $hostname >> /mnt/etc/hostname
echo "127.0.0.1 localhost" >> /mnt/etc/hosts
echo "::1 localhost" >> /mnt/etc/hosts
echo "127.0.0.1 $(hostname).localdomain $(hostname)" >> /mnt/etc/hosts






#  #登录后设置
#  
#  
#  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime   
#  hwclock --systohc                                         
#  
#  
#  locale-gen
#  
#  
#  # grub
#  pacman -S grub efibootmgr intel-ucode os-prober
#  mkdir /boot/grub
#  grub-mkconfig > /boot/grub/grub.cfg                      
#  grub-install --target=x86_64-efi --efi-directory=/boot   
#  
#  pacman -S zsh neovim wpa_supplicant dhcpcd network-manager-applet base-devel sudo
#  
#  useradd -m -G wheel ring      # -m        创建家目录
#  
#  passwd $passwd
#  
#  grep "%wheel ALL=(ALL) ALL" /etc/sudoers >/dev/null || sed -i "s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL" /etc/sudoers





