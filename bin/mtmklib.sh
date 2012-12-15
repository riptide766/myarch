#!/bin/bash - 
#===============================================================================
#
#          FILE: mtmklib.sh
# 
#         USAGE: ./mtmklib.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 12/08/2012 12:13:23 PM CST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

repeat (){
	local length=$1
	printf -v line '%*s' "$length"
	echo ${line// /-}
}

