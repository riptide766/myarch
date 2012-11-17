#! /usr/bin/env bash
Xephyr -ac -br -noreset -screen 800x600 :1&
sleep 1
DISPLAY=:1.0 startxfce4 &
