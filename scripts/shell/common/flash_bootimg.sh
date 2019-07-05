#!/bin/sh
SERVER_IP="10.142.130.25"
#ANDROID_ROOT="/home/andbase/workspace/leui_mainline/"
ANDROID_ROOT="/home/andbase/workspace/X10_N_UI/"
TARGET="le_x10"
#SERVER_IP="10.142.132.221"
#ANDROID_ROOT="/letv/workspace/work/Android_N/"
#TARGET="le_x2"
if [ ! -z $# ] ;then
adb reboot bootloader
for i in $@; do
	if [ ! -f "$i.img" ]; then
 		printf "Downloading image: %s\n" ${ANDROID_ROOT}$i.img
		#sudo fastboot erase $i;
		scp andbase@${SERVER_IP}:${ANDROID_ROOT}out/target/product/${TARGET}/$i.img ./
        sudo fastboot flash $i $i.img
	else
        printf "The %s image exists already\n" $i
		sudo fastboot erase $i
		sudo fastboot flash $i $i.img
	fi
done
sudo fastboot reboot
printf "Flash work is finished, rebooting......\n"
else
	echo "error argument"
fi
