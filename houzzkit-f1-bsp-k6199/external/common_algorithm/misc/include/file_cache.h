/* Copyright (c) Rockchip Electronics Co. Ltd. */

#ifndef __FILE_CACHE_H__
#define __FILE_CACHE_H__

#include <stdint.h>

typedef struct _FILE_CACHE_ARG {
	const char *sdcard_path;
	int write_cache;
	int total_cache;
} FILE_CACHE_ARG;

int file_cache_init(FILE_CACHE_ARG *cache_arg);
int file_cache_deinit();
int64_t file_cache_lseek(int fd, int64_t offset, int whence);
ssize_t file_cache_write(int fd, const void *buf, size_t count, int64_t mdat_pos);
int file_cache_open(const char *filename, int flags, ...);
int file_cache_close(int fd);

#if 0
FILE *file_cache_fopen(const char *file_name, const char *mode);
int file_cache_fclose(FILE *fp);
ssize_t file_cache_read(int fd, void *buf, size_t count);
int file_cache_writetrail(int fd);
int file_cache_get_tailoff(int fd);
int file_cache_blocknotify(int prev_num, int later_num, char *filename);
int file_cache_fstat(int fd, struct stat *filestat);
#endif

#endif
