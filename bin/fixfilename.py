#!/usr/bin/python2
# -*- coding: utf8 -*-
#
# 修复因浏览器下载中文文件而造成的文件名编码错误
#
# Date:
# Author: mattmonkey <mattmonkey@sina.com>



from sys import argv
from urllib import unquote
from os import rename
from os.path import isfile
from os.path import join
from os.path import basename
from os.path import dirname

def fix_url_filename(filelist,encoding="gbk"):
	for filename in filelist:
		if isfile(filename) :
			fixedname = basename(filename)
			fixeddir = dirname(filename)
			fixedname = join(fixeddir,unquote(fixedname).decode(encoding))
			print "%s --> %s" % (filename,fixedname)
			rename(filename,fixedname)

if __name__ == "__main__":
	fix_url_filename(argv[1:])
