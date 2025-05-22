package Debian::AdduserCommon 3.136;
use 5.32.0;
use strict;
use warnings;

# Subroutines shared by the "adduser" and "deluser" utilities.
#
# Copyright (C) 2000-2004 Roland Bauerschmidt <rb@debian.org>
#               2005-2023 Marc Haber <mh+debian-packages@zugschlus.de>
#               2023 Guillem Jover <guillem@debian.org>
#               2021-2022 Jason Franklin <jason@oneway.dev>
#               2022 Matt Barry <matt@hazelmollusk.org>
#               2016 Nis Martensen <nis.martensen@web.de>
#               2016 Afif Elghraoui <afif@debian.org>
#               2005-2009 Joerg Hoh <joerg@joerghoh.de>
#               2008 Stephen Gran <sgran@debian.org>
#
# Someo of the subroutines here are adopted from Debian's
# original "adduser" program.
#
#   Copyright (C) 1997-1999 Guy Maor <maor@debian.org>
#
#   Copyright (C) 1995 Ted Hajek <tedhajek@boombox.micro.umn.edu>
#                      Ian A. Murdock <imurdock@gnu.ai.mit.edu>
#
# License: GPL-2+

use parent qw(Exporter);

use Fcntl qw(:flock SEEK_END);

use Debian::AdduserLogging 3.136;
use Debian::AdduserRetvalues 3.136;
BEGIN {
    if ( Debian::AdduserLogging->VERSION != version->declare('3.136') ||
         Debian::AdduserRetvalues->VERSION != version->declare('3.136') ) {
           die "wrong module version in adduser, check your packaging or path";
    }
}

use vars qw(@EXPORT $VAR1);

BEGIN {
    local $ENV{PERL_DL_NONLAZY}=1;
    # we need to use eval expression form here, perl cookbok 12.2.3
    eval " use Locale::gettext; "; ## no critic
    if ($@) {
        *gettext = sub { shift };
        *textdomain = sub { "" };
        *LC_MESSAGES = sub { 5 };
    } else {
        textdomain("adduser");
    }
}

my $lockfile;
my $lockfile_path = '/run/adduser';

@EXPORT = (
    'get_group_members',
    'read_config',
    'read_pool',
    'systemcall',
    'systemcall_or_warn',
    'systemcall_silent',
    'systemcall_silent_error',
    'acquire_lock',
    'release_lock',
    'preseed_config',
    'which',
);


# parse the configuration file
# parameters:
#  -- filename of the configuration file
#  -- a hash for the configuration data
sub read_config {
    my ($conf_file, $configref) = @_;
    my ($var, $lcvar, $val);

    if (! -f $conf_file) {
        log_info( mtx("`%s' does not exist. Using defaults."), $conf_file );
        return;
    }

    my $conffh;
    unless( open ($conffh, q{<}, $conf_file) ) {
       log_fatal( mtx("cannot open configuration file %s: `%s'\n"), $conf_file, $! );
       exit( RET_CONFFILE );
    }
    while (<$conffh>) {
        chomp;
        next if /^#/ || /^\s*$/;

        if ((($var, $val) = m/^\s*([_a-zA-Z0-9]+)\s*=\s*(.*)/) != 2) {
            log_warn( mtx("Couldn't parse `%s', line %d."), $conf_file, $. );
            next;
        }
        $lcvar = lc $var;
        if (!exists($configref->{$lcvar})) {
            log_warn( mtx("Unknown variable `%s' at `%s', line %d."), $var, $conf_file, $. );
            next;
        }

        $val =~ s/^"(.*)"$/$1/;
        $val =~ s/^'(.*)'$/$1/;

        $configref->{$lcvar} = $val;
    }

    close $conffh || die "$!";
}

