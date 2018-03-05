#!/usr/bin/python
# -*- mode: python; coding: utf-8 -*-

# Copyright (C) 2014, Oscar Acena <oscaracena@gmail.com>
# This software is under the terms of Apache License v2 or later.

from __future__ import print_function

import sys
import os
import commands
import string


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage:{} <addr>".format(sys.argv[0]))
	print("example: python {} 6C:5A:B5:7E:9E:9B".format(sys.argv[0]))
        sys.exit(1)

    result = commands.getoutput('gatttool -i hci0 -b '+sys.argv[1]+' --char-read -a 0x0020')
    if result.rfind('connect error: Connection refused') == 0:
    		print("%s" %(result))
    		sys.exit(1)
    if result.rfind('connect: No route to host') == 0:
    		print("%s" %(result))
    		sys.exit(1)
    print("temperature: %d.%d\nhumidity: %d%%" %(int(result[45:47],16),int(result[48:50],16),int(result[51:53],16)))
    print("Done.")
