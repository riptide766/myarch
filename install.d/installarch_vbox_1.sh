# 第一部分脚本下载地址 t.cn/zW9b3RN

# 分区和格式化
cfdisk
mkfs.ext2 /dev/sda1
mkfs.ext2 /dev/sda3

# mount 新系统的根目录到/mnt
mount /dev/sda1 /mnt

# 请求IP
dhcpcd eth0

# 安装基础系统
pacstrap /mnt base grub-bios sudo

# 追加挂载信息到fstab。 / 和 /home
mount /dev/sda3 /mnt/home
genfstab -p /mnt >> /mnt/etc/fstab

# 进入新系统
arch-chroot /mnt


 
