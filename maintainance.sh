#! /bin/bash

# maintaince.sh所在目录
_workdir=$(dirname `readlink -f $0`)

# 函数库
_fns="$_workdir"/install.d/installarch.sh

# slim登录管理器配置文件
_slim_conf="/etc/slim.conf"

_username="matt"

_sudoers="/etc/sudoers"

# pacman包管理配置文件
_pacman_conf="/etc/pacman.conf"

_bootloader_dev="/dev/sda"

_grub_conf="/etc/default/grub"

# 软件安装列表
_software_list="$_workdir"/software_list

# 安装软件
function installer()
{
	_cmd="pacman"
	which yaourt &> /dev/null && _cmd="yaourt"
	"$_cmd" -S  "$@"
}

exec_by_name()
{
	echo "invoke ..."
	grep "$1.*()$" $_fns | cat -b
	echo "===================================="
	read -p "are you sure?(y/n) " rslt
	[ "${rslt:0:1}" = "n" ] && continue
	for fn in `grep "$1.*()$" $_fns`;  do
		${fn:0:-2}
	done
}


main()
{
for act in $@ ; do
	case "$act" in
		[^\_]*)
			case $act in
				list)
					grep "^_.*()$" $_fns |  tr -d "()"  ;;
				help)
					grep -B 1 "^_.*()$" _$fns |  tr -d "()"  | more ;;
				*)
					exec_by_name $act ;;
			esac
			;;
		*)
			echo invoke $act ...
			$act
	esac
done
}

source $_fns

main $@
