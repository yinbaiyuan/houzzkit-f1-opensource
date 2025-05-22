#!/bin/bash

ROOTFS_FILE_NAME="ubuntu-rootfs.img"

create()
{
	if [ -f "$ROOTFS_FILE_NAME" ];then
		rm $ROOTFS_FILE_NAME
	fi
	dirsizestr=$(du -s ubuntu-rootfs/)
	dirsize=${dirsizestr%%ub*}
	dirsizeint=$[dirsize / 1024 + dirsize / 10240] 
	dd if=/dev/zero of=$ROOTFS_FILE_NAME bs=1M count=$dirsizeint
	mkfs.ext4 $ROOTFS_FILE_NAME
	mkdir ubuntu-rootfs-mnt
	mount -o loop $ROOTFS_FILE_NAME ubuntu-rootfs-mnt/
	cp -rfp ubuntu-rootfs/* ubuntu-rootfs-mnt
	umount ubuntu-rootfs-mnt/
	rm -rf ubuntu-rootfs-mnt
	chmod 766 $ROOTFS_FILE_NAME
}



if [ "$1" == "chroot" ]
then
	mount -t proc /proc ubuntu-rootfs/proc
	mount -t sysfs /sys ubuntu-rootfs/sys
	mount -o bind /dev ubuntu-rootfs/dev
	mount -o bind /dev/pts ubuntu-rootfs/dev/pts
	chroot ubuntu-rootfs/
elif [ "$1" == "exit" ]
then
	umount ubuntu-rootfs/proc
	umount ubuntu-rootfs/sys
	umount ubuntu-rootfs/dev/pts
	umount ubuntu-rootfs/dev
elif [ "$1" == "make" ]
then
	create
else
	echo ""
	echo "Parameters were missing"
	echo "1'st parameter can be one of these: chroot , exit , make"
	echo "chroot --Change root directory to ubuntu-rootfs"
	echo "exit   --Umount some directory after exit from ubuntu-rootfs"
	echo "make   --Create $ROOTFS_FILE_NAME"
fi
