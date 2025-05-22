// SPDX-License-Identifier: GPL-2.0

#include "rknpu_iommu.h"

#if defined(CONFIG_IOMMU_API) && defined(CONFIG_NO_GKI)

int rknpu_iommu_get_dma_cookie(struct iommu_domain *domain)
{
    return iommu_get_dma_cookie(domain);
}
EXPORT_SYMBOL(rknpu_iommu_get_dma_cookie);

#endif
