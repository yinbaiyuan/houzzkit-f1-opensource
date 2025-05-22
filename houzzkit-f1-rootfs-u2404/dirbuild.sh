#!/bin/bash

backup()
{
	find ./ubuntu-rootfs/ -type d -empty > emptydirlist.txt
	getfacl -R ./ubuntu-rootfs > permission.txt
    find ./ubuntu-rootfs/ -type l -exec test -e {} \; -printf "%m\0%u\0%g\0%p\0%l\0\n" > symlinks.txt 2>/dev/null
}

restore()
{
	for line in $(cat emptydirlist.txt)
	do
		mkdir -p $line
	done
	cp permission.txt ubuntu-rootfs/
	setfacl --restore=permission.txt
	rm ubuntu-rootfs/permission.txt

 	while IFS= read -r -d '' mode &&
          IFS= read -r -d '' user &&
          IFS= read -r -d '' group &&
          IFS= read -r -d '' linkpath &&
          IFS= read -r -d '' target; do
        # 检查用户/组是否存在
        if ! id -u "$user" >/dev/null 2>&1 || ! getent group "$group" >/dev/null 2>&1; then
            continue
        fi

        # 直接恢复权限和属主（无需重建链接）
        chmod --reference="$linkpath" "$linkpath" 2>/dev/null || chmod "$mode" "$linkpath"
        chown -h "$user:$group" "$linkpath"
    done < symlinks.txt

}

if [ "$1" == "backup" ]
then
	backup
elif [ "$1" == "restore" ]
then
	restore
else
	echo ""
	echo "Parameters were missing"
	echo "1'st parameter can be one of these: backup , restore "
	echo "backup   --Create empty directory list file and acl permission file"
	echo "restore  --Restore empty directory list file and acl permission file"
fi
