#!/bin/bash
# -*- coding: utf8 -*-
#
# 备份软件包到/home/repo
# Date:
# Author: mattmonkey <mattmonkey@sina.com>

sour="/var/cache/pacman/pkg/"
dist="/home/repo/"
log="/home/repo/LOG"
echo -e "\n`/bin/date`\n" >> "$log"
rsync -uva "$sour" "$dist" >> "$log" 2>&1

