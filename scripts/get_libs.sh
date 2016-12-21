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
    AutoFlash <OPTION> <libname> <OPTION> <libname> ...

    AutoFlash script will help to get lib from remote host,
    and to flash them into device.

    -OPTIONS are:
        --get <libname>         - Get lib from remote host
        --flash <libname>       - Flash the lib into android device
        --help                  - Print some help information 
    -libname are some shared libs relates to camera.
        example: camera.msm8996
    -example:
        AutoFlash.sh --get libmmcamera_ov13870 --flash libmmcamera_ov13870
    "
    exit 0
}

function flash()
{
    printf $RED_FONT"Enter flash...\n"$COLOR_EOF
    if [ ! -z $1 ]; then
        printf $RED_FONT"LIB PATH: %s\n"$COLOR_EOF ${DEV_LIB_PATH}
        adb push ./libs/$1.so ${DEV_LIB_PATH}
    else
        printf $RED_FONT"Please input appropriate paramter(lib name)...\n"$COLOR_EOF
    fi
    printf $RED_FONT"Exit flash...\n"$COLOR_EOF
}

function get_libs()
{
    printf $RED_FONT"Enter get_libs...\n"$COLOR_EOF
    DEV_LIB_PATH=""
    if [ ! -z $1 ] ; then
        for lib_path in ${LIB_PATHES[@]}; do
            #printf $RED_FONT"LIB PATH: %s\n"$COLOR_EOF ${lib_path}
            scp andbase@${SERVER_IP}:${WORK_PATH}out/target/product/${TARGET}${lib_path}$1.so ./libs
            if [ $? -eq 0 ]; then
                DEV_LIB_PATH=${lib_path}
                break;
            fi
        done
    else
        printf $RED_FONT"Please input appropriate paramter(lib name)...\n"$COLOR_EOF
    fi
    printf $RED_FONT"Exit get_libs...\n"$COLOR_EOF
}

function main()
{
    while [ ! -z "$1" ]; do
        case $1 in
            --get)
                printf $RED_FONT$PROMPT$COLOR_EOF
                printf $RED_FONT"%s %s\n"$COLOR_EOF $1 $2
                get_libs $2
            ;;
            --flash)
                printf $BLUE_FONT$PROMPT$COLOR_EOF
                printf $BLUE_FONT"%s %s\n"$COLOR_EOF $1 $2
                flash $2
            ;;
            --help)
                usage_help
            ;;
            *)
            ;;
         esac
         shift
    done
}

main "$@"
