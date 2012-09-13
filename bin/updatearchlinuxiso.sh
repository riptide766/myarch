#!/bin/bash
#
# 下载archlinux.org/downlad的最新iso
#
# Date: 20120912 22:08
# Author: mattmonkey <mattmonkey@sina.com>

user=${SUDO_USER:-${USER}}
user_home=$(getent passwd ${user} | cut -d: -f6)

function get_latest_version(){
	lynx  -dump www.archlinux.org/download | grep -oP "(?<=Current\ Release:\ ).*"
}

function download(){
	wget -O $2 -c $1
}

function get_download_url(){
	echo "http://mirror.bjtu.edu.cn/archlinux/iso/"${latest_version}"/archlinux-"${latest_version}"-dual.iso"
}

function update_iso(){
	if [  -e "$iso_file" ]; then
		exit 0
	fi

	download `get_download_url` "$tmp_file"
	
	if [ $? != 0 ] ; then
		exit 1
	fi
	
	mv -v $tmp_file $iso_file
	
	if [ -e $config_file ]; then
		rm -rfv `cat $config_file`
	fi
	
	echo $2 > $config_file
	
	exit 0
}

#-------------------------------------------------------------

download_dir="$user_home"
latest_version=`get_latest_version`
iso_file=${download_dir}/"archlinux-"${latest_version}".iso"
tmp_file=${iso_file}".tmp"
config_file=${user_home}/".archlinuxiso"

update_iso

