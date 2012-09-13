#!/bin/bash
#
# 切换或打开一个程序窗口 
# 切换同一种程序的不同窗口
#
# Date: 20120801
# Author: riptide

### 配置区开始
#

declare -A mapping=(
	[terminator]="terminator.Terminator|terminator" 
	[gvim]="gvim.Gvim|gvim -f"
	[firefox]="navigator.Firefox|firefox"
	[eclipse]="eclipse.Eclipse|/home/matt/resources/eclipse/eclipse"
	[thunar]="Thunar.Thunar|thunar"
)

switchkey="Alt + grave"

declare -A gridkeys=(
	[lt]="q" 
	[t]="w"
	[rt]="e"
	[l]="a"
	[fs]="s"
	[r]="d"
	[rb]="c"
	[b]="x"
	[lb]="z"
)

#s
### 配置区结束

user=${SUDO_USER:-${USER}}
user_home=$(getent passwd ${user} | cut -d: -f6)
group=$(getent group ${user} | cut -d: -f1)


tagstr="# added by jump_or_exec"

config_file=$(readlink -m "$user_home/.xbindkeysrc")


clear_oldsetting(){
	grep -q "$tagstr" $config_file || return
	range=`grep -n "^$tagstr" $config_file | awk -F: '{ a[NR]=$1 } END {b=a[1]","a[2]; print b}' `d
	sed -i "$range" $config_file
}

# 求指定数组key的数据位置
get_pos(){
  grep -E "\[$1\]" -n $0 | head -n 1 | cut -d":" -f 1 
}

# 求mapping数组的位置
get_base(){
	grep -E "$1" -n $0 | cut -d":" -f 1 
}
	
setting(){
	# jump or exec 
	local base=`get_base "^declare\ \-A\ mapping"`
	local keys=${!mapping[@]}
	local cmd=`basename $0` out=
	for key in $keys; do
		out+="\"$cmd -e $key\"\n\tMod4 + $(( `get_pos $key` - $base ))\n\n"
	done
	out+="\"$cmd -s\"\n\t$switchkey\n\n"
	
	# grid
	for key in ${!gridkeys[@]}; do
		out+="\"$cmd -g $key\"\n\tMod4 + ${gridkeys[$key]}\n\n"
	done

	# configure	
	clear_oldsetting
	echo -e $tagstr"\n"$out$tagstr >> $config_file
	killall -HUP xbindkeys 2>/dev/null
}

jump_or_exec(){
	entry=${mapping[$1]}
	currentclazzname=$(wmctrl -lx | grep ` echo $(xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/')` | cut -d" "  -f 4)
	if [ $currentclazzname ==  "${entry%\|*}" ] ; then
		xdotool getactivewindow windowminimize 
	else
		wmctrl -a ${entry%\|*} -x || exec ${entry#*\|} &
	fi
}


switch_same_app(){
	data=$(wmctrl -lxp | grep `echo $(xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/')`)
	ccls=$(echo $data | cut -d" " -f 4)
	cwid=$(echo $data | cut -d" " -f 1)
	cwks=$(echo $data | cut -d" " -f 2)
	list=$(wmctrl -lxp | awk -v wks=$cwks -v cls=$ccls '{ if ( $2 == wks && $4 == cls ) print $1 }')
	list=$list" "$list
	twid=$(echo ${list#*$cwid} | cut -d" " -f 1)
	wmctrl -i -a $twid
}

### 安装依赖软件

install_software()
{
	[[ `which $1  2>/dev/null `  ]] && {
		echo $1 已安装
		return
	} 
	[ $UID == 0 ] || { 
		echo -e "请使用sudo命令安装依赖工具 $1" 
		exit 1
	}
    pacman -S $1 --noconfirm
}

install_tool()
{
	
	install_software wmctrl || exit 1
	install_software xbindkeys || exit 1
	install_software xdotool || exit 1
	[[  -a $config_file ]] || {
		xbindkeys -d > $config_file
		chown $user:$group $config_file
		echo 生成默认配置文件
	}
	killall xbindkeys >/dev/null 2>&1
	/usr/bin/nohup xbindkeys > /dev/null 2>&1
	[ $? == 0 ] && echo "xbindkeys服务已启动" || echo "请手动输入nohup xbindkeys > /dev/null 2>&1 启动服务"
	
}


### grid

function grid()
{

if [[ "x${DISPLAY}" != "x" ]]; then
  : ;
else
  DISPLAY=:0.0 ;
fi
 
# some xrandr, grep and gawk magic… nothing difficult here
XRES=$(xrandr -d $DISPLAY -q | grep '*' | gawk '{ print $1 }' | gawk -Fx '{ print $1 }')
YRES=$(xrandr -d $DISPLAY -q | grep '*' | gawk '{ print $1 }' | gawk -Fx '{ print $2 }')
 
XRES_2=$(($XRES / 2))
YRES_2=$(($YRES / 2))
 
 
# the widths of the borders from the theme…  upper and left are recognized
# right… TODO: auto-bordering
BORDER_RIGHT=10
BORDER_BOTTOM=28
 
 
# left right top bottom - will be nice
case $1 in
  tl|lt)  MoveWindow 0        0       $XRES_2 $YRES_2 ;;
  t)      MoveWindow 0        0       $XRES   $YRES_2 ;;
  tr|rt)  MoveWindow $XRES_2  0       $XRES_2 $YRES_2 ;;
  r)      MoveWindow $XRES_2  0       $XRES_2 $YRES   ;;
  br|rb)  MoveWindow $XRES_2  $YRES_2 $XRES_2 $YRES_2 ;;
  b)      MoveWindow 0        $YRES_2 $XRES   $YRES_2 ;;
  bl|lb)  MoveWindow 0        $YRES_2 $XRES_2 $YRES_2 ;;
  l)      MoveWindow 0        0       $XRES_2 $YRES   ;;
  fs)     wmctrl -r :ACTIVE: -b toggle,maximized_horz,maximized_vert ;;
  *)        exit 1 ;;
