#!/usr/bin/env python  
#-#- coding:utf-8 -#-  

######################################################################################
#       Filename: optimize_cscopefiles.py
#    Description:   source file
#
#        Version:  1.0
#        Created: 2017-12-14 13:33:51
#
#       Revision:  initial draft;
######################################################################################
import os
import sys
import re

def main(argv):
    filter_keys = []
    with open(argv[0]) as fd:
        for line in iter(fd.readline, ''):
            list_tmp = re.findall(r"^.*mt6763",line)
            if len(list_tmp):
                str_tmp = "".join(list_tmp)
                str_tmp2 = str_tmp[:str_tmp.find('mt6763')]
                if str_tmp2 not in filter_keys:
                    filter_keys.append(str_tmp2)
    # print(filter_keys)
    for item in filter_keys:
        print(item)

if __name__ == "__main__":
    main(sys.argv[1:])


################################## END ##############################################/

