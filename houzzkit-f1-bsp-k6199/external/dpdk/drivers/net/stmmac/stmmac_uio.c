/* SPDX-License-Identifier: BSD-3-Clause
 * Copyright (c) 2022 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <sys/mman.h>
#include <errno.h>
#include <fcntl.h>

#include <rte_common.h>
#include <rte_malloc.h>
#include "stmmac_pmd_logs.h"
#include "common.h"

static int stmmac_count;

/** @brief Checks if a file name contains a certain substring.
 * This function assumes a filename format of: [text][number].
 * @param [in]  filename    File name
 * @param [in]  match       String to match in file name
 *
 * @retval true if file name matches the criteria
 * @retval false if file name does not match the criteria
 */
static bool
file_name_match_extract(const char filename[], const char match[])
{
	char *substr = NULL;

	substr = strstr(filename, match);
	if (substr == NULL)
		return false;

	return true;
}

/*
 * @brief Reads first line from a file.
 * Composes file name as: root/subdir/filename
 *
 * @param [in]  root     Root path
 * @param [in]  subdir   Subdirectory name
 * @param [in]  filename File name
 * @param [out] line     The first line read from file.
 *
 * @retval 0 for success
 * @retval other value for error
 */
static int
file_read_first_line(const char root[], const char subdir[],
			const char filename[], char *line)
{
	char absolute_file_name[STMMAC_UIO_MAX_ATTR_FILE_NAME];
	int fd = 0, ret = 0;

	/*compose the file name: root/subdir/filename */
	memset(absolute_file_name, 0, sizeof(absolute_file_name));
	snprintf(absolute_file_name, STMMAC_UIO_MAX_ATTR_FILE_NAME,
		"%s/%s/%s", root, subdir, filename);

	fd = open(absolute_file_name, O_RDONLY);
	if (fd <= 0)
		STMMAC_PMD_ERR("Error opening file %s\n", absolute_file_name);

	/* read UIO device name from first line in file */
	ret = read(fd, line, STMMAC_UIO_MAX_DEVICE_FILE_NAME_LENGTH);
	if (ret <= 0) {
		STMMAC_PMD_ERR("Error reading file %s\n", absolute_file_name);
		return ret;
	}
	close(fd);

	/* NULL-ify string */
	line[ret] = '\0';

	return 0;
}

/*
 * @brief Maps rx-tx bd range assigned for a bd ring.
 *
 * @param [in] uio_device_fd    UIO device file descriptor
 * @param [in] uio_device_id    UIO device id
 * @param [in] uio_map_id       UIO allows maximum 5 different mapping for
				each device. Maps start with id 0.
 * @param [out] map_size        Map size.
 * @param [out] map_addr	Map physical address
 *
 * @retval  NULL if failed to map registers
 * @retval  Virtual address for mapped register address range
 */
