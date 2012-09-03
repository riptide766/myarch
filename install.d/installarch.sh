
_slim_conf="/etc/slim.conf"
_rc_conf="/etc/rc.conf"
_username="matt"
_sudoers="/etc/sudoers"
_pacman_conf="/etc/pacman.conf"
_modprobe_conf="/etc/modprobe.d/modprobe.conf"
_bootloader_dev="/dev/sda"
_grub_conf="/etc/default/grub"

# systemd
_install_systemd()
{

pacman -R initscripts sysvinit
pacman -S systemd systemd-sysvcompat systemd-arch-units

}

# AUR client
_install_yaourt()
{

grep -q -e "^\[archlinuxfr\]" $_pacman_conf || echo -e "[archlinuxfr]\nServer = http://repo.archlinux.fr/\$arch" >> $_pacman_conf
pacman -Sy yaourt base-devel --noconfirm

}

# X11
_install_X11()
{

pacman -S xorg-server xorg-server-utils xorg-xinit xorg-utils xfce4 xfce4-goodies nvidia nvidia-utils dbus --noconfirm
nvidia-xconfig 

}

# Sound
_install_alsa()
{

sudo pacman -S alsa-utils --noconfirm

}

# Display manager
_install_slim()
{

pacman -S slim slim-themes archlinux-themes-slim --noconfirm

}

# Multiboot Boot loader
_install_grub2()
{

# 安装配置grub2
pacman -S os-prober grub-bios --noconfirm
yaourt -S grub2-theme-archlinux --noconfirm
yaourt -S grub2-theme-archxion --noconfirm
sudo grub-install --boot-directory=/boot --no-floppy --recheck --debug $_bootloader_dev

}

# software
_install_software()
{
# popular software
pacman -S zenity fcitx transmission-gtk gvfs ntp ibus-anthy ibus-pinyin virtualbox virtualbox-sourc:e virtualbox-modules wmctrl xbindkeys ntfs-3g p7zip unrar unzip chmsee epdfview stellarium freemind amule smplayer ristretto transmission-gtk firefox flashplugin terminator bash-completion scrot colordiff --noconfirm

sudo pacman -S git zsh abs ascii ack gvim python-sphinx openssh tree qgit subversion dia arch-install-scripts xsel --noconfirm

# office
sudo pacman -S graphite  hsqldb-java hyphen icu  libidl2  libreoffice-zh-CN libwpd  libwps lpsolve orbit2  raptor  rasqal redland  libreoffice-base libreoffice-calc  libreoffice-common libreoffice-draw  libreoffice-writer

# fonts
sudo pacman -S wqy-bitmapfont wqy-zenhei ttf-dejavu ttf-arphic-ukai ttf-arphic-uming ttf-fireflysung rsync --noconfirm
sudo yaourt -S ttf-microsoft-yahei --noconfirm
#yaourt -S ttf-ms-fonts-zh_cn  --noconfirm
#yaourt -S ttf-ms-fonts --noconfirm


# others
yaourt -S trash-cli --noconfirm
yaourt -S xmind --noconfirm

}

# setting alsa
_config_alsa()
{

mkdir -pv /etc/modprobe.d
grep -q -e "^option snd-NAME-OF-MODULE" $_modprobe_conf || echo "options snd-NAME-OF-MODULE ac97_quirk=0" >> $_modprobe_conf

}

_config_slim()
{

# appending themes to slim.conf
grep -q -e "^current_theme\s*default" $_slim_conf && sed -i -e "s/\(current_theme\ *\)\ *\(default\)/\1fingerprint,flat,archlinux-darch-white/" $_slim_conf
# appending slim to daemon
grep -q -e "^DAEMONS=(.* dbus slim" $_rc_conf || sed -i "s/^DAEMONS=([^)]*/& dbus slim/" $_rc_conf
# setting default user
grep -q -e "^default_user" $_slim_conf || sed -i -e '/^#default_user/a default_user\tmatt' $_slim_conf
# setting login automatically
grep -q -e "^auto_login" $_slim_conf || sed -i -e '/^#auto_login/a auto_login\tyes' $_slim_conf

}

