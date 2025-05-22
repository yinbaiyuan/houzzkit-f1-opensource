[TOC]

# Rockchip RealTime Linux 实时性系统环境搭建
**产品版本**

| 芯片名称 | 内核版本                 |
| -------- | ------------------------ |
| RK3562   | kernel-5.10              |
| RK3568   | kernel-4.19，kernel-5.10 |
| RK3588   | kernel-5.10              |

## 一、PREEMPT_RT

（1）目前kernel-5.10分为两个版本，一个是5.10.160版本，对应补丁位于PREEMPT_RT/kernel-5.10/5.10.160。一个是5.10.198版本，对应补丁位于PREEMPT_RT/kernel-5.10/5.10.198。确认内核的方法为查看kernel/Makefile，如果sublevel为160，则应打上5.10.160的补丁，反之应打上5.10.198的补丁。

```makefile
  # SPDX-License-Identifier: GPL-2.0
  VERSION = 5
  PATCHLEVEL = 10
  SUBLEVEL = 160
  ...
```

（2）kernel-4.19 base点：

```c
commit a46049b85fd7e5e9f58701fbc387e5b4d3793f98 (rk/develop-4.19, m/master)
Author: Shunhua Lan <lsh@rock-chips.com>
Date:   Mon Feb 6 16:45:53 2023 +0800

media: i2c: lt6911uxc: create hdmirx_class devices

Signed-off-by: Shunhua Lan <lsh@rock-chips.com>
Change-Id: I61c840d812b88554aa154bfc7c1435e1345d287e
```

####   a). kernel打上补丁：

kernel 5.10:

​    `0001-patch-5.10.180-rt89.patch-on-rockchip-base-cae91899b.patch`
​    `0002-patch-5.10.180-rt89.patch-fix-runtime-error-on-rockc.patch`
​    `0003-arm64-configs-optimize-latency-for-PREEMPT_RT.patch`

kernel 4.19:

​    `0001-patch-4.19.232-rt104.patch-on-rockchip-base-09f54150.patch` 
​    `0002-patch-4.19.232-rt104.patch-fix-runtime-error-on-rock.patch` 
​    `0003-arm64-configs-add-rockchip_rt.config-for-PREEMPT_RT_4.19.patch`

####   b). 编译命令（以RK3588为例）：

```bash
$ cd $sdk/kernel/
$ export CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
$ make ARCH=arm64 rockchip_linux_defconfig rockchip_rt.config 
$ make ARCH=arm64 rk3588-evb1-lp4-v10-linux.img -j8
```

####   c). 烧录boot.img 并测试实时性性能

   使用cyclictest测试

```bash
$ cyclictest -m -c 0 -p99 -t -D 12h
```

## 二、XENOMAI

（1）kernel-5.10 base点：

```c
commit cae91899b67b031d95f9163fe1fda74fbe0d931a (tag: linux-5.10-stan-rkr1)
Author: Lan Honglin <helin.lan@rock-chips.com>
Date:   Wed Jun 7 15:01:26 2023 +0800  
ARM: configs: rockchip: rv1106 enable sc301iot for battery-ipc

Signed-off-by: Lan Honglin <helin.lan@rock-chips.com>
Change-Id: Ib844385bfd58f73eaa5f4e415d598d1f983fa4cd
```

（2）kernel 4.19 base点：

```c
commit 09f54150e89f68cece4ba5af11a1fd07dfa35aa3 (rk/develop-4.19)
Author: Zhihuan He <huan.he@rock-chips.com>
Date:   Wed Aug 23 11:37:06 2023 +0800

arm64: configs: rockchip_linux_defconfig: enable rockchip edac

Signed-off-by: Zhihuan He <huan.he@rock-chips.com>
Change-Id: Ie3c9b6150e792cb1bca395f630bf35da82168f2b
```

  (3) buildroot需要更新，且包含这个补丁：

```c
commit 4bd33add016f393c8ed62fca0ace075755465928
Author: ZhiZhan Chen <zhizhan.chen@rock-chips.com>
Date:   Wed Jul 19 20:03:59 2023 +0800

    xenomai: add rockchip support
    
    Fix compilation errors with clang version 12.0.5
    
    Change-Id: Ib5f7971495f339abce2613a1d6d6d0cbfce35b37
    Signed-off-by: Liang Chen <cl@rock-c 9hips.com>
```

####   a).在kernel上打上xenomai补丁：

kernel 5.10:

​     `dovetail-core-5.10.161-on-rockchip-base-cae91899b.patch`

kernel 4.19:

​	`0001-ipipe-core-4.19.209-on-rockchip-base-09f54150e89f.patch`

####   b).buildroot打开XENOMAI配置，并编译rootfs.img：

```bash
BR2_PACKAGE_XENOMAI=y
BR2_PACKAGE_XENOMAI_3_2=y
BR2_PACKAGE_XENOMAI_VERSION="v3.2.2"
BR2_PACKAGE_XENOMAI_COBALT=y
BR2_PACKAGE_XENOMAI_TESTSUITE=y
BR2_PACKAGE_XENOMAI_ADDITIONAL_CONF_OPTS="--enable-demo"
```

####   c).把xenomai系统打到内核上：

```bash
$ cd $sdk/kernel
$ ../buildroot/output/rockchip_rk3588/build/xenomai-v3.2.2/scripts/prepare-kernel.sh --arch=arm64
```

####   d).编译内核，并烧录boot.img  rootfs.img

  编译命令：

kernel 5.10(以RK3588为例)：

```bash
$ cd $sdk/kernel
$ export CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
$ make ARCH=arm64 rockchip_linux_defconfig rk3588_linux.config
$ make ARCH=arm64 LT0=none LLVM=1 LLVM_IAS=1 rk3588-evb1-lp4-v10-linux.img -j17
```