static void *
uio_map_mem(int uio_device_fd, int uio_device_id,
		int uio_map_id, int *map_size, uint64_t *map_addr)
{
	void *mapped_address = NULL;
	unsigned int uio_map_size = 0;
	unsigned int uio_map_p_addr = 0;
	char uio_sys_root[STMMAC_UIO_MAX_ATTR_FILE_NAME];
	char uio_sys_map_subdir[STMMAC_UIO_MAX_ATTR_FILE_NAME];
	char uio_map_size_str[STMMAC_UIO_MAX_DEVICE_FILE_NAME_LENGTH + 1];
	char uio_map_p_addr_str[32];
	int ret = 0;

	/* compose the file name: root/subdir/filename */
	memset(uio_sys_root, 0, sizeof(uio_sys_root));
	memset(uio_sys_map_subdir, 0, sizeof(uio_sys_map_subdir));
	memset(uio_map_size_str, 0, sizeof(uio_map_size_str));
	memset(uio_map_p_addr_str, 0, sizeof(uio_map_p_addr_str));

	/* Compose string: /sys/class/uio/uioX */
	snprintf(uio_sys_root, sizeof(uio_sys_root), "%s/%s%d",
			STMMAC_UIO_DEVICE_SYS_ATTR_PATH, "uio", uio_device_id);
	/* Compose string: maps/mapY */
	snprintf(uio_sys_map_subdir, sizeof(uio_sys_map_subdir), "%s%d",
			STMMAC_UIO_DEVICE_SYS_MAP_ATTR, uio_map_id);

	STMMAC_PMD_INFO("US_UIO: uio_map_mem uio_sys_root: %s, uio_sys_map_subdir: %s, uio_map_size_str: %s\n",
			uio_sys_root, uio_sys_map_subdir, uio_map_size_str);

	/* Read first (and only) line from file
	 * /sys/class/uio/uioX/maps/mapY/size
	 */
	ret = file_read_first_line(uio_sys_root, uio_sys_map_subdir,
				"size", uio_map_size_str);
	if (ret < 0) {
		STMMAC_PMD_ERR("file_read_first_line() failed\n");
		return NULL;
	}
	ret = file_read_first_line(uio_sys_root, uio_sys_map_subdir,
				"addr", uio_map_p_addr_str);
	if (ret < 0) {
		STMMAC_PMD_ERR("file_read_first_line() failed\n");
		return NULL;
	}
	/* Read mapping size and physical address expressed in hexa(base 16) */
	uio_map_size = strtol(uio_map_size_str, NULL, 16);
	uio_map_p_addr = strtol(uio_map_p_addr_str, NULL, 16);

	if (uio_map_id == 0) {
		/* Map the register address in user space when map_id is 0 */
		mapped_address = mmap(0 /*dynamically choose virtual address */,
				uio_map_size, PROT_READ | PROT_WRITE,
				MAP_SHARED, uio_device_fd, 0);
	} else if (uio_map_id == 2) {
		/* Map the BD memory in user space */
		mapped_address = mmap(NULL, uio_map_size,
				PROT_READ | PROT_WRITE,
				MAP_SHARED, uio_device_fd, (2 * MAP_PAGE_SIZE));
	} else if (uio_map_id == 1) {
		/* Map the BD memory in user space */
		mapped_address = mmap(NULL, uio_map_size,
				PROT_READ | PROT_WRITE,
				MAP_SHARED, uio_device_fd, (1 * MAP_PAGE_SIZE));
	}

	if (mapped_address == MAP_FAILED) {
		STMMAC_PMD_ERR("Failed to map! errno = %d uio job fd = %d,"
			"uio device id = %d, uio map id = %d\n", errno,
			uio_device_fd, uio_device_id, uio_map_id);
		return NULL;
	}

	/* Save the map size to use it later on for munmap-ing */
	*map_size = uio_map_size;
	*map_addr = uio_map_p_addr;

	STMMAC_PMD_INFO("UIO dev[%d] mapped region [id =%d] size 0x%x map_addr_p: 0x%lx, at %p\n",
		uio_device_id, uio_map_id, uio_map_size, *map_addr, mapped_address);

	return mapped_address;
}

