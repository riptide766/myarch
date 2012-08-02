#!/bin/sh
# first of all, the standard method definition
function MoveWindow ()
{
  DISPLAY=$DISPLAY wmctrl -r :ACTIVE: -b remove,maximized_horz,maximized_vert
  DISPLAY=$DISPLAY wmctrl -r :ACTIVE: -b remove,fullscreen
  DISPLAY=$DISPLAY wmctrl -r :ACTIVE: -e 0,$1,$2,$(($3 - $BORDER_RIGHT)),$(($4 - $BORDER_BOTTOM))
}
 
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
