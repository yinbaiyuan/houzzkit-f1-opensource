/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

#ifndef _STMMAC_LOGS_H_
#define _STMMAC_LOGS_H_

#include <rte_log.h>

extern int stmmac_logtype_pmd;

/* PMD related logs */
#define STMMAC_PMD_LOG(level, fmt, args...) \
	rte_log(RTE_LOG_ ## level, stmmac_logtype_pmd, "stmmac_net: %s()" \
		fmt "\n", __func__, ##args)

#define PMD_INIT_FUNC_TRACE() ENET_PMD_LOG(DEBUG, " >>")

#define STMMAC_PMD_DEBUG(fmt, args...) \
	STMMAC_PMD_LOG(DEBUG, fmt, ## args)
#define STMMAC_PMD_ERR(fmt, args...) \
	STMMAC_PMD_LOG(ERR, fmt, ## args)
#define STMMAC_PMD_INFO(fmt, args...) \
	STMMAC_PMD_LOG(INFO, fmt, ## args)

#define STMMAC_PMD_WARN(fmt, args...) \
	STMMAC_PMD_LOG(WARNING, fmt, ## args)

/* DP Logs, toggled out at compile time if level lower than current level */
#define STMMAC_DP_LOG(level, fmt, args...) \
	RTE_LOG_DP(level, PMD, fmt, ## args)

#endif /* _STMMAC_LOGS_H_ */
