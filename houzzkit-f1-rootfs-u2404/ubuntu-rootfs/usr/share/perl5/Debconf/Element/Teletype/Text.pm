#!/usr/bin/perl
# This file was preprocessed, do not edit!


package Debconf::Element::Teletype::Text;
use warnings;
use strict;
use base qw(Debconf::Element);


sub show {
	my $this=shift;

	$this->frontend->display($this->question->description."\n\n".
		$this->question->extended_description."\n");

	$this->value('');
}

1
