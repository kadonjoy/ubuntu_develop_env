#!/bin/bash
#set -e
LOCAL_PATH=$(pwd)
REPO_PATH="/media/sdb1/A7A-6_O/Westalgo_Project_TCL_A7A_6"
DATE_STR=$(date +%Y%m%d)

function clear_repository()
{
    cd ${REPO_PATH}
    git diff > ${DATE_STR}.diff
    git reset --hard HEAD
    git pull --rebase
    #git apply ${DATE_STR}.diff
}

function build_images()
{
    cd ${REPO_PATH}
    if [ -f ./makeTcl ]; then
        export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"
        ./prebuilts/sdk/tools/jack-admin kill-server
        ./prebuilts/sdk/tools/jack-admin start-server
        ./makeTcl -t A70AXLTMO JRD_PREBUILD_ENABLE=true TARGET_BUILD_VARIANT=userdebug 2>&1 | tee ${DATE_STR}_out.log
    fi
}

function main()
{
    clear_repository
    build_images
    echo "successed to build!" >> ${DATE_STR}_out.log
    cd ${LOCAL_PATH}
}

main $@
#gnome-terminal --maximize --title="building a7a-6" -e ~/scripts/westalgo/build_a7a.sh $@
