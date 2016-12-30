#!/bin/sh
DATE=$(date +%Y%m%d)
MOUNTH=`date +%m`
SAMBA_LOCAL_PATH="/home/xiashy/daily_samba/"
FASTBOOT="le_x10_fastboot*"
LOCAL_DAILY="/home/xiashy/dailyBuild"
TARGET_BUILD=""
if [ "`ls -A $SAMBA_LOCAL_PATH`" = "" ]; then
    printf "\nDaily_samba is not mounted.............\n"
    sudo mount -t cifs -o credentials=/home/xiashy/login.txt //imgrepo-cnbj-mobile.devops.letv.com/dailybuild/coral/cn/le_x10/daily/ ${SAMBA_LOCAL_PATH}
else
    printf "\nPrepare to download daily_build: date: %s--------------\n" $DATE
    ls -t $SAMBA_LOCAL_PATH$DATE
    if [ -d $SAMBA_LOCAL_PATH$DATE ]; then
        #TARGET_BUILD=$(ls $SAMBA_LOCAL_PATH$DATE | grep 'le.*bsp.*userdebug')
        TARGET_BUILD=$(ls $SAMBA_LOCAL_PATH$DATE | grep 'le.*leui.*userdebug')
	printf "\nbuild name: %s\n" $SAMBA_LOCAL_PATH$DATE"/"$TARGET_BUILD"/"$FASTBOOT	
	cd $LOCAL_DAILY && rm -rf $MOUNTH"/"$DATE && mkdir -p $MOUNTH"/"$DATE
	cp -r $SAMBA_LOCAL_PATH$DATE"/"$TARGET_BUILD"/"$FASTBOOT $LOCAL_DAILY"/"$MOUNTH"/"$DATE
	cd -
	printf "\n====================================================\n"
	printf "\n Finish daily build download \n"
	printf "\n====================================================\n"
    fi
fi
