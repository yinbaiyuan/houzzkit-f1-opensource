/******************************************************************************
 *
 * Copyright(c) 2016 - 2017 Realtek Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 *****************************************************************************/

#include <drv_types.h>
#include <rtw_mem.h>

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
MODULE_AUTHOR("Realtek Semiconductor Corp.");
MODULE_VERSION("DRIVERVERSION");

/* for MAX_RECVBUF_SZ */
#if defined(CONFIG_RTL8188E)
#include <rtl8188e_hal.h>
#elif defined(CONFIG_RTL8188F)
#include <rtl8188f_hal.h>
#elif defined(CONFIG_RTL8188GTV)
#include <rtl8188gtv_hal.h>
#elif defined(CONFIG_RTL8710B)
#include <rtl8710b_hal.h>
#elif defined(CONFIG_RTL8192E)
#include <rtl8192e_hal.h>
#elif defined(CONFIG_RTL8192F)
#include <rtl8192f_hal.h>
#elif defined(CONFIG_RTL8723B)
#include <rtl8723b_hal.h>
#elif defined(CONFIG_RTL8703B)
#include <rtl8703b_hal.h>
#elif defined(CONFIG_RTL8723D)
#include <rtl8723d_hal.h>
#elif defined(CONFIG_RTL8812A) || defined(CONFIG_RTL8821A)
#include <rtl8812a_hal.h>
#elif defined(CONFIG_RTL8822B)
#include <rtl8822b_hal.h>
#elif defined(CONFIG_RTL8822C)
#include <rtl8822c_hal.h>
#elif defined(CONFIG_RTL8814A)
#include <rtl8814a_hal.h>
#elif defined(CONFIG_RTL8814B)
#include <rtl8814b_hal.h>
#elif defined(CONFIG_RTL8822E)
#include <rtl8822e_hal.h>
#endif

#if defined(CONFIG_SDIO_HCI) || defined(CONFIG_GSPI_HCI)
#define MAX_RTKM_RECVBUF_SZ		MAX_RECVBUF_SZ
#define MAX_RTKM_NR_PREALLOC_RECV_SKB	NR_RECVBUFF
#else /* !CONFIG_SDIO_HCI */
#ifdef CONFIG_PLATFORM_MSTAR_HIGH
	#define MAX_RTKM_RECVBUF_SZ (31744) /* 31k */
#else
	#define MAX_RTKM_RECVBUF_SZ (15360) /* 15k */
#endif /* CONFIG_PLATFORM_MSTAR_HIGH */
#define MAX_RTKM_NR_PREALLOC_RECV_SKB 16
#endif /* !CONFIG_SDIO_HCI */

struct sk_buff_head rtk_skb_mem_q;
struct u8 *rtk_buf_mem[NR_RECVBUFF];

struct u8	*rtw_get_buf_premem(int index)
{
	printk("%s, rtk_buf_mem index : %d\n", __func__, index);
	return rtk_buf_mem[index];
}

u16 rtw_rtkm_get_buff_size(void)
{
	return MAX_RTKM_RECVBUF_SZ;
}
EXPORT_SYMBOL(rtw_rtkm_get_buff_size);

u8 rtw_rtkm_get_nr_recv_skb(void)
{
	return MAX_RTKM_NR_PREALLOC_RECV_SKB;
}
EXPORT_SYMBOL(rtw_rtkm_get_nr_recv_skb);

struct sk_buff *rtw_alloc_skb_premem(u16 in_size)
{
	struct sk_buff *skb = NULL;

	if (in_size > MAX_RTKM_RECVBUF_SZ) {
		pr_info("warning %s: driver buffer size(%d) > rtkm buffer size(%d)\n", __func__, in_size, MAX_RTKM_RECVBUF_SZ);
		WARN_ON(1);
		return skb;
	}

	skb = skb_dequeue(&rtk_skb_mem_q);

	printk("%s, rtk_skb_mem_q len : %d\n", __func__, skb_queue_len(&rtk_skb_mem_q));

	return skb;
}
EXPORT_SYMBOL(rtw_alloc_skb_premem);

int rtw_free_skb_premem(struct sk_buff *pskb)
{
	if (!pskb)
		return -1;

	if (skb_queue_len(&rtk_skb_mem_q) >= MAX_RTKM_NR_PREALLOC_RECV_SKB)
		return -1;

	skb_queue_tail(&rtk_skb_mem_q, pskb);

	printk("%s, rtk_skb_mem_q len : %d\n", __func__, skb_queue_len(&rtk_skb_mem_q));

	return 0;
}
EXPORT_SYMBOL(rtw_free_skb_premem);

static int __init rtw_mem_init(void)
{
	int i;
	SIZE_PTR tmpaddr = 0;
	SIZE_PTR alignment = 0;
	struct sk_buff *pskb = NULL;

	printk("%s\n", __func__);
	pr_info("MAX_RTKM_NR_PREALLOC_RECV_SKB: %d\n", MAX_RTKM_NR_PREALLOC_RECV_SKB);
	pr_info("MAX_RTKM_RECVBUF_SZ: %d\n", MAX_RTKM_RECVBUF_SZ);

#ifdef CONFIG_USE_USB_BUFFER_ALLOC_RX
	for (i = 0; i < NR_RECVBUFF; i++)
		rtk_buf_mem[i] = usb_buffer_alloc(dev, size, (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL), dma);
#endif /* CONFIG_USE_USB_BUFFER_ALLOC_RX */

	skb_queue_head_init(&rtk_skb_mem_q);

	for (i = 0; i < MAX_RTKM_NR_PREALLOC_RECV_SKB; i++) {
		pskb = __dev_alloc_skb(MAX_RTKM_RECVBUF_SZ + RECVBUFF_ALIGN_SZ, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
		if (pskb) {
			tmpaddr = (SIZE_PTR)pskb->data;
			alignment = tmpaddr & (RECVBUFF_ALIGN_SZ - 1);
			skb_reserve(pskb, (RECVBUFF_ALIGN_SZ - alignment));

			skb_queue_tail(&rtk_skb_mem_q, pskb);
		} else
			printk("%s, alloc skb memory fail!\n", __func__);

		pskb = NULL;
	}

	printk("%s, rtk_skb_mem_q len : %d\n", __func__, skb_queue_len(&rtk_skb_mem_q));

	return 0;

}

static void __exit rtw_mem_exit(void)
{
	if (skb_queue_len(&rtk_skb_mem_q))
		printk("%s, rtk_skb_mem_q len : %d\n", __func__, skb_queue_len(&rtk_skb_mem_q));

	skb_queue_purge(&rtk_skb_mem_q);

	printk("%s\n", __func__);
}

module_init(rtw_mem_init);
module_exit(rtw_mem_exit);
