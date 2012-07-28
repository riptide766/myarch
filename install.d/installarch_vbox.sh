# 第一部分脚本下载地址 t.cn/zW9b3RN

# 分区和格式化
cfdisk
mkfs.ext2 /dev/sda1
mkfs.ext2 /dev/sda3


# mount 新系统的根目录
mount /dev/sda1 /mnt

# 启用网卡
dhcpcd eth0

# 安装基础系统
pacstrap /mnt base grub-bios sudo

# 追加挂载信息到fstab。 / 和 /home
mount /dev/sda3 /mnt/home
genfstab -p /mnt >> /mnt/etc/fstab

# 进入新系统
arch-chroot /mnt



# 第二部分脚本下载地址 t.cn/zW9GfvH

# 添加xinitrc
echo "exec startxfce4" >> /home/test/.xinitrc

 

# 建立用户
groupadd test
useradd -s /bin/bash -g test -m -k /etc/skel/ test
passwd test

# 添加新用户sudo权限
sed -i -e "s/#\ \(%wheel\)/\1/" /etc/sudoers
gpasswd -a test wheel


# 安装bootloader，生成grub菜单
grub-install --boot-directory=/boot /dev/sda"
grub-mkconfig -o /boot/grub/grub.cfg"

# 安装X
pacman -S slim xorg-server xorg-xinit xorg-utils xorg-server-utils xf86-video-vesa xfce4 dbus

# 配置dbus和slim到DAEMON
sed -i "s/^DAEMONS=([^)]*/& dbus slim/" /etc/rc.conf

# 设置locale和hostname
echo -e '\nHOSTNAME="testPC"\nLOCALE="en_US.UTF-8"' >> /etc/rc.conf
sed -i -e "s/#\(en_US.UTF-8.*\)/\1/" /etc/locale.gen
locale-gen

# 添加xinitrc
echo "exec startxfce4" >> /home/test/.xinitrc

# 重启
reboot
