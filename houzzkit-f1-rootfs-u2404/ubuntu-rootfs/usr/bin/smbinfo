#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# smbinfo is a cmdline tool to query SMB-specific file and fs
# information on a Linux SMB mount (cifs.ko).
#
# Copyright (C) 2019 Aurelien Aptel <aaptel@suse.com>
# Copyright (C) 2019 Ronnie Sahlberg <lsahlberg@redhat.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

import os
import re
import argparse
import fcntl
import struct
import stat
import datetime
import calendar

VERBOSE = False

# ioctl ctl codes
CIFS_QUERY_INFO          = 0xc018cf07
CIFS_ENUMERATE_SNAPSHOTS = 0x800ccf06
CIFS_DUMP_KEY            = 0xc03acf08
CIFS_DUMP_FULL_KEY       = 0xc011cf0a

# large enough input buffer length
INPUT_BUFFER_LENGTH = 16384

# length of a @GMT- token in bytes
GMT_TOKEN_LEN_IN_BYTES = 24 * 2

# GMT format string
GMT_FORMAT = "@GMT-%Y.%m.%d-%H.%M.%S"

# cifs query flags
PASSTHRU_QUERY_INFO = 0x00000000
PASSTHRU_FSCTL      = 0x00000001

DIR_ACCESS_FLAGS = [
    (0x00000001, "LIST_DIRECTORY"),
    (0x00000002, "ADD_FILE"),
    (0x00000004, "ADD_SUBDIRECTORY"),
    (0x00000008, "READ_EA"),
    (0x00000010, "WRITE_EA"),
    (0x00000020, "TRAVERSE"),
    (0x00000040, "DELETE_CHILD"),
    (0x00000080, "READ_ATTRIBUTES"),
    (0x00000100, "WRITE_ATTRIBUTES"),
    (0x00010000, "DELETE"),
    (0x00020000, "READ_CONTROL"),
    (0x00040000, "WRITE_DAC"),
    (0x00080000, "WRITE_OWNER"),
    (0x00100000, "SYNCHRONIZER"),
    (0x01000000, "ACCESS_SYSTEM_SECURITY"),
    (0x02000000, "MAXIMUM_ALLOWED"),
    (0x10000000, "GENERIC_ALL"),
    (0x20000000, "GENERIC_EXECUTE"),
    (0x40000000, "GENERIC_WRITE"),
    (0x80000000, "GENERIC_READ"),
]

FILE_ACCESS_FLAGS = [
    (0x00000001, "READ_DATA"),
    (0x00000002, "WRITE_DATA"),
    (0x00000004, "APPEND_DATA"),
    (0x00000008, "READ_EA"),
    (0x00000010, "WRITE_EA"),
    (0x00000020, "EXECUTE"),
    (0x00000040, "DELETE_CHILD"),
    (0x00000080, "READ_ATTRIBUTES"),
    (0x00000100, "WRITE_ATTRIBUTES"),
    (0x00010000, "DELETE"),
    (0x00020000, "READ_CONTROL"),
    (0x00040000, "WRITE_DAC"),
    (0x00080000, "WRITE_OWNER"),
    (0x00100000, "SYNCHRONIZER"),
    (0x01000000, "ACCESS_SYSTEM_SECURITY"),
    (0x02000000, "MAXIMUM_ALLOWED"),
    (0x10000000, "GENERIC_ALL"),
    (0x20000000, "GENERIC_EXECUTE"),
    (0x40000000, "GENERIC_WRITE"),
    (0x80000000, "GENERIC_READ"),
]

FILE_ATTR_FLAGS = [
    (0x00000001, "READ_ONLY"),
    (0x00000002, "HIDDEN"),
    (0x00000004, "SYSTEM"),
    (0x00000010, "DIRECTORY"),
    (0x00000020, "ARCHIVE"),
    (0x00000080, "NORMAL"),
    (0x00000100, "TEMPORARY"),
    (0x00000200, "SPARSE_FILE"),
    (0x00000400, "REPARSE_POINT"),
    (0x00000800, "COMPRESSED"),
    (0x00001000, "OFFLINE"),
    (0x00002000, "NOT_CONTENT_INDEXED"),
    (0x00004000, "ENCRYPTED"),
    (0x00008000, "INTEGRITY_STREAM"),
    (0x00020000, "NO_SCRUB_DATA"),
]

