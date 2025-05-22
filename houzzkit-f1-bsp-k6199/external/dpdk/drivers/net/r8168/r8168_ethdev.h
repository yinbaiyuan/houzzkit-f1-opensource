/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright(c) 2020 Realtek Technologies Co., Ltd
 */

#ifndef _R8168_ETHDEV_H_
#define _R8168_ETHDEV_H_

#include <stdint.h>

#include <rte_ethdev.h>
#include <rte_ethdev_core.h>

#include "r8168_base.h"


#define PCI_READ_CONFIG_BYTE(dev, val, where) \
	rte_pci_read_config(dev, val, 1, where)

#define PCI_READ_CONFIG_WORD(dev, val, where) \
	rte_pci_read_config(dev, val, 2, where)

#define PCI_READ_CONFIG_DWORD(dev, val, where) \
	rte_pci_read_config(dev, val, 4, where)

#define PCI_WRITE_CONFIG_BYTE(dev, val, where) \
	rte_pci_write_config(dev, val, 1, where)

#define PCI_WRITE_CONFIG_WORD(dev, val, where) \
	rte_pci_write_config(dev, val, 2, where)

#define PCI_WRITE_CONFIG_DWORD(dev, val, where) \
	rte_pci_write_config(dev, val, 4, where)


int rtl_rx_init(struct rte_eth_dev *dev);
int rtl_tx_init(struct rte_eth_dev *dev);

uint16_t rtl_xmit_pkts(void *txq, struct rte_mbuf **tx_pkts, uint16_t nb_pkts);
uint16_t rtl_recv_pkts(void *rxq, struct rte_mbuf **rx_pkts, uint16_t nb_pkts);

int rtl_start_queues(struct rte_eth_dev *dev);
int rtl_stop_queues(struct rte_eth_dev *dev);
void rtl_free_queues(struct rte_eth_dev *dev);

int rtl_rx_queue_start(struct rte_eth_dev *dev, uint16_t queue_idx);
int rtl_rx_queue_stop(struct rte_eth_dev *dev, uint16_t queue_idx);

int rtl_tx_queue_start(struct rte_eth_dev *dev, uint16_t queue_idx);
int rtl_tx_queue_stop(struct rte_eth_dev *dev, uint16_t queue_idx);

void rtl_tx_queue_release(void *txq);
void rtl_rx_queue_release(void *rxq);

int rtl_tx_done_cleanup(void *tx_queue, uint32_t free_cnt);

int rtl_tx_queue_setup(struct rte_eth_dev *dev, uint16_t queue_idx,
                       uint16_t nb_tx_desc, unsigned int socket_id,
                       const struct rte_eth_txconf *tx_conf);

int rtl_rx_queue_setup(struct rte_eth_dev *dev, uint16_t queue_idx,
                       uint16_t nb_rx_desc, unsigned int socket_id,
                       const struct rte_eth_rxconf *rx_conf,
                       struct rte_mempool *mb_pool);

void rtl_rxq_info_get(struct rte_eth_dev *dev, uint16_t queue_idx,
                      struct rte_eth_rxq_info *qinfo);

void rtl_txq_info_get(struct rte_eth_dev *dev, uint16_t queue_idx,
                      struct rte_eth_txq_info *qinfo);

uint64_t rtl_get_tx_port_offloads(struct rte_eth_dev *dev __rte_unused);
uint64_t rtl_get_rx_port_offloads(struct rte_eth_dev *dev __rte_unused);

void rtl_dump_mac_reg(struct rtl_hw *hw);
void rtl_dump_pci_reg(struct rtl_hw *hw);

#endif /* _R8168_ETHDEV_H_ */
