#!/bin/bash
#
# 让alias支持位置参数
#  
# 在启动文件中按下面的顺序source本脚本
#
# source ~/.zsh_aliases
# source ~/bin/aliaswrapper.sh
#
# Date: 20120814 12:52
# Author: riptide

_wrapalias_shell="zsh"

[ $BASH_VERSION  ] && _wrapalias_shell="bash"

alias_file=`readlink -m $HOME/.${_wrapalias_shell}_aliases`

sed 's/\(\s*alias\s*.*\)\(\s*#.*\)/\1/' $alias_file | grep -e "^\s*alias" | grep -e "\$[1-9\*]" | sed 's/\(alias\ \)\([\_a-zA-Z0-9]*\)=[\x27\x22]\(.*\)[\x27\x22]\s*$/function \2 () { \3 }/' | while read -r func ; do
    #[ $1 ] && echo $func
	unalias `echo $func | cut -d" " -f2`
	eval "$func"
done