FILE_MODE_FLAGS = [
    (0x00000002, "WRITE_THROUGH"),
    (0x00000004, "SEQUENTIAL_ONLY"),
    (0x00000008, "NO_INTERMEDIATE_BUFFERING"),
    (0x00000010, "SYNCHRONOUS_IO_ALERT"),
    (0x00000020, "SYNCHRONOUS_IO_NONALERT"),
    (0x00001000, "DELETE_ON_CLOSE"),
]

ALIGN_TYPES = [
    (0, "BYTE_ALIGNMENT"),
    (1, "WORD_ALIGNMENT"),
    (3, "LONG_ALIGNMENT"),
    (7, "QUAD_ALIGNMENT"),
    (15, "OCTA_ALIGNMENT"),
    (31, "32_bit_ALIGNMENT"),
    (63, "64_bit_ALIGNMENT"),
    (127, "128_bit_ALIGNMENT"),
    (255, "254_bit_ALIGNMENT"),
    (511, "512_bit_ALIGNMENT"),
]

COMPRESSION_TYPES = [
    (0x0000, "NONE"),
    (0x0002, "LZNT1"),
]

CONTROL_FLAGS = [
    (0x8000, "SR"),
    (0x4000, "RM"),
    (0x2000, "PS"),
    (0x1000, "PD"),
    (0x0800, "SI"),
    (0x0400, "DI"),
    (0x0200, "SC"),
    (0x0100, "DC"),
    (0x0080, "DT"),
    (0x0040, "SS"),
    (0x0020, "SD"),
    (0x0010, "SP"),
    (0x0008, "DD"),
    (0x0004, "DP"),
    (0x0002, "GD"),
    (0x0001, "OD"),
]

ACE_TYPES = [
    (0x00, "ALLOWED"),
    (0x01, "DENIED"),
    (0x02, "AUDIT"),
    (0x03, "ALARM"),
    (0x04, "ALLOWED_COMPOUND"),
    (0x05, "ALLOWED_OBJECT"),
    (0x06, "DENIED_OBJECT"),
    (0x07, "AUDIT_OBJECT"),
    (0x08, "ALARM_OBJECT"),
    (0x09, "ALLOWED_CALLBACK"),
    (0x0a, "DENIED_CALLBACK"),
    (0x0b, "ALLOWED_CALLBACK_OBJECT"),
    (0x0c, "DENIED_CALLBACK_OBJECT"),
    (0x0d, "AUDIT_CALLBACK"),
    (0x0e, "ALARM_CALLBACK"),
    (0x0f, "AUDIT_CALLBACK_OBJECT"),
    (0x10, "ALARM_CALLBACK_OBJECT"),
    (0x11, "MANDATORY_LABEL"),
    (0x12, "RESOURCE_ATTRIBUTE"),
    (0x13, "SCOPED_POLICY_ID"),
]

ACE_FLAGS = [
    (0x80, "FAILED_ACCESS"),
    (0x40, "SUCCESSFUL_ACCESS"),
    (0x10, "INHERITED"),
    (0x08, "INHERIT_ONLY"),
    (0x04, "NO_PROPAGATE_INHERIT"),
    (0x02, "CONTAINER_INHERIT"),
    (0x01, "OBJECT_INHERIT"),
]

CIPHER_TYPES = [
    (0x00, "AES-128-CCM"),
    (0x01, "AES-128-CCM"),
    (0x02, "AES-128-GCM"),
    (0x03, "AES-256-CCM"),
    (0x04, "AES-256-GCM"),
]