# read names and IDs from a pool file
# parameters:
#  -- filename of the pool file, or directory containing files
#  -- a hash for the pool data
sub read_pool {
    my ($pool_file, $type, $poolref) = @_;
    my ($name, $id, $comment, $home, $shell);
    my %ids = ();
    my %new;

    if (-d $pool_file) {
        my $dir;
        unless( opendir( $dir, $pool_file) ) {
            log_fatal( mtx("Cannot read directory `%s'"), $pool_file );
            exit( RET_POOLFILE );
        }
        my @files = readdir ($dir);
        closedir ($dir);
        foreach (sort @files) {
            next if (/^\./);
            next if (!/\.conf$/);
            my $file = "$pool_file/$_";
            next if (! -f $file);
            read_pool ($file, $type, $poolref);
        }
        return;
    }
    if (! -f $pool_file) {
        log_warn( mtx("`%s' does not exist."), $pool_file );
        return;
    }
    my $pool;
    unless( open( $pool, q{<}, $pool_file) ) {
        log_fatal( mtx("Cannot open pool file %s: `%s'"), $pool_file, $!);
        exit( RET_POOLFILE );
    }
    while (<$pool>) {
        chomp;
        next if /^#/ || /^\s*$/;

        my $new;

        if ($type eq "uid") {
            ($name, $id, $comment, $home, $shell) = split (/:/);
            if (!$name || $name !~ /^([_a-zA-Z0-9-]+)$/ ||
                !$id || $id !~ /^(\d+)$/) {
                log_warn( mtx("Couldn't parse `%s', line %d."), $pool_file, $.);
                next;
            }
            $new = {
                'id' => $id,
                'comment' => $comment,
                'home' => $home,
                'shell' => $shell
            };
        } elsif ($type eq "gid") {
            ($name, $id) = split (/:/);
            if (!$name || $name !~ /^([_a-zA-Z0-9-]+)$/ ||
                !$id || $id !~ /^(\d+)$/) {
                log_warn( mtx("Couldn't parse `%s', line %d."), $pool_file, $. );
                next;
            }
            $new = {
                'id' => $id,
            };
        } else {
            log_fatal( mtx("Illegal pool type `%s' reading `%s'."), $type, $pool_file );
            exit( RET_POOLFILE_FORMAT );
        }
        if (defined($poolref->{$name})) {
            log_fatal( mtx("Duplicate name `%s' at `%s', line %d."), $name, $pool_file, $. );
            exit( RET_POOLFILE_FORMAT );
        }
        if (defined($ids{$id})) {
            log_fatal( mtx("Duplicate ID `%s' at `%s', line %d."), $id, $pool_file, $. );
            exit( RET_POOLFILE_FORMAT );
        }

        $poolref->{$name} = $new;
    }

    close $pool || die "$!";
}

sub get_group_members
{
    my $group = shift;

    my @members;

    foreach my $member (split(/ /, (getgrnam($group))[3])) {
        push(@members, $member) if defined(getpwnam($member));
    }

    return @members;
}

sub systemcall {
    my $c = join(' ', @_);
    log_debug( "$c" );
    if (system(@_)) {
        if ($?>>8) {
            log_fatal( mtx("`%s' returned error code %d. Exiting."), $c, $?>>8 );
            exit( RET_SYSTEMCALL_ERROR );
        }
        log_fatal( mtx("`%s' exited from signal %d. Exiting."), $c, $?&127 );
        exit( RET_SYSTEMCALL_SIGNAL );
    }
}

sub systemcall_or_warn {
    my $command = join(' ', @_);
    log_info( "executing systemcall: %s", $command );
    system(@_);

    if ($? == -1) {
        log_warn( mtx("`%s' failed to execute. %s. Continuing."), $command, $! );
    } elsif ($? & 127) {
        log_warn( mtx("`%s' killed by signal %d. Continuing."), $command, ($? & 127) );
    } elsif ($? >> 8) {
        log_warn( mtx("`%s' failed with status %d. Continuing."), $command, ($? >> 8) );
    }

    return $?;
}

sub systemcall_silent {
    my $pid = fork();

    if( !defined($pid) ) {
        return -1;
    }

    if ($pid) {
        wait;
        return $?;
    }

    open(STDOUT, '>>', '/dev/null');
    open(STDERR, '>>', '/dev/null');

    # TODO: report exec() failure to parent
    exec(@_) or exit(1);
}

sub systemcall_silent_error {
    my $command = join(' ', @_);
    my $output = `$command >/dev/null 2>&1`;
    return $?;
}

sub which {
    my ($progname, $nonfatal) = @_ ;
    for my $dir (split /:/, $ENV{"PATH"}) {
        if (-x "$dir/$progname" ) {
            return "$dir/$progname";
        }
    }
    unless( $nonfatal ) {
        log_fatal( mtx("Could not find program named `%s' in \$PATH."), $progname );
        exit( RET_EXEC_NOT_FOUND );
    }
    return 0;
}


