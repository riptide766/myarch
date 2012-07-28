
# AUR client
_install_yaourt()
{

# 添加源
sudo sh -c 'echo -e "[archlinuxfr]\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf'
# 安装
sudo pacman -Sy yaourt

}

# X11
_install_X11()
{

# 安装X11 桌面 显卡
sudo pacman -S xorg-server xorg-server-utils xorg-xinit xorg-utils xfce4 xfce4-goodies nvidia nvidia-utils 
# 生成配置
sudo nvidia-xconfig 

}

# Sound
_install_alsa()
{

# 安装声卡
sudo pacman -S alsa-utils
# 解决声卡没有声音的问题
sudo sh -c 'echo "options snd-NAME-OF-MODULE ac97_quirk=0" >> /etc/modprobe.d/modprobe.conf'

}

# Display manager
_install_slim()
{

# slim
# 安装slim以及主题
sudo pacman -S slim slim-themes archlinux-themes-slim
# sed 修改主题

# 添加DAEMONS到rc.conf
sudo sed -i "s/^DAEMONS=([^)]*/& dbus slim/" /etc/rc.conf

}

# Multiboot Boot loader
_install_grub2()
{

# 安装配置grub2
sudo pacman -S os-prober grub-bios
yaourt -S grub2-theme-archlinux --noconfirm
sudo grub-install --boot-directory=/boot --no-floppy --recheck --debug /dev/sda
sudo RUB_PREFIX="/boot/grub" grub-mkconfig -o /boot/grub/grub.cfg
# 修改内核参数
# 修改分辨率
# 修改配色
# 添加ubuntu启动菜单
cat >> /etc/grub.d/40_custom << "EOF"
menuentry 'Ubuntu' --class ubuntu --class gnu-linux --class gnu --class os {
	recordfail
	gfxmode $linux_gfx_mode
	insmod gzio
	insmod part_msdos
	insmod ext2
	set root='(hd0,msdos9)'
	search --no-floppy --fs-uuid --set=root 6c7fbafe-845d-4277-b9d3-ab7c34516ef0
	linux	/boot/vmlinuz-3.2.0-23-generic-pae root=UUID=6c7fbafe-845d-4277-b9d3-ab7c34516ef0 ro   quiet acpi=off splash $vt_handoff
	initrd	/boot/initrd.img-3.2.0-23-generic-pae
}
EOF

}


# software
_install_software()
{

# 安装字体
sudo pacman -S wqy-bitmapfont wqy-zenhei ttf-dejavu ttf-arphic-ukai ttf-arphic-uming ttf-fireflysung
sudo yaourt -S ttf-ms-fonts-zh_cn  --noconfirm
sudo yaourt -S tf-ms-fonts --noconfirm

# 常用软件
sudo pacman -S wmctrl xbindkeys p7zip unrar unzip chmsee epdfview stellarium openjdk6 freemind amule smplayer ristretto deluge  firefox flashplugin terminator bash-completion scrot colordiff
sudo yaourt -S ntpdate --noconfirm
sudo yaourt -S pysdm --noconfirm

# 开发软件
sudo pacman -S git pgvim ython-sphinx openssh tree qgit subversion man-pages-zh_cn dia

}

# virtualbox
_install_virtualbox()
{

# 安装
sudo pacman -S virtualbox virtualbox-source virtualbox-modules
# 添加模块（也可不加）
sudo modprobe vboxdrv
# 添加启动模块到rc.conf

sudo sed -i "s/^MODULES=([^)]*/&vboxdrv/"  /etc/rc.conf 

}

# sudo sed -i '9 a \Defaults\ttimestamp_timeout=-1' /etc/sudoers
# sudo sed -i "s/import vlc_1_0_x/# &/" /usr/share/sopcast-player/lib/VLCWidget.py