def main():
    #
    # Global options and arguments
    #

    ap = argparse.ArgumentParser(description="Display SMB-specific file information using cifs IOCTL")
    ap.add_argument("-V", "--verbose", action="store_true", help="verbose output")
    subp = ap.add_subparsers(help="sub-commands help")
    subp.required = True
    subp.dest = 'subcommand'

    #
    # To add a new sub-command xxx, add a subparser xxx complete with
    # help, options and/or arguments and implement cmd_xxx()
    #

    sap = subp.add_parser("fileaccessinfo", help="Prints FileAccessInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_fileaccessinfo)

    sap = subp.add_parser("filealigninfo", help="Prints FileAlignInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filealigninfo)

    sap = subp.add_parser("fileallinfo", help="Prints FileAllInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_fileallinfo)

    sap = subp.add_parser("filebasicinfo", help="Prints FileBasicInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filebasicinfo)

    sap = subp.add_parser("fileeainfo", help="Prints FileEAInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_fileeainfo)

    sap = subp.add_parser("filefsfullsizeinfo", help="Prints FileFsFullSizeInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filefsfullsizeinfo)

    sap = subp.add_parser("fileinternalinfo", help="Prints FileInternalInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_fileinternalinfo)

    sap = subp.add_parser("filemodeinfo", help="Prints FileModeInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filemodeinfo)

    sap = subp.add_parser("filepositioninfo", help="Prints FilePositionInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filepositioninfo)

    sap = subp.add_parser("filestandardinfo", help="Prints FileStandardInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filestandardinfo)

    sap = subp.add_parser("filestreaminfo", help="Prints FileStreamInfo for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_filestreaminfo)

    sap = subp.add_parser("fsctl-getobjid", help="Prints the objectid of the file and GUID of the underlying volume.")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_fsctl_getobjid)

    sap = subp.add_parser("getcompression", help="Prints the compression setting for the file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_getcompression)

    sap = subp.add_parser("setcompression", help="Sets the compression level for the file")
    sap.add_argument("type", choices=['no','default','lznt1'])
    sap.add_argument("file")
    sap.set_defaults(func=cmd_setcompression)

    sap = subp.add_parser("list-snapshots", help="List the previous versions of the volume that backs this file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_list_snapshots)

    sap = subp.add_parser("quota", help="Prints the quota for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_quota)

    sap = subp.add_parser("secdesc", help="Prints the security descriptor for a cifs file")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_secdesc)

    sap = subp.add_parser("keys", help="Prints the decryption information needed to view encrypted network traces")
    sap.add_argument("file")
    sap.set_defaults(func=cmd_keys)

    # parse arguments
    args = ap.parse_args()

    # act on any global options
    if args.verbose:
        global VERBOSE
        VERBOSE = True

    # call subcommand function
    args.func(args)

class QueryInfoStruct:
    def __init__(self,
                 info_type=0, file_info_class=0, additional_information=0,
                 flags=0, input_buffer_length=0, output_buffer_length=0):
        self.info_type = info_type
        self.file_info_class = file_info_class
        self.additional_information = additional_information
        self.flags = flags
        self.input_buffer_length = input_buffer_length
        self.output_buffer_length = output_buffer_length
        buf_size = max(self.input_buffer_length, self.output_buffer_length)
        self.input_buffer = bytearray(buf_size)

    def pack_input(self, fmt, offset, *vals):
        struct.pack_into(fmt, self.input_buffer, offset, *vals)

    def ioctl(self, fd, out_fmt=None):
        buf = bytearray()
        buf.extend(struct.pack("IIIIII",
                               self.info_type,
                               self.file_info_class,
                               self.additional_information,
                               self.flags,
                               self.input_buffer_length,
                               self.output_buffer_length))
        in_len = len(buf)
        buf.extend(self.input_buffer)
        fcntl.ioctl(fd, CIFS_QUERY_INFO, buf, True)
        if out_fmt:
            return struct.unpack_from(out_fmt, buf, in_len)
        else:
            return buf[in_len:]

def flags_to_str(flags, bitlist, verbose=None):
    if verbose is None:
        verbose = VERBOSE

    if not verbose:
        return "0x%08x"%flags

    out = []
    for bit, name in bitlist:
        if flags & bit:
            out.append(name)

    return "0x%08x (%s)"%(flags, ",".join(out))

def type_to_str(typ, typelist, verbose=None):
    if verbose is None:
        verbose = VERBOSE

    if not verbose:
        return "0x%08x"%typ

    s = "Unknown"
    for val, name in typelist:
        if typ == val:
            s = name

    return "0x%08x (%s)"%(typ, s)

def cmd_fileaccessinfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=8, input_buffer_length=4)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        info = os.fstat(fd)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_fileaccessinfo(buf, info)

def print_fileaccessinfo(buf, info):
    flags = struct.unpack_from('<I', buf, 0)[0]
    if stat.S_ISDIR(info.st_mode):
        print("Directory access flags:", flags_to_str(flags, DIR_ACCESS_FLAGS))
    else:
        print("File/Printer access flags:", flags_to_str(flags, FILE_ACCESS_FLAGS))

def cmd_filealigninfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=17, input_buffer_length=4)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filealigninfo(buf)

def print_filealigninfo(buf):
    mask = struct.unpack_from('<I', buf, 0)[0]
    print("File alignment: %s"%type_to_str(mask, ALIGN_TYPES))

def cmd_fileallinfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=18, input_buffer_length=INPUT_BUFFER_LENGTH)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        info = os.fstat(fd)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filebasicinfo(buf)
    print_filestandardinfo(buf[40:])
    print_fileinternalinfo(buf[64:])
    print_fileeainfo(buf[72:])
    print_fileaccessinfo(buf[76:], info)
    print_filepositioninfo(buf[80:])
    print_filemodeinfo(buf[88:])
    print_filealigninfo(buf[92:])

def win_to_datetime(smb2_time):
    usec = (smb2_time / 10) % 1000000
    sec  = (smb2_time - 116444736000000000) // 10000000
    return datetime.datetime.fromtimestamp(sec + usec/10000000)

def cmd_filebasicinfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=4, input_buffer_length=40)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filebasicinfo(buf)

def print_filebasicinfo(buf):
    ctime, atime, wtime, mtime, attrs = struct.unpack_from('<QQQQI', buf, 0)
    print("Creation Time: %s"%win_to_datetime(ctime))
    print("Last Access Time: %s"%win_to_datetime(atime))
    print("Last Write Time: %s"%win_to_datetime(wtime))
    print("Last Change Time: %s"%win_to_datetime(mtime))
    print("File Attributes: %s"%flags_to_str(attrs, FILE_ATTR_FLAGS))

def cmd_fileeainfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=7, input_buffer_length=4)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_fileeainfo(buf)

def print_fileeainfo(buf):
    size = struct.unpack_from('<I', buf, 0)[0]
    print("EA Size: %d"%size)

def cmd_filefsfullsizeinfo(args):
    qi = QueryInfoStruct(info_type=0x2, file_info_class=7, input_buffer_length=32)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        total, caller_avail, actual_avail, sec_per_unit, byte_per_sec = qi.ioctl(fd, '<QQQII')
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print("Total Allocation Units: %d"%total)
    print("Caller Available Allocation Units: %d"%caller_avail)
    print("Actual Available Allocation Units: %d"%actual_avail)
    print("Sectors Per Allocation Unit: %d"%sec_per_unit)
    print("Bytes Per Sector: %d"%byte_per_sec)

def cmd_fileinternalinfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=6, input_buffer_length=8)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_fileinternalinfo(buf)

def print_fileinternalinfo(buf):
    index = struct.unpack_from('<Q', buf, 0)[0]
    print("Index Number: %d"%index)


def cmd_filemodeinfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=16, input_buffer_length=4)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filemodeinfo(buf)

def print_filemodeinfo(buf):
        mode = struct.unpack_from('<I', buf, 0)[0]
        print("Mode: %s"%flags_to_str(mode, FILE_MODE_FLAGS))

def cmd_filepositioninfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=14, input_buffer_length=8)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filepositioninfo(buf)

def print_filepositioninfo(buf):
    offset = struct.unpack_from('<Q', buf, 0)[0]
    print("Current Byte Offset: %d"%offset)

def cmd_filestandardinfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=5, input_buffer_length=24)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filestandardinfo(buf)

def print_filestandardinfo(buf):
    nalloc, eof, nlink, del_pending, del_dir = struct.unpack_from('<QQIBB', buf, 0)
    print("Allocation Size: %d"%nalloc)
    print("End Of File: %d"%eof)
    print("Number of Links: %d"%nlink)
    print("Delete Pending: %d"%del_pending)
    print("Delete Directory: %d"%del_dir)

def guid_to_str(buf):
    return "%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x"%struct.unpack_from('<IHHBBBBBBBB', buf, 0)

def cmd_fsctl_getobjid(args):
    qi = QueryInfoStruct(info_type=0x9009c, file_info_class=5, flags=PASSTHRU_FSCTL, input_buffer_length=64)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print("Object-ID: %s"%guid_to_str(buf))
    print("Birth-Volume-ID: %s"%guid_to_str(buf[16:]))
    print("Birth-Object-ID: %s"%guid_to_str(buf[32:]))
    print("Domain-ID: %s"%guid_to_str(buf[48:]))

def cmd_getcompression(args):
    qi = QueryInfoStruct(info_type=0x9003c, flags=PASSTHRU_FSCTL, input_buffer_length=2)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        ctype = qi.ioctl(fd, '<H')[0]
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    ctype_name = "UNKNOWN"
    for val, name in COMPRESSION_TYPES:
        if ctype == val:
            ctype_name = name
            break
    print("Compression: %d (%s)"%(ctype, ctype_name))

def cmd_setcompression(args):
    qi = QueryInfoStruct(info_type=0x9c040, flags=PASSTHRU_FSCTL, output_buffer_length=2)
    type_map = {'no': 0, 'default': 1, 'lznt1': 2}
    qi.pack_input('<H', 0, type_map[args.type])
    try:
        fd = os.open(args.file, os.O_RDONLY)
        qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

class SnapshotArrayStruct:
    def __init__(self,
                 nb_snapshots=0,
                 nb_snapshots_returned=0,
                 snapshot_array_size=12):
        self.nb_snapshots = nb_snapshots
        self.nb_snapshots_returned = nb_snapshots_returned
        self.snapshot_array_size = snapshot_array_size
        self.snapshot_array = []

    def ioctl(self, fd, op):
        buf = bytearray()
        buf.extend(struct.pack("III",
                               self.nb_snapshots,
                               self.nb_snapshots_returned,
                               self.snapshot_array_size))

        buf.extend(bytearray(16 + self.snapshot_array_size))
        fcntl.ioctl(fd, op, buf, True)

        out = SnapshotArrayStruct()
        out.nb_snapshots, out.nb_snapshots_returned, out.snapshot_array_size = struct.unpack_from('III', buf, 0)
        data = buf[12:]

        # '@\x00G\x00M\x00T\x00-\x002\x000\x001\x009\x00.\x000\x004\x00.\x000\x005\x00-\x002\x003\x00.\x001\x000\x00.\x005\x000\x00\x00\x00'
        index_start = 0
        while index_start < len(data):
            gmt_start = data.find(b'@', index_start)
            if gmt_start == -1 or len(data) - gmt_start < GMT_TOKEN_LEN_IN_BYTES:
                break
            gmt = data[gmt_start:gmt_start + GMT_TOKEN_LEN_IN_BYTES]
            index_start = gmt_start + GMT_TOKEN_LEN_IN_BYTES
            out.snapshot_array.append(datetime.datetime.strptime(gmt.decode('utf-16'), GMT_FORMAT))

        return out

def datetime_to_smb(dt):
    ntfs_time_offset = (369*365 + 89) * 24 * 3600 * 10000000
    return calendar.timegm(dt.timetuple()) * 10000000 + ntfs_time_offset

def cmd_list_snapshots(args):
    sa1req = SnapshotArrayStruct()
    sa1res = None
    sa2req = None
    sa2res = None

    try:
        fd = os.open(args.file, os.O_RDONLY)
        sa1res = sa1req.ioctl(fd, CIFS_ENUMERATE_SNAPSHOTS)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    if sa1res.nb_snapshots == 0:
        return

    sa2req = SnapshotArrayStruct(nb_snapshots=sa1res.nb_snapshots, snapshot_array_size=sa1res.snapshot_array_size)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        sa2res = sa2req.ioctl(fd, CIFS_ENUMERATE_SNAPSHOTS)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False


    print("Number of snapshots: %d Number of snapshots returned: %d"%(sa2res.nb_snapshots, sa2res.nb_snapshots_returned))
    print("Snapshot list in GMT (Coordinated UTC Time) and SMB format (100 nanosecond units needed for snapshot mounts):")
    for i, d in enumerate(sa2res.snapshot_array):
        print("%d) GMT:%s\n   SMB3:%d"%(i + 1, d.strftime(GMT_FORMAT), datetime_to_smb(d)))

class SID:
    def __init__(self, buf, off=0):
        rev, sublen = struct.unpack_from('BB', buf, off+0)
        off += 2
        auth = 0
        subauth = []
        for i in range(6):
            auth = (auth << 8)|buf[off]
            off += 1
        for i in range(sublen):
            subauth.append(struct.unpack_from('<I', buf, off))
            off += 4

        self.rev = rev
        self.auth = auth
        self.subauth = subauth

    def __str__(self):
        auth = ("0x%x" if self.auth >= 2**32 else "%d")%self.auth
        return  "S-%d-%s-%s"%(self.rev, auth, '-'.join(["%d"%x for x in self.subauth]))

class ACE:
    def __init__(self, buf, off=0, is_dir=False):
        self.typ, self.flags, self.size = struct.unpack_from('<BBH', buf, off)
        self.is_dir = is_dir
        if self.typ not in [0,1,2]:
            self.buf = buf[4:]
        else:
            self.mask = struct.unpack_from('<I', buf, off+4)[0]
            self.sid = SID(buf, off+8)

    def __str__(self):
        s = []
        s.append("Type: %s" % type_to_str(self.typ, ACE_TYPES))
        s.append("Flags: %s" % flags_to_str(self.flags, ACE_FLAGS))
        if self.typ not in [0,1,2]:
            s.append("<%s>"%(" ".join(["%02x"%x for x in self.buf])))
        else:
            s.append("Mask: %s"%flags_to_str(self.mask, (DIR_ACCESS_FLAGS if self.is_dir else FILE_ACCESS_FLAGS)))
            s.append("SID: %s"%self.sid)
        return ", ".join(s)

def cmd_quota(args):
    qi = QueryInfoStruct(info_type=0x04, input_buffer_length=INPUT_BUFFER_LENGTH)
    qi.pack_input('BBI', 0,
                  0, # return single
                  1, # restart scan
                  0, # sid list length
                  )
    qi.output_buffer_length = 16
    buf = None

    try:
        fd = os.open(args.file, os.O_RDONLY)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    off = 0
    while off < len(buf):
        next_off = struct.unpack_from('<I', buf, off+ 0)[0]
        sid_len  = struct.unpack_from('<I', buf, off+ 4)[0]
        atime    = struct.unpack_from('<Q', buf, off+ 8)[0]
        qused    = struct.unpack_from('<Q', buf, off+16)[0]
        qthresh  = struct.unpack_from('<Q', buf, off+24)[0]
        qlimit   = struct.unpack_from('<Q', buf, off+32)[0]
        sid = SID(buf, off+40)

        print("SID Length: %d"%sid_len)
        print("Change Time: %s"%win_to_datetime(atime))
        print("Quota Used: %d"%qused)
        print("Quota Threshold:", ("NO THRESHOLD" if qthresh == 0xffffffffffffffff else "%d"%qthresh))
        print("Quota Limit:", ("NO LIMIT" if qlimit == 0xffffffffffffffff else "%d"%qlimit))
        print("SID: %s"%sid)

        if next_off == 0:
            break
        off += next_off

def cmd_secdesc(args):
    qi = QueryInfoStruct(info_type=0x03,
                         additional_information=0x7, # owner, group, dacl
                         input_buffer_length=INPUT_BUFFER_LENGTH)
    buf = None
    info = None

    try:
        fd = os.open(args.file, os.O_RDONLY)
        info = os.fstat(fd)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    is_dir = stat.S_ISDIR(info.st_mode)
    rev, ctrl, off_owner, off_group, off_dacl = struct.unpack_from('<BxHIIxxxxI', buf, 0)

    print("Revision: %d"%rev)
    print("Control: %s"%flags_to_str(ctrl, CONTROL_FLAGS))
    if off_owner:
        print("Owner: %s"%SID(buf, off_owner))
    if off_group:
        print("Group: %s"%SID(buf, off_group))
    if off_dacl:
        print("DACL:")
        rev, count = struct.unpack_from('<BxxxH', buf, off_dacl)
        off_dacl += 8
        for i in range(count):
              ace = ACE(buf, off_dacl, is_dir=is_dir)
              print(ace)
              off_dacl += ace.size

def cmd_filestreaminfo(args):
    qi = QueryInfoStruct(info_type=0x1, file_info_class=22, input_buffer_length=INPUT_BUFFER_LENGTH)
    try:
        fd = os.open(args.file, os.O_RDONLY)
        info = os.fstat(fd)
        buf = qi.ioctl(fd)
    except Exception as e:
        print("syscall failed: %s"%e)
        return False

    print_filestreaminfo(buf)

def print_filestreaminfo(buf):
    offset = 0

    while offset < len(buf):

        next_offset = struct.unpack_from('<I', buf, offset + 0)[0]
        name_length = struct.unpack_from('<I', buf, offset + 4)[0]
        if (name_length > 0):
            stream_size = struct.unpack_from('<q', buf, offset + 8)[0]
            stream_alloc_size = struct.unpack_from('<q', buf, offset + 16)[0]
            stream_utf16le_name = struct.unpack_from('< %ss'% name_length, buf, offset + 24)[0]
            stream_name = stream_utf16le_name.decode("utf-16le")
            if (offset > 0):
                print()
            if (stream_name=="::$DATA"):
                print("Name: %s"% stream_name)
            else:
                print("Name: %s"% stream_name[stream_name.find(":") + 1 : stream_name.rfind(':$DATA')])
            print("Size: %d bytes"% stream_size)
            print("Allocation size: %d bytes "% stream_alloc_size)

        if (next_offset == 0):
            break

        offset+=next_offset

class KeyDebugInfoStruct:
    def __init__(self):
        self.suid = bytearray()
        self.cipher = 0
        self.session_key = bytearray()
        self.enc_key = bytearray()
        self.dec_key = bytearray()

    def ioctl(self, fd):
        buf = bytearray()
        buf.extend(struct.pack("= 8s H 16s 16s 16s", self.suid, self.cipher,
                               self.session_key, self.enc_key, self.dec_key))
        fcntl.ioctl(fd, CIFS_DUMP_KEY, buf, True)
        (self.suid, self.cipher, self.session_key,
         self.enc_key, self.dec_key) = struct.unpack_from('= 8s H 16s 16s 16s', buf, 0)

class FullKeyDebugInfoStruct:
    def __init__(self):
        # lets pick something large to be future proof
        # 17 + 3*32 would be strict minimum as of linux 5.13
        self.in_size = 1024
        self.suid = bytearray()
        self.cipher = 0
        self.session_key_len = 0
        self.server_in_key_len = 0
        self.server_out_key_len = 0

    def ioctl(self, fd):
        fmt = "= I 8s H B B B"
        size = struct.calcsize(fmt)
        buf = bytearray()
        buf.extend(struct.pack(fmt, self.in_size, self.suid, self.cipher,
                               self.session_key_len, self.server_in_key_len, self.server_out_key_len))
        buf.extend(bytearray(self.in_size-size))
        fcntl.ioctl(fd, CIFS_DUMP_FULL_KEY, buf, True)
        (self.in_size, self.suid, self.cipher,
         self.session_key_len, self.server_in_key_len,
         self.server_out_key_len) = struct.unpack_from(fmt, buf, 0)

        end = size
        self.session_key = buf[end:end+self.session_key_len]
        end += self.session_key_len
        self.server_in_key = buf[end:end+self.server_in_key_len]
        end += self.server_in_key_len
        self.server_out_key = buf[end:end+self.server_out_key_len]

def bytes_to_hex(buf):
    return " ".join(["%02x"%x for x in buf])

def cmd_keys(args):
    fd = os.open(args.file, os.O_RDONLY)
    kd = FullKeyDebugInfoStruct()

    try:
        # try new call first
        kd.ioctl(fd)
    except Exception as e:
        # new failed, try old call
        kd = KeyDebugInfoStruct()
        try:
            kd.ioctl(fd)
        except Exception as e:
            # both new and old call failed
            print("syscall failed: %s"%e)
            return False
        print("Session Id: %s"%bytes_to_hex(kd.suid))
        print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=True))
        print("Session Key: %s"%bytes_to_hex(kd.session_key))
        print("Encryption key: %s"%bytes_to_hex(kd.enc_key))
        print("Decryption key: %s"%bytes_to_hex(kd.dec_key))
    else:
        # no exception, new call succeeded
        print("Session Id: %s"%bytes_to_hex(kd.suid))
        print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=True))
        print("Session Key: %s"%bytes_to_hex(kd.session_key))
        print("ServerIn  Key: %s"%bytes_to_hex(kd.server_in_key))
        print("ServerOut key: %s"%bytes_to_hex(kd.server_out_key))

if __name__ == '__main__':
    main()
