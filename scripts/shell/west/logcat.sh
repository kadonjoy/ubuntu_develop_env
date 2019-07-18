#!/bin/bash

#
# Description: This script will help to grab logcat log efficiently.
#

DEV_LIST=$(adb devices | sed -n '2,2p')

function useage_func()
{
cat << EOF
USEAGE:
        $0 <OPTION> <filename> <OPTION> <filename> ...

OPTIONS: 
        -hal
        -ker
EXAMPLE:
       $0 -hal x2.log -ker x2_ker.log
EOF
exit 0
}

function dmesg_func()
{
    KER_LOG_FILE=${1-ker.log}
    if [[ ! "$DEV_LIST" =~ ^$ ]]
    then
        adb shell dmesg > $KER_LOG_FILE
    else
        echo "No devices are found! Please plug in one valid device! FUNC: ${FUNCNAME[0]}"
        echo
        exit 1
    fi
    echo
}

function logcat_func()
{
    LOG_FILE=${1-hal.log}

    if [[ ! "$DEV_LIST" =~ ^$ ]]
    then
        adb logcat -c && adb logcat -G 20m && adb logcat| tee $LOG_FILE
        #adb logcat | tee $LOG_FILE
    else
        echo "No devices are found! Please plug in one valid device! FUNC: ${FUNCNAME[0]}"
        echo
        exit 1
    fi
}

function main()
{
    while [ ! -z $1 ]
    do
        case $1 in

            -hal)
                logcat_func $2
            ;;

            -ker)
                dmesg_func $2
            ;;
            *)
                useage_func
                echo
            ;;
        esac
        shift
    done
    exit 0
}
main $@
