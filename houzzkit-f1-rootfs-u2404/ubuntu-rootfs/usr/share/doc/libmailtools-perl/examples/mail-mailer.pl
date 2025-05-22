#!/usr/bin/perl -w

# Note by Mark Overmeer:
#   This script does work, but Mail::Send may provide a nicer interface

# NAME
# 	mail-mailer.pl - Smtp client written in Perl
#
# SYNOPSIS
# 	mail-mailer.pl -s "Test" --smtp=my-smtp-server.com admin@net1.net
#
# INTRODUCTION
# 	This script can be an alternative to the 'mail' Unix command when
# 	sending e-mails.
# 	It reads the mail body from the standard input.
#   If your system is Windows, use the '--smtp' option to send your 
#	e-mails.
#	This script works in Linux, Unix and Windows environments.
#
# OPTIONS
#	-f				From
#	-s				Subject
#	-c				Cc-address
#	-b				bcc-address
#	--sendmail		Use sendmail to send the e-mail
#	--qmail			Use qmail-inject to send the e-mail
#	--smtp=HOSTNAME	Use HOSTNAME as the SMTP server. 
#	--help			Prints the help info and exits
#
# EXAMPLES
# 	cat mailbody.txt | mail-mailer.pl -f me@mydom.com -s "Hy dude" --sendmail friend@dom.com
#
# AUTHOR
#	Bruno Negrao G Zica <bnegrao@engepel.com.br>
#
# COPYRIGHT
#	Copyright (c) 2004 Bruno Negrao G Zica. All rights reserved.
#	This program is free software; you can redistribute it and/or modify
#	it under the same terms as Perl itself.
# 
# LAST MODIFIED
#	01/12/2004
##################################################################
use Mail::Mailer;
use Getopt::Long;
use strict;

# hash that'll receive the arguments and options
my %opt;
GetOptions ( \%opt, 'help', 'f=s', 's=s', 'c=s', 'b=s', 'sendmail',
	'qmail', 'smtp=s' );

if ($opt{help}) { help(); exit 0; }

$opt{to} = $ARGV[$#ARGV]; # the "To" address is the last argument
die "Error: You didn't specify a destination e-mail address.\n" 
	unless ( $opt{to} || $opt{c} || $opt{b} );

# Defining the method to send the message
my $mailer;		# Mail::Mailer object
if ($opt{sendmail}) {
	$mailer = new Mail::Mailer 'sendmail';
} elsif ($opt{qmail}) {
	$mailer = new Mail::Mailer 'qmail';
} elsif ($opt{smtp}) {
	$mailer = new Mail::Mailer 'smtp', Server => $opt{smtp};
} else {
	die "Error: you didn't specify the delivery method. ". 
		"Possible methods are:\n'--qmail', '--sendmail', and ".
		"--smtp=HOSTNAME\n";
}
# Setting the headers
my %headers;	# hash with the e-mail headers
$headers{To} 	=	$opt{to};
$headers{From} 	=	$opt{f} if defined $opt{f};
$headers{Cc} 	=	$opt{c} if defined $opt{c};
$headers{Bcc} 	= 	$opt{b} if defined $opt{b};
$headers{Subject} =	$opt{s} if defined $opt{s};
$mailer->open(\%headers);

# Reading and feeding the e-mail body
while (<STDIN>) {
	last if ( $_ =~ /^\.$/ );
	print $mailer $_;
}

# Finishing
$mailer->close();

# Subroutines
sub help {
	print '
Example 1: Entering the e-mail body by hand:
mail-mailer.pl -s "Hy buddy" --qmail friend@domain.com
[ ENTER YOU MESSAGE BODY ]
[ A SINGLE . (dot sign) ALONE IN ONE LINE TO SAY ]
[ YOU FINISHED YOUR E-MAIL ]
.

Example 2: Using the output of another program as the body:
dir c:\ | perl mail-mailer.pl -f me@mydom.com -s "My c:\" admin@mydom.com --smtp=server1.mydom.com

OPTIONS
-f  addr		From address.
-s  TEXT		Subject.
-c  addr		Cc-address.
-b  addr		bcc-address.
--sendmail		Use sendmail to send the e-mail.
--qmail			Use qmail-inject to send the e-mail.
--smtp  HOSTNAME	Use HOSTNAME as the SMTP server. 
--help			Prints this help text.
';
}
