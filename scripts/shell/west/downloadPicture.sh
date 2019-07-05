#!/bin/sh
#rm ./*nv12
for i in $(adb shell ls /sdcard/*.yuv)
do
echo $i
$(adb pull $i )
done
#adb root
#adb remount
#adb shell rm /data/*nv12
