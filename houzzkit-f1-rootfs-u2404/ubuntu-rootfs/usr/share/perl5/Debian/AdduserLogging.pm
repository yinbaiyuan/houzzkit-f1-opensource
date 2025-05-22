package Debian::AdduserLogging 3.136;
use 5.32.0;
use strict;
use warnings;

# Adduser logging Subroutines
#
# Subroutines shared by the "adduser" and "deluser" utilities.
#
# Copyright (C) 2023 Marc Haber <mh+debian-packages@zugschlus.de>
#
# License: GPL-2+

use parent qw(Exporter);

use vars qw(@EXPORT $VAR1);

sub progname {
    (my $blubb = $0) =~ s|(.*/)?(.*)|$2|;
    return ($blubb);
}

BEGIN {
    local $ENV{PERL_DL_NONLAZY}=1;
    # we need to use eval expression form here, perl cookbook 12.2.3
    eval " use Locale::gettext; "; ## no critic
    if ($@) {
        *gettext = sub { shift };
        *textdomain = sub { "" };
        *LC_MESSAGES = sub { 5 };
    } else {
        textdomain(progname());
    }
}


@EXPORT = (
    'gtx',
    'mtx',
    'log_trace',
    'log_debug',
    'log_info',
    'log_warn',
    'log_err',
    'log_fatal',
    'set_msglevel'
);

my $stderrmsglevel="error";
my $stdoutmsglevel="error";
my $syslogmsglevel="info";;
my $loggerparms="";
my $logtrace=$ENV{"ADDUSER_LOGTRACE"};

sub gtx {
    return gettext( shift );
}

# this is used as a marker for a string that should be translated
# it returns the untranslated string
# use this for a message that is passed to messagef
sub mtx {
    return shift;
}

sub numeric_msglevel {
    my ($msglevel) = @_;
    # error values from Log4perl::Level
    my %map = (
        logtrace => 1000,
        trace => 5000,
        debug => 10000,
        info => 20000,
        warn => 30000,
        err => 40000,
        error => 40000,
        fatal => 50000
    );
    logtrace( sprintf( 'numeric_msglevel("%s") called', $msglevel ) );
    if( defined($map{$msglevel}) ) {
        my $ret = $map{$msglevel};
        logtrace( sprintf( 'numeric_msglevel("%s") returns %s', $msglevel, $ret ) );
        return $ret;
    } else {
        # this should be croak(), but we'd need perl-modules for that
        die("undefined msglevel: $msglevel handed to numeric_msglevel");
    }
};

sub syslog_msglevel {
    my ($msglevel) = @_;
    my %map = (
        logtrace => "debug",
        trace => "debug",
        debug => "debug",
        info => "info",
        warn => "warning",
        err => "error",
        error => "error",
        fatal => "crit"
    );
    if( defined($map{$msglevel}) ) {
        return $map{$msglevel};
    } else {
        # this shuld be croak(), but we'd need perl-modules for that
        die("undefined msglevel: $msglevel handed to syslog_msglevel");
    }
};

sub log_to_syslog {
    # use a pipe or system to logger, which is in bsdutils and thus essential
    # use --id=adduser[pid]
    # make logger parameters configurable (--udp, --journald, for example)
    my ($prio, $data) = @_;
    my $facility = 'user';
    # $$ would be $PID of we had English.pm
    my @command= ("logger",
        "--id=". $$,
        "--tag=". progname(),
        "--priority=". $facility.".".$prio,
        $loggerparms, "--",
        $data);
    system(@command) == 0
        or printf STDERR ( gtx("logging to syslog failed: command line %s returned error: %s\n"), join(' ', @command), $?);
}

sub logtrace {
    my (@data ) = @_;

    my $outstring = sprintf(shift(@data),@data);
    if ($logtrace) {
        printf STDOUT ( "logtrace: %s\n", $outstring );
        log_to_syslog( "debug", "logtrace: ". $outstring. "\n" );
    } else {
        if ( $stderrmsglevel eq "logtrace" ) {
            printf STDERR ( "logtrace: ". $outstring. "\n" );
        } elsif ( $stdoutmsglevel eq "logtrace" ) {
            printf STDOUT ( "logtrace: ". $outstring. "\n" );
        }
        if ( $syslogmsglevel eq "logtrace" ) {
            log_to_syslog( "debug", "logtrace: ". $outstring );
        }
    }
}

sub logf {
    my ($msglevel, @data ) = @_;
    my $outstring;
    my $loutstring;
    if ( scalar(@data) == 1 ) {
        logtrace("single element data");
        $outstring = join(" ", @data);
        $loutstring = gettext($outstring);
    } else {
        my $fmt=shift(@data),
        my @dta= map( $_ // "(undef)", @data );
        logtrace("multiple element data: format %s, data %s", $fmt, join("-", @dta));
        $outstring = sprintf( $fmt, @dta );
        $loutstring = sprintf( gettext($fmt), @dta );
    }
    logtrace("outstring %s", $outstring);
    logtrace("loutstring %s", $loutstring);
    if ( numeric_msglevel($msglevel) >= numeric_msglevel($stderrmsglevel) ) {
        printf STDERR ( "%s: %s\n", $msglevel, $loutstring );
    } elsif ( numeric_msglevel($msglevel) >= numeric_msglevel($stdoutmsglevel) ) {
        printf STDOUT ( "%s: %s\n", $msglevel, $loutstring );
    }
    if ( numeric_msglevel($msglevel) >= numeric_msglevel($syslogmsglevel) ) {
        log_to_syslog( syslog_msglevel($msglevel), $outstring );
    }
};

sub log_trace {
    my (@data) = @_;
    logf( "trace", @data);
}

sub log_debug {
    my (@data) = @_;
    logf( "debug", @data);
}

sub log_info {
    my (@data) = @_;
    logf( "info", @data );
}

sub log_warn {
    my (@data) = @_;
    logf( "warn", @data );
}

sub log_err {
    my (@data) = @_;
    logf( "err", @data );
}

sub log_fatal {
    my (@data) = @_;
    logf( "fatal", @data );
}

sub set_msglevel {
    ($stderrmsglevel, $stdoutmsglevel, $syslogmsglevel) = @_;
}

sub set_loggerparms {
    ($loggerparms) = @_;
}

1;

# Local Variables:
# mode:cperl
# End:

# vim: tabstop=4 shiftwidth=4 expandtab
