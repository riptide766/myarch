#!/bin/sh

ACTION=`zenity --width=200 --height=400 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE Shutdown FALSE Reboot FALSE LockScreen `

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
    zenity --question --text "Are you sure you want to poweroff?" && sudo poweroff
    ;;
  Reboot)
    zenity --question --text "Are you sure you want to reboot?" && sudo reboot
    ;;
  LockScreen)
    xlock
    ;;
  esac
fi
