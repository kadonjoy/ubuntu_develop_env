#!/bin/sh
OLD_CODE_BASE="main_leui_x10"
#CODE_BASE="leui_mainline"
CODE_BASE="N_X10"
CODE_PATH="/home/andbase/workspace/"
DAEMON_PATH=${CODE_PATH}${CODE_BASE}"/vendor/qcom/proprietary/mm-camera/mm-camera2/"
KERNEL_PATH=${CODE_PATH}${CODE_BASE}"/kernel/msm-3.18/"
LOCAL_PATH=$(pwd)

function delete_old ()
{
    cd ${CODE_PATH}
    if [ -d ${OLD_CODE_BASE} ]; then
        rm -rf ${OLD_CODE_BASE}
        printf "\n Removing anbandoned code%s\n" ${CODE_PATH}${LOCAL_PATH}
    fi
}

function download ()
{
    cd ${CODE_PATH}
    if [ -d ${CODE_BASE} ]; then
	    cd ${CODE_BASE}
	    rm -rf *
	    repo sync -cdj8 --no-tags
	    if [ $? -eq 0 ]; then
	        repo start $(date +%Y%m%d) --all
	        printf "\nrepo start \n"
	    else
	        printf "Failed to download main line code base-------------\n"
	    fi
    else
	    mkdir ${CODE_BASE}
	    cd ${CODE_BASE}
	    printf "\nrepo init \n"
        # x10 m
        #repo init -u dianar:msm8996/platform/letv/manifest.git -b letv_master -m letv/RUBY_LA2.0_DEV_BSP.xml --repo-url=dianar:tools/repo.git --no-repo-verify --reference=/le_data/android_m_mirror
        # X10 N
        repo init -u dianar:msm8996/platform/letv/manifest.git -b letv_master -m letv/CORAL_N_DEV_BSP.xml --repo-url=dianar:tools/repo.git --no-repo-verify --reference=/le_data/android_m_mirror
	    if [ $? -eq 0 ]; then
	        printf "\nrepo sync \n"
	        repo sync -cdj8 --no-tags
	        if [ $? -eq 0 ]; then
	            printf "\nrepo start \n"
                repo start $(date +%Y%m%d) --all
            else
                printf "Failed to download main line code base-------------\n"
            fi
        else
            printf "Failed to init main line repo-------------\n"
        fi
    fi
    printf "\ncongratulations to download main line code success!!!! date: %s\n" $(date %Y%m%d)
    cd ${CODE_PATH}
}

function setup_env()
{
    printf "\n setuping env for target %s\n" $1
    . build/envsetup.sh
    lunch $1
}

function build_images()
{
    if [ -d ${CODE_BASE} ]; then
        cd ${CODE_BASE}
	if [ -f make_letv.sh ]; then
	    ./make_letv.sh -p le_x10
	    if [ $? -eq 0 ]; then
		printf "\033[42;34m Main line code build successfully!!!!!!!\033[0m"	
		repo forall -c git reset --hard HEAD
	    else
		printf "\n Failed to build main line code!!!!!\n"
	    fi
	fi	
	cd ${CODE_PATH}
    fi
}

function create_tags()
{
    if [ -d ${DAEMON_PATH} ]; then
		echo "prepare to create tags/cscope " ${DAEMON_PATH}
	    cd ${DAEMON_PATH}
	    ctags -R *
  	    find ./ -type f > cscope.files
	    cscope -Rbq
	    cd ${CODE_PATH}
    fi

    if [ -d ${KERNEL_PATH} ]; then
		echo "prepare to create tags/cscope " ${KERNEL_PATH}
        cd ${KERNEL_PATH}
        ctags -R *
        find ./ -type f > cscope.files
        cscope -Rbq
        cd ${CODE_PATH}
    fi  
}

function main()
{
    printf "Welcome! downloading main line code base!!!!!!\n"
    delete_old
    download
    build_images
    create_tags
}

main
