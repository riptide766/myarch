#!/bin/sh
# first of all, the standard method definition

function MoveWindow ()
{
  # 删除当前窗口的状态：全屏，水平最大，垂直最大	
  wmctrl -r :ACTIVE: -b remove,maximized_horz,maximized_vert
  wmctrl -r :ACTIVE: -b remove,fullscreen
  # -e <mvarg> 
  # ”g”代表窗口的层次，所有窗口普通层次的值都为0；”x”和 ”y”分别是窗口的横、竖坐标；”w”和”h”分别是窗口的宽度和高度。
  wmctrl -r :ACTIVE: -e 0,$1,$2,$(($3 - $BORDER_RIGHT)),$(($4 - $BORDER_BOTTOM))
}
 

# 取分辨率
XRES=$(xrandr -q | grep '*' | gawk '{ print $1 }' | gawk -Fx '{ print $1 }')
YRES=$(xrandr -q | grep '*' | gawk '{ print $1 }' | gawk -Fx '{ print $2 }')

#中间点坐标
XRES_2=$(($XRES / 2))
YRES_2=$(($YRES / 2))
 
 
BORDER_RIGHT=10
BORDER_BOTTOM=28
 
 
case $1 in
  -tl|-lt)  MoveWindow 0        0       $XRES_2 $YRES_2 ;;
  -t)       MoveWindow 0        0       $XRES   $YRES_2 ;;
  -tr|-rt)  MoveWindow $XRES_2  0       $XRES_2 $YRES_2 ;;
  -r)       MoveWindow $XRES_2  0       $XRES_2 $YRES   ;;
  -br|-rb)  MoveWindow $XRES_2  $YRES_2 $XRES_2 $YRES_2 ;;
  -b)       MoveWindow 0        $YRES_2 $XRES   $YRES_2 ;;
  -bl|-lb)  MoveWindow 0        $YRES_2 $XRES_2 $YRES_2 ;;
  -l)       MoveWindow 0        0       $XRES_2 $YRES   ;;
  -fs)      wmctrl -r :ACTIVE: -b toggle,maximized_horz,maximized_vert ;;
  *)        exit 1 ;;
esac
 
exit 0

