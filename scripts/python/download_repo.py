#!/usr/bin/python

from __future__ import division
import re
import os
"""在android root目录下使用该脚本，
下载所有external/目录下的仓库"""

if __name__ == "__main__":
    r = r'name=\"(ruby/platform/external/.*)\" path='
    fileHandler = open('.repo/manifest.xml')
    strProject = fileHandler.read()
    extList = re.findall(r,strProject)
    # print extList
    for i in range(len(extList)):
        print "[ %d%% ]" % int(i*100/len(extList))
        os.system('repo sync -cj8 --no-tags %s' % extList[i])
