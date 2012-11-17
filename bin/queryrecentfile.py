#!/usr/bin/python2
# -*- coding: utf8 -*-
#
# 查询
#
# Date:
# Author: mattmonkey <mattmonkey@sina.com>

from xdg.RecentFiles import *

import xml.dom.minidom, xml.sax.saxutils


def test():
	recent = RecentFiles()
	filename="/home/matt/.local/share/recently-used.xbel"
	recent.parse(filename)
	print(recent.getFiles())
	doc = xml.dom.minidom.parse(filename)
	print(doc)
	


if __name__ == "__main__":
	test()
