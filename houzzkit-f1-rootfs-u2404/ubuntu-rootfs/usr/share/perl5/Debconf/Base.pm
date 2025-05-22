#!/usr/bin/perl
# This file was preprocessed, do not edit!


package Debconf::Base;
use warnings;
use strict;
use Debconf::Log ':all';


sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $this=bless ({@_}, $class);
	$this->init;
	return $this;
}


sub init {}


sub AUTOLOAD {
	(my $field = our $AUTOLOAD) =~ s/.*://;

	no strict 'refs';
	*$AUTOLOAD = sub {
		my $this=shift;

		return $this->{$field} unless @_;
		return $this->{$field}=shift;
	};
	goto &$AUTOLOAD;
}

sub DESTROY {
}


1
