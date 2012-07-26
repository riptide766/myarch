#!/bin/bash
 
case $1 in
	thunar)
		REXP="Thunar.Thunar"
		CMD="thunar "
		;;
	gvim)
		REXP="gvim.Gvim"
		CMD="gvim -f"
		;;
    emacs)
        REXP="Emacs -x"
        CMD="emacs"
        ;;
    browser)
        REXP="Chromium -x"
        CMD="chromium-browser"
        ;;
    firefox)
        REXP="navigator.Firefox"
        CMD="firefox"
        ;;
    thunderbird)
        REXP="Thunderbird"
        CMD="thunderbird"
        ;;
    nautilus)
        REXP="nautilus.Nautilus"
        CMD="nautilus"
        ;;
    terminator)
        REXP="terminator.Terminator"
        CMD="terminator"
        ;;
    *)
        exit
        ;;
esac
 
wmctrl -a $REXP -x && exit
exec $CMD &