kernel 4.19(以RK3568为例)：

```bash
$ cd $sdk/kernel
$ export CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
$ make ARCH=arm64 rockchip_linux_defconfig
$ make ARCH=arm64 rk3568-evb1-ddr4-v10-linux.img -j17
```
####   e)测试实时性能

​    (1).校准latency

```bash
 $ echo 0 > /proc/xenomai/latency 
```

​    (2) 使用cyclictest测试

```bash
 $ ./usr/demo/cyclictest -m -n -c 0 -p99 -t -D 12h
```

### 三、注意事项

#### （1）RK3568 需要使用RT版本的BL31,实时性能更好

​		a）rkbin需要更新到最新，且包含这个补丁：

```c
commit c2df62ac1758a21cff946ea5d39a77a769b2052e (HEAD -> master, origin/master, origin/HEAD)
Author: Liang Chen <cl@rock-chips.com>
Date:   Thu Nov 2 16:33:14 2023 +0800

    rk3568: bl31 rt: update version to v1.02

    build from:
            30c17915b rk3568: optimize RT latency

    update feature:
            30c17915b rk3568: optimize RT latency
            4a7bee092 plat: rk3588: otp: support to read secure otp
            ...
            e7c694291 plat: rk3568: get l3 partition parameter from tags by default
            ...

            patch on gerrit: I05955dace13ec323d894583e664c128e8b582fe8 (Change-Id)

    Change-Id: I6a74ccc547624837872fbe930fec4c76a9012776
    Signed-off-by: Liang Chen <cl@rock-chips.com>
```

​		b) 编译命令：

```shell
$ cd $sdk/uboot 
$ ./make.sh rk3568-rt
```

​    	c) 烧录miniloader.bin 以及uboot.img。

开机过程会有cache_write_streaming_cfg相关打印，说明已经使用rt版本的bl31.

```C
INFO:    Preloader serial: 2
NOTICE:  BL31: v2.3():v2.3-662-g30c17915b-dirty:cl, fwver: v1.02
NOTICE:  BL31: Built : 16:39:01, Nov  2 2023
INFO:    GICv3 without legacy support detected.
INFO:    ARM GICv3 driver initialized in EL3
INFO:    pmu v1 is valid 220114
INFO:    cache_write_streaming_cfg:0 2808bc00 PCTL:L3-7 L1-5 WSCTL:L1-0 L3-1
INFO:    cache_write_streaming_cfg:0 2808e400 PCTL:L3-1 L1-7 WSCTL:L1-0 L3-1
INFO:    l3 cache partition cfg-8421
INFO:    dfs DDR fsp_param[0].freq_mhz= 1560MHz
INFO:    dfs DDR fsp_param[1].freq_mhz= 324MHz
INFO:    dfs DDR fsp_param[2].freq_mhz= 528MHz
INFO:    dfs DDR fsp_param[3].freq_mhz= 780MHz
INFO:    Using opteed sec cpu_context!
INFO:    boot cpu mask: 0
INFO:    BL31: Initializing runtime services
INFO:    BL31: Initializing BL32
```

#### （2）RK3568上让实时任务独占实时核心，提高实时性的做法

##### 		a)  cache 分片

ARM Cortex-A55 架构上面支持对L3空间进行划分，原理为：Cortex-A55 L3 mem空间划分为4块，可以配

置每个CPU使用4块L3中的哪几块，在rkbin中的RKBOOT/RK3568MINIALL.ini文件进行配置：

```c
[BOOT1_PARAM]

WORD_3=0xc333
```

WORD_3的值0xc333表示（以P0、P1、P2、P3表示L3的4块空间）：

cpu0、cpu1 共享L3的P0、P1。

cpu2、cpu3 共享L3的P2、P3。

WORD_3配置值，详细说明如下 ：

bit0~bit3：分配给cpu0的4份L3的mask bit， bit0为1，表示L3的第一份分给cpu0，bit1为1，表示L3的

第二份分给cpu0，以此类推。

bit4~bit7：分配给cpu1的4份L3的mask bit。

bit8~bit11：分配给cpu2的4份L3的mask bit。

bit12~bit15：分配给cpu3的4份L3的mask bit。

配置后可以通过下面开机LOG确认

```c
INFO: L3 cache partition cfg-c333
```

此为分配cpu3 256k L3。

##### 		b）隔离核心

bootargs添加 `isolcpus=3 nohz_full=3` ，将核心cpu3隔离出来，不参与系统任务调度，并作为实时核心。

```c
diff --git a/arch/arm64/boot/dts/rockchip/rk3568-linux.dtsi b/arch/arm64/boot/dts/rockchip/rk3568-linux.dtsi
index c7e309645099b..28fac4880744d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-linux.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568-linux.dtsi
@@ -13,7 +13,7 @@ aliases {
        };
 
        chosen: chosen {
-               bootargs = "earlycon=uart8250,mmio32,0xfe660000 console=ttyFIQ0 root=PARTUUID=614e0000-0000 rw rootwait";
+               bootargs = "earlycon=uart8250,mmio32,0xfe660000 isolcpus=3 nohz_full=3 console=ttyFIQ0 root=PARTUUID=614e0000-0000 rw rootwait";
        };
 
        fiq-debugger {
```

##### 		c）实时任务绑定到实时核上运行

（1）将cyclitest绑定到cpu3上运行，测试实时性能

```c
taskset -c 3 cyclictest -c0 -m -t -p99  -D 12h
```

注：`ps  -eo pid,psr,comm | grep cyclictest` 可以查看cyclitest是否绑定在cpu3.

