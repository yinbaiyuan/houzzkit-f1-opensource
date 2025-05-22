package Debian::AdduserRetvalues 3.136;
use 5.32.0;
use strict;
use warnings;

# Adduser definitions of return values
#
# Copyright (C) 2023 Marc Haber <mh+debian-packages@zugschlus.de>
#
# License: GPL-2+

use parent qw(Exporter);

use vars qw(@EXPORT $VAR1);

@EXPORT = (
    'RET_OK',
    'RET_OBJECT_EXISTS',
    'RET_OBJECT_DOES_NOT_EXIST',
    'RET_WRONG_OBJECT_PROPERTIES',
    'RET_ID_IN_USE',
    'RET_NO_ID_IN_RANGE',
    'RET_NO_PRIMARY_GID',
    'RET_INVALID_CHARS_IN_NAME',
    'RET_INVALID_HOME_DIRECTORY',
    'RET_GROUP_NOT_EMPTY',
    'RET_USER_NOT_IN_GROUP',
    'RET_NO_PRIMARY_GROUP',
    'RET_INVALID_CALL',
    'RET_CONFIG_ERROR',
    'RET_EXCLUSIVE_PARAMETERS',
    'RET_ROOT_NEEDED',
    'RET_DONT_REMOVE_ROOT',
    'RET_MORE_PACKAGES',
    'RET_ADDUSER_ABORTED',
    'RET_INTERNAL',
    'RET_LOCKFILE',
    'RET_CONFFILE',
    'RET_POOLFILE',
    'RET_POOLFILE_FORMAT',
    'RET_FILE_ERROR',
    'RET_EXEC_NOT_FOUND',
    'RET_SYSTEMCALL_ERROR',
    'RET_SYSTEMCALL_SIGNAL',
    'RET_SYSTEM_ERROR',
);

use constant RET_OK => 0; # OK

# object state errors

use constant RET_OBJECT_EXISTS => 11; # the user or group does already exist, so the requested action cannot be performed;
use constant RET_OBJECT_DOES_NOT_EXIST => 12; # the user or group does already exist, so the requested action cannot be performed;
use constant RET_WRONG_OBJECT_PROPERTIES => 13;

# object ID errors

use constant RET_ID_IN_USE => 21; # requested ID already in use
use constant RET_NO_ID_IN_RANGE => 22; # no ID in requested range available
use constant RET_NO_PRIMARY_GID => 23; # requested primary GID does not exist

# object name errors

use constant RET_INVALID_CHARS_IN_NAME => 31; # the provided name contains invalid characters
use constant RET_INVALID_HOME_DIRECTORY => 32; # the provided name contains invalid characters

# group membership errors

use constant RET_GROUP_NOT_EMPTY => 41;
use constant RET_USER_NOT_IN_GROUP => 42;
use constant RET_NO_PRIMARY_GROUP => 43;

# easy user errors

use constant RET_INVALID_CALL => 51; # getopt returned with "false"
use constant RET_CONFIG_ERROR => 52; # error in configuration file
use constant RET_EXCLUSIVE_PARAMETERS => 53; # mutually exclusive parameters used
use constant RET_ROOT_NEEDED => 54;
use constant RET_DONT_REMOVE_ROOT => 55;
use constant RET_MORE_PACKAGES => 56;

# adduser internal errors

use constant RET_ADDUSER_ABORTED => 61;  # the program was aborted (eg via Ctrl+C)
use constant RET_INTERNAL => 62; # internal error

# file system related errors

use constant RET_LOCKFILE => 71;
use constant RET_CONFFILE => 72;
use constant RET_POOLFILE => 73;
use constant RET_POOLFILE_FORMAT => 74;
use constant RET_FILE_ERROR => 75;

# errors with external executables

use constant RET_EXEC_NOT_FOUND => 81;
use constant RET_SYSTEMCALL_ERROR => 82;
use constant RET_SYSTEMCALL_SIGNAL => 83;
use constant RET_SYSTEM_ERROR => 84;

1;

# Local Variables:
# mode:cperl
# End:

# vim: tabstop=4 shiftwidth=4 expandtab
