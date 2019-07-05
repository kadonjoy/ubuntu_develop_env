#!/bin/bash
make -j3 -C kernel-3.18 O=/media/sdb1/MT6750T_F620_Baseline/alps/out/target/product/aeon6750_66_n/obj/KERNEL_OBJ ARCH=arm64 CROSS_COMPILE=/media/sdb1/MT6750T_F620_Baseline/alps/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android- ROOTDIR=/media/sdb1/MT6750T_F620_Baseline/alps

out/host/linux-x86/bin/acp -fp /media/sdb1/MT6750T_F620_Baseline/alps/out/target/product/aeon6750_66_n/obj/KERNEL_OBJ/arch/arm64/boot/Image.gz-dtb /media/sdb1/MT6750T_F620_Baseline/alps/out/target/product/aeon6750_66_n/obj/KERNEL_OBJ/arch/arm64/boot/Image.gz-dtb.bin

out/host/linux-x86/bin/acp -fp /media/sdb1/MT6750T_F620_Baseline/alps/out/target/product/aeon6750_66_n/obj/KERNEL_OBJ/arch/arm64/boot/Image.gz-dtb.bin out/target/product/aeon6750_66_n/kernel

out/host/linux-x86/bin/mkbootimg  --kernel out/target/product/aeon6750_66_n/kernel --ramdisk out/target/product/aeon6750_66_n/ramdisk.img --cmdline \"bootopt=64S3,32N2,64N2\" --base 0x40000000 --ramdisk_offset 0x05000000 --kernel_offset 0x00080000 --tags_offset 0x4000000 --board 1498719532 --os_version 7.0 --os_patch_level 2016-09-05 --kernel_offset 0x00080000 --ramdisk_offset 0x05000000 --tags_offset 0x4000000 --output out/target/product/aeon6750_66_n/boot.img
