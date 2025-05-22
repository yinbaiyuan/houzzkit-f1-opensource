# SPDX-License-Identifier: BSD-3-Clause
# Copyright(c) 2020 Realtek Corporation

include $(RTE_SDK)/mk/rte.vars.mk

#
# library name
#
LIB = librte_pmd_r8168.a

CFLAGS += -O3
CFLAGS += $(WERROR_FLAGS)
LDLIBS += -lrte_eal -lrte_mbuf -lrte_mempool -lrte_ring
LDLIBS += -lrte_ethdev -lrte_net -lrte_kvargs
LDLIBS += -lrte_bus_vdev

EXPORT_MAP := rte_pmd_r8168_version.map

VPATH += $(SRCDIR)/base

#
# all source are stored in SRCS-y
#
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += r8168_rxtx.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += r8168_ethdev.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += r8168_dash.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += r8168_hw.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += r8168_phy.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168g.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168h.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168ep.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168fp.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168g_mcu.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168h_mcu.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168ep_mcu.c
SRCS-$(CONFIG_RTE_LIBRTE_R8168_PMD) += rtl8168fp_mcu.c
include $(RTE_SDK)/mk/rte.lib.mk
