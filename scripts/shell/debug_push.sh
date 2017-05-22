#!/bin/sh
# Firstly please touch update_flag file in system manually.

useage()
{
	echo "useage:$0 input the time less than ??"
	echo "input the push dir"
}
adb wait-for-device
adb root
sleep 2
adb wait-for-device
adb remount
for f in `find ./system/ -newer update_flag -name *.so |grep -v test`;
do
    echo $f;
    adb push $f $f;
done
#adb push push /system/vendor/lib/
touch update_flag
sleep 2
adb shell sync
adb shell ps |grep mm-qcamera-daemon   
adb shell ps |grep mm-qcamera-daemon |cut -f 5 -d' '|xargs adb shell kill -9
adb shell sync
adb shell ps |grep mediaserver
adb shell ps |grep mediaserver |cut -f 6 -d' '|xargs adb shell kill -9
sleep 0.2
adb shell ps |grep mediaserver
echo "success to push *.so."
