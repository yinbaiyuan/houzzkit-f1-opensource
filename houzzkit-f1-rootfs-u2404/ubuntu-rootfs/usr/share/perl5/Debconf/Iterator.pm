#!/usr/bin/perl
# This file was preprocessed, do not edit!


package Debconf::Iterator;
use warnings;
use strict;
use base qw(Debconf::Base);


sub iterate {
	my $this=shift;

	$this->callback->($this);
}


1
