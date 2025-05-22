# houzzkit-linux-rootfs

此仓库为HOUZZkit F1硬件项目的根文件系统构建工程，本项目目前可以构建出 Ubuntu 24.04 版本的根文件系统。

欢迎大家提交PR，让 HOUZZkit 硬件支持更多的Linux发行版。

### **注意**

>1. 不能放在虚拟机的共享文件夹中编译！
>2. SDK的编译环境建议使用 ubuntu 22.04 或更高版本。


### 构建环境依赖包

安装命令：
```bash
sudo apt-get install acl schroot qemu-user-static -y
```
若还有其他缺少的依赖包，请根据报错信息自行安装。

### 构建步骤

1. 请确认已经安装构建流程依赖工具。https://github.com/yinbaiyuan/ybashrc
2. 将本仓库 clone 到本地。
3. 执行 cf 命令，根据提示构建跟文件系统。