下面以Intel的I350网卡为例：（对于其它厂家的PCIE网卡，需要按照下面第6点的说明，让厂家修改符合我们平台要求的驱动）

1. kernel defconfig打开如下配置：
+CONFIG_UIO=m
+CONFIG_HUGETLBFS=y

2. kernel代码修改如下：
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 77131e8fefcc1..0a70d70bed6df 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -45,7 +45,7 @@ struct uio_mem {
 	struct uio_map		*map;
 };
 
-#define MAX_UIO_MAPS	5
+#define MAX_UIO_MAPS	13

 struct uio_portio;
 
@@ -65,7 +65,7 @@ struct uio_port {
 	struct uio_portio	*portio;
 };
 
-#define MAX_UIO_PORT_REGIONS	5
+#define MAX_UIO_PORT_REGIONS	13
 
 struct uio_device {
 	struct module           *owner;

3.把rk_drivers/igb_uio驱动，用实际使用的内核编译出一个igb_uio.ko
+obj-m				+= igb_uio/

4. 附相关命令及工具：
#驱动(下面两个ko都从实际使用的内核编译)
insmod uio.ko
insmod igb_uio.ko
#开启性能模式（命令报错忽略）
echo performance | tee $(find /sys/ -name *governor) /dev/null || true
#开启hugepages
echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

#绑定网卡 （0000:01:00.X要改成实际的）
dpdk/usertools/dpdk-devbind.py -b igb_uio 0000:01:00.0
dpdk/usertools/dpdk-devbind.py -b igb_uio 0000:01:00.1
dpdk/usertools/dpdk-devbind.py -b igb_uio 0000:01:00.2
dpdk/usertools/dpdk-devbind.py -b igb_uio 0000:01:00.3
... ...

#测试工具/方法（DPDK可以直接从官网下载编译，具体参考GMAC开发文档的介绍）
dpdk/build/app/dpdk-testpmd
./dpdk-testpmd --iova-mode=pa -l 0,2,3 --main-lcore=0 -- -i

5. RK平台特殊说明
RK主控硬件层不支持DMA访问外部内存一致性，而开源DPDK代码网卡驱动使用的API：rte_eth_dma_zone_reserve 和 rte_mbuf_raw_alloc，默认要求硬件保证访问内存一致性，比如：
发送数据的场景：CPU把数据写到内存(带cache)，然后通知网卡DMA来搬运这块内存的数据，DPDK默认支持的硬件平台会自动刷新cache，使的网卡DMA能直接拿到最新数据，而RK平台需要手动取刷新；

DPDK内存主要有两种：
一个是给网卡BD描述符使用的内存，使用rte_eth_dma_zone_reserve来分配，由于它会被频繁使用，所以解决策略是在内核使用dma_alloc_coherent分配非cache的内存，然后映射给dpdk的网卡驱动使用（查看igb_uio驱动的修改）；
二是网卡存放数据的内存，比如用rte_mbuf_raw_alloc分配，由于内存分配量比较大，所以直接使用arm标准的指令刷cache的命令来实现，比如写发送数据时，写完数据后主动刷新这块内存，让实际的内存写到DDR里面取，此时DMA就能拿到实际写入的数据；（参考e1000网卡的发送函数的实现）

6、如果要支持其它型号的PCIE网卡，请按照上述的要求让网卡厂商去修改他们的驱动即可。

7、共存：
PCIE和GMAC共存问题
7.1 请优先加载PCIE的DPDK驱动，然后再加载GMAC的.
7.2 PCIE intel网卡和rtk网卡一起使用情况
r8168_ethdev.c	static int r8168_uio_cnt = 0;
igb_ethdev.c	static int uio_cnt = 0;

规则修改如下：
intel 4口网卡先加载/rtk后加载，占用uio0/1/2/3, rtl8111h从uio4开始，注意如果0/1/2/3代表物理网口的个数，要按直接情况修改r8168_uio_cnt = 4;

8、目前代码只支持RK3568，想支持其它平台请发邮件到如下邮箱获取支持；

如有任何疑问，请发邮件到xiaoyao@rock-chips.com

