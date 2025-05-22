#!/usr/bin/perl
# This file was preprocessed, do not edit!


package Debconf::Priority;
use warnings;
use strict;
use Debconf::Config;
use base qw(Exporter);
our @EXPORT_OK = qw(high_enough priority_valid priority_list);


my %priorities=(
	'low' => 0,
	'medium' => 1,
	'high' => 2,
	'critical' => 3,
);


sub high_enough {
	my $priority=shift;

	return 1 if ! exists $priorities{$priority};
	return $priorities{$priority} >= $priorities{Debconf::Config->priority};
}


sub priority_valid {
	my $priority=shift;

	return exists $priorities{$priority};
}


sub priority_list {
	my @sorted = sort { $priorities{$a} <=> $priorities{$b} } keys %priorities;
	return @sorted;
}


1
