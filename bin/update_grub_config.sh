#!/bin/bash
#
# 更新usb特定分区的arch_grub.cfg
#
# Date:
# Author: mattmonkey <mattmonkey@sina.com>

host_config="/boot/grub/grub.cfg"
usb_config="/media/LIVEUSB_BOOT/arch_grub.cfg"
/usr/bin/diff -q $host_config $usb_config && echo "no diff" || {
	usb_config_bak="$usb_config"_`/bin/date +%Y_%m_%d_%N`
	/bin/cp -v $usb_config $usb_config_bak
	/bin/cp -v $host_config $usb_config
	echo done
}

