#!/bin/bash
# 正则练习器

if [ $# -lt 2 ]
then
    echo "Usage: $0 regex string" >&2
    exit 1
fi
 
regex=$1
input=$2
 
if [[ $input =~ $regex ]]
then
    echo "$input matches regex: $regex"
 
    #print out capturing groups
    for (( i=0; i<${#BASH_REMATCH[@]}; i++))
    do
        echo -e "\tGroup[$i]: ${BASH_REMATCH[$i]}"
    done
else
    echo "$input does not match regex: $regex"
fi
