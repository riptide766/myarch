#!/bin/bash
#
#
#
# Date:
# Author: mattmonkey <mattmonkey@sina.com>


sites=("weibo.com" "ltaaa.com")
file_hosts="/home/matt/hosts"

switchcomment(){
	grep -q -e "$1"
}

usage(){
cat <<EOF

on    开启屏蔽
off   解除屏蔽

EOF
}

if [[ -z $1 || $1 = !(on|off) ]]; then
	usage
	exit
fi






