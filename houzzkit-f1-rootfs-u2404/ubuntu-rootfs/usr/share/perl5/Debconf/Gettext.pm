#!/usr/bin/perl
# This file was preprocessed, do not edit!


package Debconf::Gettext;
use warnings;
use strict;


BEGIN {
	eval 'use Locale::gettext';
	if ($@) {
		eval {
			sub gettext {
				return shift;
			}
		};
	}
	else {
		textdomain('debconf');
	}
}

use base qw(Exporter);
our @EXPORT=qw(gettext);


1
