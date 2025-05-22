require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_BITS_UNISTD_DECL_H)) {
    eval 'sub _BITS_UNISTD_DECL_H () {1;}' unless defined(&_BITS_UNISTD_DECL_H);
    unless(defined(&_UNISTD_H)) {
	die("Never include <bits/unistd-decl.h> directly; use <unistd.h> instead.");
    }
    if(defined (&__USE_UNIX98) || defined (&__USE_XOPEN2K8)) {
    }
    if(defined (&__USE_XOPEN_EXTENDED) || defined (&__USE_XOPEN2K)) {
    }
    if(defined(&__USE_ATFILE)) {
    }
    if(defined (&__USE_MISC) || defined (&__USE_XOPEN_EXTENDED)) {
    }
    if(defined(&__USE_POSIX199506)) {
    }
    if(defined (&__USE_MISC) || defined (&__USE_UNIX98)) {
    }
    if(defined (&__USE_MISC) || (defined (&__USE_XOPEN)  && !defined (&__USE_UNIX98))) {
    }
}
1;