# preseed the configuration variables
# then read the config file /etc/adduser and overwrite the data hardcoded here
# we cannot give defaults for users_gid and users_group here since this will
# probably lead to double defined users_gid and users_group.
sub preseed_config {
    my ($conflistref, $configref) = @_;
    my %config_defaults = (
        system => 0,
        only_if_empty => 0,
        remove_home => 0,
        home => "",
        remove_all_files => 0,
        backup => 0,
        backup_to => ".",
        dshell => "/bin/bash",
        first_system_uid => 100,
        last_system_uid => 999,
        first_uid => 1000,
        last_uid => 59999,
        first_system_gid => 100,
        last_system_gid => 999,
        first_gid => 1000,
        last_gid => 59999,
        dhome => "/home",
        skel => "/etc/skel",
        usergroups => "yes",
        users_gid => undef,
        users_group => undef,
        grouphomes => "no",
        letterhomes => "no",
        quotauser => "",
        dir_mode => "0750",
        sys_dir_mode => "0750",
        setgid_home => "no",
        no_del_paths => "^/bin\$ ^/boot\$ ^/dev\$ ^/etc\$ ^/initrd ^/lib ^/lost+found\$ ^/media\$ ^/mnt\$ ^/opt\$ ^/proc\$ ^/root\$ ^/run\$ ^/sbin\$ ^/srv\$ ^/sys\$ ^/tmp\$ ^/usr\$ ^/var\$ ^/vmlinu",
        name_regex => "^[a-z][a-z0-9_-]*\\\$?\$",
        sys_name_regex => "^[A-Za-z_][-A-Za-z0-9_]*\\\$?\$",
        exclude_fstypes => "(proc|sysfs|usbfs|devpts|devtmpfs|devfs|afs)",
        skel_ignore_regex => "\.(dpkg|ucf)-(old|new|dist)\$",
        extra_groups => "users",
        add_extra_groups => 0,
        use_extrausers => 0,
        uid_pool => "",
        gid_pool => "",
        loggerparms => "",
        logmsglevel => "info",
        stdoutmsglevel => "warn",
        stderrmsglevel => "warn"
    );

    # Initialize to the set of known variables.
    foreach (keys %config_defaults) {
        $configref->{$_} = $config_defaults{$_};
    }

    # Read the configuration files
    foreach( @$conflistref ) {
        log_debug( "read configuration file %s\n", $_ );
        read_config($_,$configref);
    }
}

sub acquire_lock {
    my @notify_secs = (1, 3, 8, 18, 28);
    my ($wait_secs, $timeout_secs) = (0, 30);

    unless( open($lockfile, '>>', $lockfile_path) ) {
        log_fatal( mtx("could not open lock file %s!"), $lockfile_path );
        exit( RET_LOCKFILE );
    }

    while (!flock($lockfile, LOCK_EX | LOCK_NB)) {
        if ($wait_secs == $timeout_secs) {
            log_fatal( mtx("Could not obtain exclusive lock, please try again shortly!") );
            exit( RET_LOCKFILE );
        } elsif (grep @notify_secs, $wait_secs) {
            log_warn( mtx("Waiting for lock to become available...") );
        }
        sleep 1;
        $wait_secs++;
    }

    unless( seek($lockfile, 0, SEEK_END) ) {
        log_fatal( mtx("could not seek - %s!"), $lockfile_path );
        exit( RET_LOCKFILE );
    }
}

sub release_lock {
    my $nonfatal = shift || 0;
    return if ($nonfatal && !$lockfile);
    unless( $lockfile ) {
        log_fatal( mtx("could not find lock file!") );
        exit( RET_LOCKFILE );
    }
    if( defined(fileno($lockfile)) ) {
        unless( flock($lockfile, LOCK_UN) or $nonfatal ) {
            log_fatal( mtx("could not unlock file %s: %s"), $lockfile_path, $! );
            exit( RET_LOCKFILE );
        }
    }
    unless( close($lockfile) or $nonfatal ) {
        log_fatal( mtx("could not close lock file %s: %s"), $lockfile_path, $! );
        exit( RET_LOCKFILE );
    }
}

END {
    release_lock(1);
}

1;

# Local Variables:
# mode:cperl
# End:

# vim: tabstop=4 shiftwidth=4 expandtab
