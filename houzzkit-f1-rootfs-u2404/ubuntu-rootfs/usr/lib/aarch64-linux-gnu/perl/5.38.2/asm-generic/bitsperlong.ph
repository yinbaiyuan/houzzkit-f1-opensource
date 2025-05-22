require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&__ASM_GENERIC_BITS_PER_LONG)) {
    eval 'sub __ASM_GENERIC_BITS_PER_LONG () {1;}' unless defined(&__ASM_GENERIC_BITS_PER_LONG);
    unless(defined(&__BITS_PER_LONG)) {
	if(defined(&__CHAR_BIT__)  && defined(&__SIZEOF_LONG__)) {
	    eval 'sub __BITS_PER_LONG () {( &__CHAR_BIT__ *  &__SIZEOF_LONG__);}' unless defined(&__BITS_PER_LONG);
	} else {
	    eval 'sub __BITS_PER_LONG () {32;}' unless defined(&__BITS_PER_LONG);
	}
    }
}
1;
