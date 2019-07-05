#!/usr/bin/env python  
#-#- coding:utf-8 -#-  

######################################################################################
#       Filename: mtklogger.py
#    Description:   source file
#
#        Version:  1.0
#        Created:  2017-11-21 14:31:55
#        Author:   shouyong.xia
#
#       Revision:  initial draft;
######################################################################################
import os
import sys
import subprocess
import platform

def adb_devices():
    return subprocess.Popen(
                'adb devices'.split(),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE).communicate()[0]

def get_serial_number(devices):
    serial_nos = []
    filters = ['list', 'of', 'device', 'devices', 'attached']
    for item in devices.split():
        if item.lower() not in filters:
            serial_nos.append(item)
    return serial_nos

def main(args):
    start_mtklogger_activity = "adb shell am start -n com.mediatek.mtklogger/com.mediatek.mtklogger.MainActivity"
    start_mobilelog = "adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name start --ei cmd_target 1"
    stop_mobilelog = "adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name stop --ei cmd_target 1"
    enable_taglog = "adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name switch_taglog --ei cmd_target 1"
    clear_mtklog = "adb shell rm -rf /sdcard/mtklog/*"
    get_log_linux = "adb pull /sdcard/mtklog/mobilelog ./mobilelog"
    get_log_windows = "adb pull /sdcard/mtklog/mobilelog" + ' ' + os.path.join(sys.path[0], "mtkmobilelog")
    devices = adb_devices()
    # print(devices)
    serial_nos = get_serial_number(devices)
    print "device serial_nos:"
    print serial_nos
    if args[0] == "on":
        # clear mtklog
        p0 = subprocess.Popen(clear_mtklog.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p0.wait()
        # launch mtklogger activity
        p1 = subprocess.Popen(start_mtklogger_activity.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p1.wait()
        # enable tag log 
        p2 = subprocess.Popen(enable_taglog.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p2.wait()
        # start mobile log fetch
        p3 = subprocess.Popen(start_mobilelog.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p3.wait()
    elif args[0] == "off":
        p5 = subprocess.Popen(stop_mobilelog.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        p5.wait()
        if platform.system() == "Linux":
            p6 = subprocess.Popen(get_log_linux.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        elif platform.system() == "Windows":
            p6 = subprocess.Popen(get_log_windows.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        else:
            print "unknow operating system"
        print(p6.communicate()[1])
        p6.wait()

if __name__ == "__main__":
    main(sys.argv[1:])

################################## END ##############################################/

