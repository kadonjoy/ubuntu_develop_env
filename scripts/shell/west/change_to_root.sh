#!/bin/bash
MAIN_MK_FILE="build/core/main.mk"
MAIN_BACKUP_FILE="main_backup.mk"

function modify_makefile()
{
    sed -i '/user_variant),*user)/a\    ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=1' ${MAIN_MK_FILE}
    sed -i '/user_variant),*userdebug)/a\    ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0' ${MAIN_MK_FILE}
    # 此命令巧妙之处在把文件倒转删除匹配行的下一行，然后再倒转回去
    tac ${MAIN_MK_FILE} | sed -ne 'p;/security.perf_harden/n' | tac > ${MAIN_BACKUP_FILE}
    cp ${MAIN_BACKUP_FILE} ${MAIN_MK_FILE}
    rm ${MAIN_BACKUP_FILE} > /dev/null 2>&1
}

modify_makefile
