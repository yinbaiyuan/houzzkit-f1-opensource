#!/usr/bin/perl
# This file was preprocessed, do not edit!


package Debconf::Element::Noninteractive::Text;
use warnings;
use strict;
use base qw(Debconf::Element::Noninteractive);


sub show {
	my $this=shift;

	$this->value('');
}

1