_config_grub2()
{

# modifying theme
grep -q -e "^GRUB_THEME" $_grub_conf ||  sed -i -e "/^#GRUB_THEME=/a GRUB_THEME=/usr/share/grub/themes/Archlinux/theme.txt" $_grub_conf

# modifying kernel parmater
grep -q -e "GRUB_CMDLINE_LINUX_DEFAULT=.*acpi=off" $_grub_conf || sed -i -e "s/^GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*/& acpi=off/" $_grub_conf

sed -i -e "s/^GRUB_TIMEOUT=.*^/GRUB_TIMEOUT=1/" $_grub_conf

# disable os probe
grep -q -e "GRUB_DISABLE_OS_PROBER=true" $_grub_conf || echo -e "\nGRUB_DISABLE_OS_PROBER=true\n" >> $_grub_conf
#grep -q -e "menuentry 'Ubuntu 12.04'" /etc/grub.d/40_custom  || cat >> /etc/grub.d/40_custom << "EOF"
#menuentry 'Ubuntu 12.04' --class ubuntu --class gnu-linux --class gnu --class os {
	#recordfail
	#gfxmode $linux_gfx_mode
	#insmod gzio
	#insmod part_msdos
	#insmod ext2
	#set root='(hd0,msdos9)'
	#search --no-floppy --fs-uuid --set=root 6c7fbafe-845d-4277-b9d3-ab7c34516ef0
	#linux	/boot/vmlinuz-3.2.0-23-generic-pae root=UUID=6c7fbafe-845d-4277-b9d3-ab7c34516ef0 ro quiet acpi=off splash $vt_handoff
	#initrd	/boot/initrd.img-3.2.0-23-generic-pae
#}
#EOF

sudo RUB_PREFIX="/boot/grub" grub-mkconfig -o /boot/grub/grub.cfg

}


# desktop icon
_config_desktopicon()
{

cat > ~/.gtkrc-2.0 <<"EOF"
style "xfdesktop-icon-view" {
XfdesktopIconView::label-alpha = 0

base[NORMAL] = "#00ff00"
base[SELECTED] = "#5050ff"
base[ACTIVE] = "#0000ff"

fg[NORMAL] = "#000000"
fg[SELECTED] = "#000000"
fg[ACTIVE] = "#000000"
}
widget_class "*XfdesktopIconView*" style "xfdesktop-icon-view"
EOF

}


# virtualbox
_config_vbox()
{

#grep -q -e "^MODULES" $_rc_conf || echo -e "\nMODULES=()" >> $_rc_conf
#grep -q -e "^MODULES.*vboxdrv" $_rc_conf || sudo sed -i "s/^MODULES=([^)]*/& vboxdrv/"  $_rc_conf
echo vboxdrv > /etc/modules-load.d/virtualbox.conf

}

#  localization
_config_locale()
{

#echo -e '\nHOSTNAME="mattPC"\nLOCALE="en_US.UTF-8"' >> /etc/rc.conf
sed -i -e "s/#\(en_US.UTF-8.*\)/\1/" /etc/locale.gen
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
locale-gen
echo mattPC > /etc/hostname
echo LANG="en_US.UTF8" > /etc/locale.conf
systemctl enable slim.service
systemctl enable dhcpcd@.service
systemctl enable syslog-ng.service
systemctl enable graphical.target

}

# fix network unreachable
_fix_dhcpcd_mtu()
{

sed -i -e "s/option interface_mtu/#&/" /etc/dhcpcd.conf
 
}

_add_user()
{

groupadd $_username
useradd -s /bin/bash -g $_username -m -k /etc/skel/ $_username
passwd $_username
grep -q -e "# %wheel" $_sudoers && sed -i -e "s/#\ \(%wheel\)/\1/" $_sudoers
gpasswd -a $_username wheel

}

_setting_shell()
{

local shelldir="shell.d"

echo "链接shell环境文件"
for file in `ls shell.d`;
do
	ln -sfv `pwd`/$shelldir/$file ~/\.$file
done



}

_setting_other()
{


echo "链接脚本到～/bin目录"
mkdir -pv ~/bin
for file in `ls shortkey.d`;
do
	[[ "sh" == ${file#*.} ]] && ln -sfv `pwd`/shortkey.d/$file ~/bin/$file
done
ln -sfv `pwd`/shortkey.d/shortkey.xbindkeysrc ~/.xbindkeysrc


echo "链接firefox的pentadactyl配置到主目录"
for file in `ls pentadactyl.d`;
do
	ln -sfv `pwd`/pentadactyl.d/$file ~/\.${file#*.}
done

}

