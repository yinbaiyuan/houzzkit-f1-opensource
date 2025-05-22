#!/usr/bin/python3
# coding: utf-8
#
# smb2-quota is a cmdline tool to display quota information for the
# Linux SMB client file system (CIFS)
#
# Copyright (C) Ronnie Sahlberg (lsahlberg@redhat.com) 2019
# Copyright (C) Kenneth D'souza (kdsouza@redhat.com) 2019
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


import array
import fcntl
import os
import struct
import sys
import argparse

CIFS_QUERY_INFO = 0xc018cf07
BBOLD = '\033[1;30;47m'   # Bold black text with white background.
ENDC = '\033[m'   # Rest to defaults


def usage():
    print("Usage: %s [-h] <options> <filename>" % sys.argv[0])
    print("Try 'smb2-quota -h' for more information")
    sys.exit()


class SID:
    def __init__(self, buf):
        self.sub_authority_count = buf[1]
        self.buffer = buf[:8 + self.sub_authority_count * 4]
        self.revision = self.buffer[0]
        if self.revision != 1:
            raise ValueError('SID Revision %d not supported' % self.revision)
        self.identifier_authority = 0
        for x in self.buffer[2:8]:
            self.identifier_authority = self.identifier_authority * 256 + x
        self.sub_authority = []
        for i in range(self.sub_authority_count):
            self.sub_authority.append(struct.unpack_from('<I', self.buffer, 8 + 4 * i)[0])

    def __str__(self):
        s = "S-%u-%u" % (self.revision, self.identifier_authority)
        for x in self.sub_authority:
            s += '-%u' % x
        return s


def convert(num):  # Convert bytes to closest human readable UNIT.
    for unit in ['', 'kiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB']:
        if abs(num) < 1024.0:
            return "%3.1f %s" % (num, unit)
        num /= 1024.0


def percent_used(used, limit, warn):
    if limit == warn:
        return "N/A"
    else:
        return str(round((used / limit) * 100.0))


def status(used, limit, warn):
    if limit == warn:
        return "Ok"
    elif used > limit:
        return "Above Limit"
    elif warn < used < limit:
        return "Warning"
    else:
        return "Ok"


class QuotaEntry:
    def __init__(self, buf, flag):
        sl = struct.unpack_from('<I', buf, 4)[0]
        self.sid = SID(buf[40:40 + sl])
        self.used = struct.unpack_from('<Q', buf, 16)[0]
        self.thr = struct.unpack_from('<Q', buf, 24)[0]
        self.lim = struct.unpack_from('<Q', buf, 32)[0]
        self.a = (convert(self.used))
        self.b = (convert(self.thr))
        self.c = (convert(self.lim))
        self.percent = (percent_used(float(self.used), float(self.lim), float(self.thr)))
        self.status = (status(float(self.used), float(self.lim), float(self.thr)))
        self.flag = flag

    def __str__(self):
        if self.flag == 0:
            s = " %-11s | %-11s | %-13s | %-12s | %-12s | %s" % (self.a, self.c, self.b, self.percent, self.status,  self.sid)
        elif self.flag == 1:
            s = "%s,%d,%d,%d" % (self.sid, self.used, self.lim, self.thr)
        else:
            s = 'SID:%s\n' % self.sid
            s += 'Quota Used:%d\n' % self.used
            if self.thr == 0xffffffffffffffff:
                s += 'Quota Threshold Limit:NO_WARNING_THRESHOLD\n'
            else:
                s += 'Quota Threshold Limit:%d\n' % self.thr
            if self.lim == 0xffffffffffffffff:
                s += 'Quota Limit:NO_LIMIT\n'
            else:
                s += 'Quota Limit:%d\n' % self.lim
        return s


class Quota:
    def __init__(self, buf, flag):
        self.quota = []
        while buf:
            qe = QuotaEntry(buf, flag)
            self.quota.append(qe)
            s = struct.unpack_from('<I', buf, 0)[0]
            if s == 0:
                break
            buf = buf[s:]

    def __str__(self):
        s = ''
        for q in self.quota:
            s += '%s\n' % q
        return s


def parser_check(path, flag):
    titleused = "Amount Used"
    titlelim = "Quota Limit"
    titlethr = "Warning Level"
    titlepercent = "Percent Used"
    titlestatus = "Status"
    titlesid = "SID"
    buf = array.array('B', [0] * 16384)
    struct.pack_into('<I', buf, 0, 4)  # InfoType: Quota
    struct.pack_into('<I', buf, 16, 16384)  # InputBufferLength
    struct.pack_into('<I', buf, 20, 16)  # OutputBufferLength
    struct.pack_into('b', buf, 24, 0)  # return single
    struct.pack_into('b', buf, 25, 1)  # return single
    try:
        f = os.open(path, os.O_RDONLY)
        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
        os.close(f)
        if flag == 0:
            print((BBOLD + " %-7s | %-7s | %-7s | %-7s | %-12s | %s " + ENDC) % (titleused, titlelim, titlethr, titlepercent, titlestatus, titlesid))
        q = Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], flag)
        print(q)
    except IOError as reason:
        print("ioctl failed: %s" % reason)
    except OSError as reason:
        print("ioctl failed: %s" % reason)


def main():
    if len(sys.argv) < 2:
        usage()

    parser = argparse.ArgumentParser(description="Please specify an action to perform.", prog="smb2-quota")
    parser.add_argument("-t", "--tabular", action="store_true", help="print quota information in tabular format")
    parser.add_argument("-c", "--csv",  action="store_true", help="print quota information in csv format")
    parser.add_argument("-l", "--list", action="store_true", help="print quota information in list format")
    parser.add_argument("filename", metavar="<filename>", nargs=1, help='filename on a share')
    args = parser.parse_args()

    default = True if not (args.tabular or args.csv or args.list) else False
    path = args.filename[0]

    if args.tabular or default:
        parser_check(path, 0)

    if args.csv:
        parser_check(path, 1)

    if args.list:
        parser_check(path, 2)


if __name__ == "__main__":
    main()
