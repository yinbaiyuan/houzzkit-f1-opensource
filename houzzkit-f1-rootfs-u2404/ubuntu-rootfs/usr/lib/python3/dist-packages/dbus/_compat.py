# Python 2 / Python 3 compatibility helpers.
# Copyright 2011 Barry Warsaw
# Copyright 2021 Collabora Ltd.
# SPDX-License-Identifier: MIT

import sys

is_py3 = True
is_py2 = False

if sys.version_info.major < 3:
    raise AssertionError(
        'Python 2 has reached end-of-life, and dbus-python no longer '
        'supports it.'
    )
