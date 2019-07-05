#!/bin/bash
. ~/scripts/FONT_FORMAT.sh

ADB="adb wait-for-device "
PIC_PATH="/sdcard/DCIM/Camera/"
CAM_ACTIVITY="com.mediatek.camera/com.android.camera.CameraLauncher"
declare -i LAST_PIC_NUM
declare -i CUR_PIC_NUM
declare -i TOTAL_PICS

function useage()
{
cat << EOF
USEAGE:
    $0 <OPTION>
    $0 <OPTION> repeat-times
OPTIONS:
    -o|--open         open camera app
    -e|--exit         close camera app
    -c|--capture      capture one jpeg picture after opening camera
    -s|--stress       stress test camera function, e.g. switch mode, capture pictures...
    -singlemode       switch to single camera mode
    -dualmode         switch to dual camera mode
    -unlock           unlock the phone screen
EXAMPLE:
    $0 -o
    $0 -s 5
EOF
}

# capture function param is picture numbers you need
function capture()
{
    # default capture one jpeg
    pic_num=1
    if [ ! -z $1 ]; then
       pic_num=$1
    fi

    for (( i=0; i<$pic_num; i++))
    do
        LAST_PIC_NUM=`$ADB shell find ${PIC_PATH} -type f | wc -l`
        #echo "last pic number: $LAST_PIC_NUM"
        $ADB shell input keyevent 27
        while [ true ]
        do
            CUR_PIC_NUM=$($ADB shell ls ${PIC_PATH}*.jpg 2>/dev/null | wc -l)
            sleep 0.2
            #echo "cur pic num: $CUR_PIC_NUM"
            if (( $CUR_PIC_NUM == $LAST_PIC_NUM+1 )); then
                printf ${BLUE_FONT}"one jpeg is captured"${COLOR_EOF}
                let TOTAL_PICS=$TOTAL_PICS+1
                break;
            fi
        done
    done
}

function clean_pics()
{
    TOTAL_PICS=0
    LAST_PIC_NUM=0
    CUR_PIC_NUM=0
    $ADB shell rm ${PIC_PATH}*.jpg > /dev/null 2>&1
    $ADB shell rm /sdcard/*.jpg > /dev/null 2>&1
}

function switch_to_normal_mode()
{
    # tap coordinate
    # adb shell getevent -l | grep DOWN
    # /dev/input/event11: EV_ABS       ABS_MT_POSITION_X    000003E8
    # /dev/input/event11: EV_ABS       ABS_MT_POSITION_Y    0000003D
    # x: 1000(hex: 0x3e8) y: 61(hex: 0x3d)
    $ADB shell input tap 1000 61
}

function switch_to_stereo_mode()
{
    $ADB shell input tap 529 122
}

function exit_camera()
{
    $ADB shell input keyevent 4
}

function opencamera()
{
    $ADB shell am start -n ${CAM_ACTIVITY}
}

function switch_and_capture()
{
    opencamera
    for(( i=0; i<$1; i++ ))
    do
        capture
        switch_to_stereo_mode
        sleep 0.5
        capture
        switch_to_normal_mode
        sleep 0.5
    done
    exit_camera
}

function unlock()
{
    adb shell input keyevent 82
}

function main()
{
    printf ${RED_FONT}${PROMPT}${COLOR_EOF}
    while [ ! -z $1 ]
    do
        case $1 in
            -o|--open)
                opencamera
            ;;
            -e|--exit)
                exit_camera
            ;;
            -s|--stress)
                clean_pics
                switch_and_capture $2
                break
            ;;
            -c|--capture)
                capture $2
                break
            ;;
            -dualmode)
                switch_to_stereo_mode
                break
            ;;
            -singlemode)
                switch_to_normal_mode
                break
            ;;
            -unlock)
                unlock
                break
            ;;
            *|-h|--help)
                useage
                exit 0
            ;;
        esac
        shift
    done
    printf ${RED_FONT}"total pictures: %d\n"${COLOR_EOF} ${TOTAL_PICS}
    exit 0
}

main $@
