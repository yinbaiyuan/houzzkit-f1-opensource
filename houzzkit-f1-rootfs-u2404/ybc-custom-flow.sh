#!/bin/bash

. $HOME/ybashrc/command-common.sh

moveRootFsImg()
{
    if [ ! -f "ubuntu-rootfs.img" ];then
        echoRed "ubuntu-rootfs.img文件不存在！"
        exit 1
    fi
    cmdExecute "sudo mv ubuntu-rootfs.img ../houzzkit-f1-bsp-k610/rootfs/"
}

makeRootFs()
{
    cmdExecute "sudo ./rfsbuild.sh make"

    commandInput "Yes no" "要移动根文件系统镜像到bsp目录吗？"
    subResult="$GLOBAL_INPUT_RESULT"
    case $subResult in
        Yes ) 
            moveRootFsImg
            ;;
        no ) 
            echoYellow "未移动根文件系统镜像！"
            ;;
        * ) 
            echoRed "命令错误！"
            exit 1
    esac
}

restoreDirectory()
{
    commandInput "Yes skip cancel" "是否恢复 文件夹系统空目录结构和所有文件的权限信息？"
    result="$GLOBAL_INPUT_RESULT"
    case $result in
        Yes ) 
            cmdExecute "./dirbuild.sh restore"
            makeRootFs
            ;;
        skip ) 
            echoYellow "跳过恢复操作！"
            makeRootFs
            ;;
        skip ) 
            echoYellow "操作退出！"
            exit 1
            ;;
        * ) 
            echoRed "命令错误！"
            exit 1
    esac
}

GLOBAL_CURRENT_USER="jenkins"

restorePermissions()
{
    GLOBAL_CURRENT_USER=$(stat -c %U ./)
    touch permissions.lock
    cmdExecute "sudo ./dirbuild.sh restore"
}

backupPermissions()
{
    if [ "$1" != "skip" ];then
        cmdExecute "sudo ./dirbuild.sh backup"
    fi
    cmdExecute "sudo chown -R $GLOBAL_CURRENT_USER:$GLOBAL_CURRENT_USER ubuntu-rootfs/"
    rm permissions.lock
}


customFlowStart()
{
    commandInput "Make chroot nfs move" "请输入命令" "创建根文件系统镜像 进入根文件系统 开启kernel挂载模式 移动根文件系统镜像"
    result="$GLOBAL_INPUT_RESULT"
    echo ""
    case $result in
        Make ) 
            restorePermissions
            makeRootFs
            backupPermissions skip
            ;;
        chroot ) 
            restorePermissions
            cmdExecute "sudo ./rfsbuild.sh chroot"
            cmdExecute "sudo ./rfsbuild.sh exit"
            backupPermissions
            ;;
        nfs )
            restorePermissions
            cmdExecute "cd ubuntu-rootfs/"
            cmdExecute "su root"
            cmdExecute "cd .."
            backupPermissions
            ;;
        move )
            moveRootFsImg
            ;;
        * ) 
            echoRed "命令错误！"
            exit 1
    esac
}

buildAction()
{
    restorePermissions
    cmdExecute "sudo ./rfsbuild.sh make"
    backupPermissions skip
}

cpToBspAction()
{
    moveRootFsImg
}

main() 
{
    commandArr="Build cpToBsp make chroot nfs move"
    commandDesc="生成根文件系统镜像 移动根文件系统镜像到bsp目录 创建根文件系统镜像 进入根文件系统 开启kernel挂载模式 移动根文件系统镜像"
    inputQuestion="请输入流程名称"
    command=""
    if [ -z $1 ];then  
        commandInput "$commandArr" "$inputQuestion" "$commandDesc"
        command="$GLOBAL_INPUT_RESULT"
    else
        command=${1,,}
    fi
    case $command in
        build ) 
            buildAction
            ;;
        cptobsp ) 
            cpToBspAction
            ;;
        make ) 
            restorePermissions
            makeRootFs
            backupPermissions skip
            ;;
        chroot ) 
            restorePermissions
            cmdExecute "sudo ./rfsbuild.sh chroot"
            cmdExecute "sudo ./rfsbuild.sh exit"
            backupPermissions
            ;;
        nfs )
            restorePermissions
            cmdExecute "cd ubuntu-rootfs/"
            cmdExecute "su root"
            cmdExecute "cd .."
            backupPermissions
            ;;
        move )
            moveRootFsImg
            ;;
        * ) 
            echoRed "[ERROR] 流程名称错误!"
            exit 1
    esac
}

main $@