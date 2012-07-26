====================
ArchLinux  
====================

# 安装aur前端yaour
sudo sh -c 'echo -e "[archlinuxfr]\nServer = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf'
sudo pacman -Sy
sudo pacman -S yaourt

# 安装配置X
sudo pacman -S xorg-server xorg-server-utils xorg-xinit xorg-utils xfce4 xfce4-goodies nvidia nvidia-utils 
sudo nvidia-xconfig 

# 安装配置slim
pacman -S slim slim-themes archlinux-themes-slim
# sed 修改主题
# 配置daemon


# 安装配置grub2
sudo grub-install --boot-directory=/boot --no-floppy --recheck --debug /dev/sda
sudo RUB_PREFIX="/boot/grub" grub-mkconfig -o /boot/grub/grub.cfg
# 修改内核参数
# 修改分辨率
# 修改配色

# 安装配置声卡
sudo pacman -S alsa-utils
sudo sh -c 'echo "options snd-NAME-OF-MODULE ac97_quirk=0" > /etc/modprobe.d/modprobe.conf'

# 安装字体
i wqy-bitmapfont wqy-zenhei ttf-dejavu ttf-arphic-ukai ttf-arphic-uming ttf-fireflysung
# sudo yaourt -S ttf-ms-webfonts  --noconfirm
sudo yaourt -S ttf-ms-fonts-zh_cn  --noconfirm
sudo yaourt -S tf-ms-fonts --noconfirm

# 安装快捷键命令
i wmctrl xbindkeys

# 安装配置virtualbox
i -S virtualbox virtualbox-source virtualbox-modules
sudo modprobe vboxdrv

# 常用软件
sudo pacman -S p7zip unrar unzip chmsee epdfview stellarium openjdk6 freemind amule smplayer ristretto deluge gvim firefox flashplugin terminator bash-completion scrot
sudo yaourt -S ntpdate --noconfirm
sudo yaourt -S pysdm --noconfirm

# 开发软件
sudo pacman -S git python-sphinx openssh tree 

# sudo sed -i '9 a \Defaults\ttimestamp_timeout=-1' /etc/sudoers
# sudo sed -i "s/import vlc_1_0_x/# &/" /usr/share/sopcast-player/lib/VLCWidget.py
