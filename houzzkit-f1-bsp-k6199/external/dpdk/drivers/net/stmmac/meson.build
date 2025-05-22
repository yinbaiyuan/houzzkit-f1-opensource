# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2021 NXP

if not is_linux
    build = false
    reason = 'only supported on linux'
endif

sources = files(
        'stmmac_ethdev.c',
        'stmmac_uio.c',
        'stmmac_rxtx.c',
        'dwmac4_lib.c',
        'dwmac4_core.c',
        'dwmac4_dma.c',
        'dwmac4_descs.c',
	'mmc_core.c'
)