int
config_stmmac_uio(struct stmmac_private *private)
{
	char uio_device_file_name[32];
	struct uio_job *uio_job = NULL;

	uio_job = &private->stmmac_uio_job;

	/* Find UIO device created by STMMAC-UIO kernel driver */
	memset(uio_device_file_name, 0, sizeof(uio_device_file_name));
	snprintf(uio_device_file_name, sizeof(uio_device_file_name), "%s%d",
		 STMMAC_UIO_DEVICE_FILE_NAME, uio_job->uio_minor_number);

	STMMAC_PMD_INFO("stmmac_configure uio_name id: %d",
		       uio_job->uio_minor_number);

	/* Open device file */
	uio_job->uio_fd = open(uio_device_file_name, O_RDWR);
	if (uio_job->uio_fd < 0) {
		STMMAC_PMD_WARN("Unable to open STMMAC_UIO file\n");
		return -1;
	}

	STMMAC_PMD_INFO("US_UIO: Open device(%s) file with uio_fd = %d\n",
			uio_device_file_name, uio_job->uio_fd);

	private->ioaddr_v = uio_map_mem(uio_job->uio_fd,
		uio_job->uio_minor_number, STMMAC_UIO_REG_MAP_ID,
		&uio_job->map_size, &uio_job->map_addr);
	if (private->ioaddr_v == NULL)
		return -ENOMEM;
	private->ioaddr_p = uio_job->map_addr;
	private->reg_size = uio_job->map_size;

	private->bd_addr_r_v = uio_map_mem(uio_job->uio_fd,
		uio_job->uio_minor_number, STMMAC_UIO_RX_BD_MAP_ID,
		&uio_job->map_size, &uio_job->map_addr);
	if (private->bd_addr_r_v == NULL)
		return -ENOMEM;
	private->bd_addr_r_p = (uint32_t)uio_job->map_addr;
	private->bd_r_size[0] = uio_job->map_size;

	private->bd_addr_t_v = uio_map_mem(uio_job->uio_fd,
		uio_job->uio_minor_number, STMMAC_UIO_TX_BD_MAP_ID,
		&uio_job->map_size, &uio_job->map_addr);
	if (private->bd_addr_t_v == NULL)
		return -ENOMEM;
	private->bd_addr_t_p = (uint32_t)uio_job->map_addr;
	private->bd_t_size[0] = uio_job->map_size;

	stmmac_count++;

	return 0;
}

int
stmmac_configure(struct stmmac_private *private, int id)
{
	char uio_name[32];
	int uio_minor_number = -1;
	int ret;
	DIR *d = NULL;
	struct dirent *dir;

	d = opendir(STMMAC_UIO_DEVICE_SYS_ATTR_PATH);
	if (d == NULL) {
		STMMAC_PMD_ERR("\nError opening directory '%s': %s\n",
			STMMAC_UIO_DEVICE_SYS_ATTR_PATH, strerror(errno));
		return -1;
	}

	/* Iterate through all subdirs */
	while ((dir = readdir(d)) != NULL) {
		STMMAC_PMD_INFO("stmmac_configure dir name: %s\n",
						  dir->d_name);
		if (!strncmp(dir->d_name, ".", 1) ||
				!strncmp(dir->d_name, "..", 2))
			continue;

		if (file_name_match_extract(dir->d_name, "uio")) {
			/*
			 * As substring <uio> was found in <d_name>
			 * read number following <uio> substring in <d_name>
			 */
			ret = sscanf(dir->d_name + strlen("uio"), "%d",
							&uio_minor_number);
			if (ret < 0)
				STMMAC_PMD_ERR("Error: not find minor number\n");

			STMMAC_PMD_INFO("stmmac device uio_minor_number: %d\n",
					uio_minor_number);

			/*
			 * Open file uioX/name and read first line which
			 * contains the name for the device. Based on the
			 * name check if this UIO device is for stmmac.
			 */
			memset(uio_name, 0, sizeof(uio_name));
			ret = file_read_first_line(STMMAC_UIO_DEVICE_SYS_ATTR_PATH,
					dir->d_name, "name", uio_name);
			if (ret != 0) {
				STMMAC_PMD_INFO("file_read_first_line failed\n");
				closedir(d);
				return -1;
			}

			STMMAC_PMD_INFO("stmmac_configure uio_name: %s", uio_name);

			if (file_name_match_extract(uio_name,
				STMMAC_UIO_DEVICE_NAME) && (id == uio_minor_number)) {
				private->stmmac_uio_job.uio_minor_number =
							uio_minor_number;
				STMMAC_PMD_INFO("stmmac device uio name: %s\n", uio_name);
			}
		}
	}
	closedir(d);
	return 0;
}

void
stmmac_cleanup(struct stmmac_private *private)
{
	munmap(private->ioaddr_v, private->reg_size);
}
