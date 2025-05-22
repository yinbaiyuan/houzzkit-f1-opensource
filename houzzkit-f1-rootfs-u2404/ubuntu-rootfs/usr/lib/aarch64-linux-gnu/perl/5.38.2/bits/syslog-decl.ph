require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_BITS_SYSLOG_DECL_H)) {
    eval 'sub _BITS_SYSLOG_DECL_H () {1;}' unless defined(&_BITS_SYSLOG_DECL_H);
    unless(defined(&_SYS_SYSLOG_H)) {
	die("Never include <bits/syslog-decl.h> directly; use <sys/syslog.h> instead.");
    }
    if(defined(&__USE_MISC)) {
    }
}
1;
