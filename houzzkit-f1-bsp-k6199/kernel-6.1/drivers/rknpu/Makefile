# SPDX-License-Identifier: GPL-2.0
obj-$(CONFIG_ROCKCHIP_RKNPU) += rknpu.o
obj-y += rknpu_iommu_stub.o

ccflags-y += -I$(srctree)/$(src)/include
ccflags-y += -I$(src)/include
ccflags-y += -Werror

rknpu-y += rknpu_drv.o
rknpu-y += rknpu_reset.o
rknpu-y += rknpu_job.o
rknpu-y += rknpu_debugger.o
rknpu-y += rknpu_iommu.o
rknpu-$(CONFIG_PM_DEVFREQ) += rknpu_devfreq.o
rknpu-$(CONFIG_ROCKCHIP_RKNPU_SRAM) += rknpu_mm.o
rknpu-$(CONFIG_ROCKCHIP_RKNPU_FENCE) += rknpu_fence.o
rknpu-$(CONFIG_ROCKCHIP_RKNPU_DRM_GEM) += rknpu_gem.o
rknpu-$(CONFIG_ROCKCHIP_RKNPU_DMA_HEAP) += rknpu_mem.o