esac

}

function MoveWindow ()
{
  DISPLAY=$DISPLAY wmctrl -r :ACTIVE: -b remove,maximized_horz,maximized_vert
  DISPLAY=$DISPLAY wmctrl -r :ACTIVE: -b remove,fullscreen
  DISPLAY=$DISPLAY wmctrl -r :ACTIVE: -e 0,$1,$2,$(($3 - $BORDER_RIGHT)),$(($4 - $BORDER_BOTTOM))
}
 


### 帮助、参数处理

usage(){
cat <<EOF
Usage:	commond [optins...]
-i      安装相关软件
-S      更新快捷键配置到.xbindkeysrc
-s      切换到同一种程序的其他窗口
-e app  切换或打开一个程序窗口	
-g pos  移动窗口到指定位置
-h      帮助信息

简述

仿ubuntu untiy桌面快捷解

1）切换或打开程序   super + [1-9]
2）切换相同程序窗口 alt + \`
3) 九宫格移动窗口   super + [qweasdzxc]
4) 最小化当前窗口（已配置的） super + [1-9]



配置方法

 修改脚本头部的数组.

 mapping=(
	[terminator]="terminator.Terminator|terminator" 
	[gvim]="gvim.Gvim|gvim -f"
	[firefox]="navigator.Firefox|firefox"
	[eclipse]="eclipse.Eclipse|/home/matt/resources/eclipse/eclipse"
	[thunar]="Thunar.Thunar|thunar"
)

 映射格式 [shortname]="classname|command"
 shortname		软件短名
 classname		可以通过wmctrl -lx查看
 comand			软件启动命令

 数组的顺序决定快捷键的编号. 
 第一行是super + 1 
 第二个是super + 2 .依次递进
 
 修改后通过 -S 选项应用配置

EOF
}

if [[ -z $1 || $1 = @(-h|--help) ]]; then
  usage
  exit $(( $# ? 0 : 1 ))
fi



while getopts :sShig:e: opt ; do
	case $opt in
		S) # 更新xbindkeys配置文件以及服务
			setting
			echo 快捷键配置已更新
			;;
		g) # 当前窗口移动到各种角落
			grid $OPTARG
			;;
		s) # 在相同软件间切换窗口
			switch_same_app
			;;
		i) # 安装依赖软件
			install_tool
			;;
		e) # 切换或打开一个窗口
			jump_or_exec $OPTARG
			;;
		:) 
			echo missing argument
			;;
		?)
			echo invaild option -- $OPTARG
			usage
			;;
	esac
done

