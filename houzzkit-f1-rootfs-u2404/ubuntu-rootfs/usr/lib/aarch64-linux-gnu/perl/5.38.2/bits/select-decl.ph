require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_BITS_SELECT_DECL_H)) {
    eval 'sub _BITS_SELECT_DECL_H () {1;}' unless defined(&_BITS_SELECT_DECL_H);
    unless(defined(&_SYS_SELECT_H)) {
	die("Never include <bits/select-decl.h> directly; use <sys/select.h> instead.");
    }
}
1;
