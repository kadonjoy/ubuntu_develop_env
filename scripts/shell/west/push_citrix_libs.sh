#!/bin/bash

LIB_PATH="/home/xiashy/share/output"
LOCAL_PATH=`pwd`

function generate_filelist()
{
    cd $LIB_PATH
    find ./ -name "*.so" -o -name "*.apk" -type f > toPushList.txt
}

function push_job()
{
    cd $LIB_PATH
    while read line
    do
        echo $line
        LIB_TARGET=`echo $line | cut -d / -f 6-`
        adb push $line $LIB_TARGET
    done < ${LIB_PATH}/toPushList.txt
    cd $LOCAL_PATH
}

function main()
{
    echo "#########################START############################"
    generate_filelist
    push_job
    echo "#########################FINISHED#########################"
}

main
