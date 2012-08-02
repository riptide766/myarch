#!/bin/bash
#
# 切换或打开一个程序窗口 
#  
# Date: 20120801
# Author: riptide

#
# 映射格式 [shortname]="classname|command"
# classname可以通过wmctrl -lx查看
# 数组的顺序决定快捷键的编号. 第一个是super + 1 ；第二个是super + 2 .依次递进
# 通过 -s 选项应用配置
#

declare -A mapping=(
	[terminator]="terminator.Terminator|terminator" 
	[gvim]="gvim.Gvim|gvim -f"
	[firefox]="navigator.Firefox|firefox"
	[eclipse]="eclipse.Eclipse|/home/matt/resources/eclipse/eclipse"
	[thunar]="Thunar.Thunar|thunar"
)

tagstr="# added by jump_or_exec"

config_file=$(readlink -m "/home/`whoami`/.xbindkeysrc")

clear_oldsetting(){
	grep -q "$tagstr" $config_file || return
	range=`grep -n "^$tagstr" $config_file | awk -F: '{ a[NR]=$1 } END {b=a[1]","a[2]; print b}' `d
	sed -i "$range" $config_file
}

get_pos(){
  grep -E "\[$1\]" -n $0 | cut -d":" -f 1
}

get_base(){
  grep -E "$1" -n $0 | cut -d":" -f 1
}

setting(){
	local base=`get_base "^declare"`
	local keys=${!mapping[@]}
	local cmd=`basename $0` out=
	for key in $keys; do
		out+="\"$cmd -e $key\"\n\tMod4 + $(( `get_pos $key` - $base ))\n\n"
	done
	clear_oldsetting
	echo -e $tagstr"\n"$out$tagstr >> $config_file
	killall -HUP xbindkeys
}

execution(){
	entry=${mapping[$1]} 
	wmctrl -a ${entry%\|*} -x || exec ${entry#*\|} &
}

usage(){
cat <<EOF
-s      添加快捷键配置到.xbindkeysrc
-e app  切换或打开程序窗口	
-h      帮助信息
EOF
}

if [[ -z $1 || $1 = @(-h|--help) ]]; then
  usage
  exit $(( $# ? 0 : 1 ))
fi

while getopts she: opt ; do
	case $opt in
		s) 
			setting
			echo done...
			;;
		e) 
			execution $OPTARG
			;;
		h|*)
			usage
			;;
	esac
done

