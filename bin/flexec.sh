#!/bin/bash
#
# 让别名可以使用位置参数
#
# Date:
# Author: mattmonkey <mattmonkey@sina.com>

script_path="/tmp/__flexcmd.sh"

echo "#! /bin/bash" > "$script_path"
echo "# generated by script" >> "$script_path"
echo $1 | tr  '%' '$' >> "$script_path"

# 参数列表中移除命令样式
shift 1

source $script_path $@

# 不换行
echo -n "[ $@ ] ==>  "

# 打印命令样式
sed -ne '3p' "$script_path"
