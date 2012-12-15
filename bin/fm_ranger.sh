#!/bin/bash - 
#===============================================================================
#
#          FILE: fm_ranger.sh
# 
#         USAGE: ./fm_ranger.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: mattmonkey
#  ORGANIZATION: 
#       CREATED: 2012年11月30日 07时29分25秒 CST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
terminator -e "ranger \"$1\""

