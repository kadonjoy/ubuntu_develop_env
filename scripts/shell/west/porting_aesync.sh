#!/bin/bash
#
# author: shouyong.xia
#

DCS_ROOT_PATH="/home/xiashy/work/Dual_Camera_Solution_platform/"
DCS_BUILD_PATH="src/StereoVision/jni"
DCS_SRC_PATH="src/PlatformDCS/MTK/MT6755s/SangFei/AESync"
DCS_TARGET_PATH="src/StereoVision/libs"
ANDROID_PROJECT_ROOT="/media/sdb1/Westalgo_Project_TCL_A7A_6/"
ANDROID_WESTALGO_32_PATH="vendor/mediatek/proprietary/hardware/mtkcam/aaa/source/mt6763/westalgo_3Async"
ANDROID_WESTALGO_64_PATH="vendor/mediatek/proprietary/hardware/mtkcam/aaa/source/mt6763/westalgo_3Async/arm64"
LOCAL_WORK_PATH=$(pwd)

# build ae sync libs
function build_libs()
{
    echo "enter func: ${FUNCNAME[0]}"
    for file in $(find ${DCS_ROOT_PATH}${DCS_SRC_PATH} -type f )
    do
        touch $file
    done
    if [ -d ${DCS_ROOT_PATH}${DCS_BUILD_PATH} ]; then
        echo "dcs build directoty is exist\n"
        cd ${DCS_ROOT_PATH}${DCS_BUILD_PATH}
        ndk-build -j2
    fi
}

# copy ae sync libs to android directoty
function copy_lib_to_android()
{
    echo "enter func: ${FUNCNAME[0]}"
    test -d ${ANDROID_PROJECT_ROOT}${ANDROID_WESTALGO_PATH}
    if [ $? != 0 ]; then
        exit 1
    fi

    if [ -d ${DCS_ROOT_PATH}${DCS_TARGET_PATH} ]; then
        #echo "dcs target directoty is exist"
        cd ${DCS_ROOT_PATH}${DCS_TARGET_PATH}
        for dir in $(ls)
        do
            if [ x$dir = x"armeabi-v7a" ]; then
                if [ ! -z `ls -A $dir` ]; then
                    echo "32 bit"
                    cp $dir/* ${ANDROID_PROJECT_ROOT}${ANDROID_WESTALGO_32_PATH}
                fi
            else
                if [ ! -z `ls -A $dir` ]; then
                    echo "64 bit"
                    cp $dir/* ${ANDROID_PROJECT_ROOT}${ANDROID_WESTALGO_64_PATH}
                fi
            fi
        done
    fi
}

# rebuild 3a libs after updating ae sync libs
function build_camera_hal()
{
    echo "PID: $PPID"
    cd ${ANDROID_PROJECT_ROOT} 
    source build/envsetup.sh
    lunch A70AXLTMO-userdebug
    rm out.log
    mmm vendor/mediatek/proprietary/hardware/mtkcam/aaa/source/mt6763/westalgo_3Async -j2 > out.log
    #for file in $(find ./vendor/mediatek/proprietary/hardware/mtkcam/aaa/source/mt6763/ -type f)
    #do
        #touch $file
    #done
    touch ./vendor/mediatek/proprietary/hardware/mtkcam/aaa/source/mt6763/Sync3A.cpp
    mmm vendor/mediatek/proprietary/hardware/mtkcam -j2 >> out.log
    cd ${LOCAL_WORK_PATH}
}

function push_to_device()
{
    cd ${ANDROID_PROJECT_ROOT}
    ./push_libs.sh 
}

function main()
{
    echo "enter func: ${FUNCNAME[0]}"
    echo "MAIN PID: $$"
    build_libs
    copy_lib_to_android
    ( build_camera_hal )&
    buildPID=$!
    wait $buildPID
    #( push_to_device )&
    #pushPID=$!
    #wait $pushPID
    echo "exit func: ${FUNCNAME[0]}"
}

main
