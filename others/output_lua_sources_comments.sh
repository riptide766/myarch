#!/bin/bash - 
#===============================================================================
#
#          FILE: list.sh
# 
#         USAGE: ./list.sh 
# 
#   DESCRIPTION: 列出lua源码C文件头部的注释
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: mattmonkey
#  ORGANIZATION: 
#       CREATED: 12/07/2012 10:18:16 PM CST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

[[ "$#" == 0 ]] &&  {
	echo "usage: $0 path"
	exit 1
}

src_dir="$1"
pos=$((${#src_dir}+2))

outline ()
{
	printf "%-6d%-15s%s\n" "$1" "$2" "$3" 
}

{
for file in `ls -1 "$src_dir"/*.c` ; do
	comment=`sed -n "3p" $file | cut -d" " -f2-`
	filename=`basename $file`
	lines=`wc -l $file | cut -d" " -f1`
	outline "$lines" "$filename" "$comment" 
	#wc -l $file | awk -v pos="$pos" -v comment="$comment"  \
		#'{ printf("%-6d%-15s%s\n", $1, substr($2,pos) , comment)   }'
done
} | sort -nk 1| cat  -b  | awk  '{ if(l<length($0)){ l=length($0)}; s+=$2; print $0}
	END { while(l--){ sp=sp"-"} print sp ;printf("%8s%-6d\n","",s)}'


