/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

/* Prefix path to sysfs directory where UIO device attributes are exported.
 * Path for UIO device X is /sys/class/uio/uioX
 */
#define STMMAC_UIO_DEVICE_SYS_ATTR_PATH	"/sys/class/uio"

/* Subfolder in sysfs where mapping attributes are exported
 * for each UIO device. Path for mapping Y for device X is:
 * /sys/class/uio/uioX/maps/mapY
 */
#define STMMAC_UIO_DEVICE_SYS_MAP_ATTR	"maps/map"

/* Name of UIO device file prefix. Each UIO device will have a device file
 * /dev/uioX, where X is the minor device number.
 */
#define STMMAC_UIO_DEVICE_FILE_NAME	"/dev/uio"
/*
 * Name of UIO device. User space STMMAC will have a corresponding
 * UIO device.
 * Maximum length is #STMMAC_UIO_MAX_DEVICE_NAME_LENGTH.
 *
 * @note  Must be kept in sync with STMMAC kernel driver
 * define #STMMAC_UIO_DEVICE_NAME !
 */
#define STMMAC_UIO_DEVICE_NAME     "uio_eth"

/* Maximum length for the name of an UIO device file.
 * Device file name format is: /dev/uioX.
 */
#define STMMAC_UIO_MAX_DEVICE_FILE_NAME_LENGTH	30

/* Maximum length for the name of an attribute file for an UIO device.
 * Attribute files are exported in sysfs and have the name formatted as:
 * /sys/class/uio/uioX/<attribute_file_name>
 */
#define STMMAC_UIO_MAX_ATTR_FILE_NAME	100

/* The id for the mapping used to export STMMAC registers and BD memory to
 * user space through UIO device.
 */
#define STMMAC_UIO_REG_MAP_ID		0
#define STMMAC_UIO_RX_BD_MAP_ID	1
#define STMMAC_UIO_TX_BD_MAP_ID	2
#define STMMAC_UIO_RX_BD1_MAP_ID	3
#define STMMAC_UIO_TX_BD1_MAP_ID	4

#define MAP_PAGE_SIZE			4096

struct uio_job {
	uint32_t fec_id;
	int uio_fd;
	void *bd_start_addr;
	void *register_base_addr;
	int map_size;
	uint64_t map_addr;
	int uio_minor_number;
};

int stmmac_configure(struct stmmac_private *private, int id);
int config_stmmac_uio(struct stmmac_private *private);
void stmmac_uio_init(void);
void stmmac_cleanup(struct stmmac_private *private);
