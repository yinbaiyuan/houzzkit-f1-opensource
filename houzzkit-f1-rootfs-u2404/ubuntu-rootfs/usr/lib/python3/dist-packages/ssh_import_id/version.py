# This file is part of ssh-import-id. See LICENSE file for more info.

_LAST_RELEASE = "5.11"
_PACKAGED_VERSION = '5.11-0ubuntu2.24.04.1'

VERSION = _LAST_RELEASE

if not _PACKAGED_VERSION.startswith("@@"):
    VERSION = _PACKAGED_VERSION

# vi: ts=4 expandtab syntax=python
