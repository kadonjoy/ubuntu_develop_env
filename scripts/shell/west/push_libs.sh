#!/bin/sh
ANDROID_PRODUCT_OUT="/media/sdb1/MT6737_F530_Baseline/alps/out/target/product/aeon6737m_65_d_n"
adb_wait()
{
adb root
adb remount
adb wait-for-device
if [[ $? -eq 0 ]]
then
	printf "pushing ......\n"
else
	printf "there is no device\n"
	exit -1
fi
}

remount_system()
{
adb root
if [[ $? -eq 0 ]]
then
	adb remount
	if [[ $? -eq 0 ]]
	then
		printf "fail to adb remount\n"
		cd ${ANDROID_HOST_OUT}/bin/
		adb disable-verity
		adb reboot
		adb wait-for-device
		adb root
		adb remount
		cd -
	fi
fi
}

push_libs()
{
    tmp=" "
    tmpstr=" "
    sed -i 's/^\[.*\] //g' ./out.log
	for str in $(grep 'Install:' ./out.log); do
		tmp=$(echo $str | sed -e 's/out\/target\/product\/aeon6737m_65_d_n//g' \
			-e 's/^Install:/ /g' \
			-e '/^$/d')
		if [ "$tmp" != " " ]
		then
			#printf "xiashy\n"
			tmpstr=${ANDROID_PRODUCT_OUT}${tmp}
			echo $tmpstr
			adb push $tmpstr $tmp
#		else
#			printf "str is null\n"
		fi
		tmp=" "
		tmpstr=" "
	done
}

#adb_wait
#remount_system
push_libs
