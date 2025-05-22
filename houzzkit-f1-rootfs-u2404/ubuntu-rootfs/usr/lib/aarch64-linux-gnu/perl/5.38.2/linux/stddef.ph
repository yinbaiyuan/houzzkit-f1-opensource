require '_h2ph_pre.ph';

no warnings qw(redefine misc);

unless(defined(&_LINUX_STDDEF_H)) {
    eval 'sub _LINUX_STDDEF_H () {1;}' unless defined(&_LINUX_STDDEF_H);
    unless(defined(&__always_inline)) {
	eval 'sub __always_inline () { &__inline__;}' unless defined(&__always_inline);
    }
    eval 'sub __struct_group () {( &TAG,  &NAME,  &ATTRS,  &MEMBERS...) \'union union\' { 1; 1; }  &ATTRS;}' unless defined(&__struct_group);
    if(defined(&__cplusplus)) {
	eval 'sub __DECLARE_FLEX_ARRAY {
	    my($T, $member) = @_;
    	    eval q($T $member->[0]);
	}' unless defined(&__DECLARE_FLEX_ARRAY);
    } else {
	eval 'sub __DECLARE_FLEX_ARRAY {
	    my($TYPE, $NAME) = @_;
    	    eval q(1; $TYPE $NAME->[]; });
	}' unless defined(&__DECLARE_FLEX_ARRAY);
    }
    unless(defined(&__counted_by)) {
	eval 'sub __counted_by {
	    my($m) = @_;
    	    eval q();
	}' unless defined(&__counted_by);
    }
}
1;
