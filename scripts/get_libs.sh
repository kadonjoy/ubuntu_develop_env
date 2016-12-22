#!/bin/bash

#
# Author: kadon
# USAGE:
#        AutoFlash.sh --get libmmcamera_ov13870 --flash libmmcamera_ov13870
#
source ./FONT_FORMAT.sh

VERSION="0.1"
TARGET="le_x10"
WORK_PATH="/letv/workspace/leui_mainline/"
SERVER_IP="10.142.130.25"
LIB_PATHES=("/system/vendor/lib/" "/system/lib/hw/" "/system/lib/")
IMAGES_LIST=("boot" "system" "userdata")
DEV_LIB_PATH=""

function usage_help ()
{
    printf $DEEP_GREEN_FONT"Android Auto Flash Shareed Lib Script Rev %s\n"$COLOR_EOF $VERSION
    echo "Usage is:
    AutoFlash <OPTION> <libname> <OPTION> <processname> ...

    AutoFlash script will help to get lib from remote host,
    and to flash them into device.

    -OPTIONS are:
        -g --get <libname>         - Get lib from remote host and flash lib into device
        -h --help                  - Print some help information
        -k --kill                  - The process name to be restarted
    -libname are some shared libs relates to camera.
        example: camera.msm8996
    -example:
        AutoFlash.sh -g libmmcamera_ov13870 -k media
    "
    exit 0
}

function flash()
{
    printf $DEEP_GREEN_FONT"... Enter Function: %s ...\n"$COLOR_EOF ${FUNCNAME[0]}
    if [ ! -z $1 ]; then
        printf $RED_FONT"LIB PATH: %s\n"$COLOR_EOF ${DEV_LIB_PATH}
        adb push ./libs/$1.so ${DEV_LIB_PATH}
    else
        printf $RED_FONT"Please input appropriate paramter(lib name)...\n"$COLOR_EOF
    fi
    printf $DEEP_GREEN_FONT"... Exit Function: %s ...\n"$COLOR_EOF ${FUNCNAME[0]}
}

function get_libs()
{
    printf $DEEP_GREEN_FONT"... Enter Function: %s ...\n"$COLOR_EOF ${FUNCNAME[0]}
    DEV_LIB_PATH=""
    if [ ! -z $1 ] ; then
        for lib_path in ${LIB_PATHES[@]}; do
            #printf $RED_FONT"LIB PATH: %s\n"$COLOR_EOF ${lib_path}
            scp andbase@${SERVER_IP}:${WORK_PATH}out/target/product/${TARGET}${lib_path}$1.so ./libs > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                DEV_LIB_PATH=${lib_path}
                break;
            fi
        done
    else
        printf $RED_FONT"Please input appropriate paramter(lib name)...\n"$COLOR_EOF
    fi
    printf $DEEP_GREEN_FONT"... Exit Function: %s ...\n"$COLOR_EOF ${FUNCNAME[0]}
}

function killcam()
{
    printf $DEEP_GREEN_FONT"... Enter Function: %s ...\n"$COLOR_EOF ${FUNCNAME[0]}
    if [ "x"${1} == "xmedia" ]; then
        printf $RED_FONT"PREPARE TO killing media server"$COLOR_EOF
        MEDIASERVER_PID=$(adb shell ps | grep 'mediaserver' | awk -F" " '{print $2}')
        adb shell kill -9 ${MEDIASERVER_PID}
        printf $RED_FONT$PROMPT$COLOR_EOF
        printf $RED_FONT"Killing mediaserver  process : %s\n"$COLOR_EOF ${MEDIASERVER_PID}
    elif [ "x"${1} == "xdaemon" ]; then
        DAEMON_PID=$(adb shell ps | grep 'mm-qcamera-daemon' | awk -F" " '{print $2}')
        adb shell kill -9 ${DAEMON_PID}
        printf $HIGH_LIGHT$GREEN_FONT$PROMPT$COLOR_EOF
        printf $GREEN_FONT"Killing camera daemon process : %s\n"$COLOR_EOF ${DAEMON_PID}
    fi
    printf $DEEP_GREEN_FONT"... Exit Function: %s ...\n"$COLOR_EOF ${FUNCNAME[0]}
}

function main()
{
    while [ ! -z "$1" ]; do
        case $1 in
            --get | -g)
                printf $RED_FONT$PROMPT$COLOR_EOF
                printf $RED_FONT"%s %s\n"$COLOR_EOF $1 $2
                get_libs $2
                flash $2
            ;;
            --kill | -k)
                printf $BLUE_FONT$PROMPT$COLOR_EOF
                printf $BLUE_FONT"%s %s\n"$COLOR_EOF $1 $2
                killcam $2
            ;;
            --help | -h)
                usage_help
            ;;
            *)
            ;;
         esac
         shift
    done
}

main "$@"
