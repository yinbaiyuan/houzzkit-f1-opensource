#!/usr/bin/perl
# $Id: w3mhelp.cgi.in,v 1.29 2007/05/29 11:50:24 inu Exp $

if ( $^O =~ /^(ms)?(dos|win(32|nt)?)/i ) {
  $CYGPATH = 1;
}

$prefix = "/usr";
$datarootdir = "${prefix}/share";
$helpdir = "${datarootdir}/w3m";
if ($CYGPATH) {
  $helpdir = &cygwin_pathconv($helpdir);
}
unshift(@INC, $helpdir);
@docdirs = split(" ", "doc:en_English doc-jp:ja_Japanese doc-de:de_German");

require "w3mhelp-funcname.pl";
require "w3mhelp-funcdesc.en.pl";
$lang = 'en';
$charset = 'US-ASCII';

%htmlesc = (
    '<', '&lt;',
    '>', '&gt;',
    '&', '&amp;'
);

$RC_DIR = '~/.w3m';
$RC_DIR =~ s/^~/$ENV{'HOME'}/;
if ($CYGPATH) {
  $RC_DIR = &cygwin_pathconv("$RC_DIR");
}
$keymap = "$RC_DIR/keymap";
$version = '*unknown*';
if (defined($ENV{'QUERY_STRING'})) {
    print "QUERY_STRING=$ENV{'QUERY_STRING'}\n";
    if ($ENV{'QUERY_STRING'} =~ /(^|&)version=([^&]*)/) {
	$version = $2;
	$version =~ s/\+|%([0-9A-Fa-f][0-9A-Fa-f])/$& eq '+' ? ' ' : pack('C', hex($1))/ge;
	$version =~ s/w3m\///;
    }
    if ($ENV{'QUERY_STRING'} =~ /(^|&)lang=([^&]*)/) {
	local($tlang) = $2;
	$tlang =~ s/\+|%([0-9A-Fa-f][0-9A-Fa-f])/$& eq '+' ? ' ' : pack('C', hex($1))/ge;
	$tlang =~ tr/A-Z/a-z/;
	if ($tlang !~ /^[a-z][a-z]$/) {
	    $tlang = 'en';
	}
	# print "tlang=$tlang\n";
	eval {require "w3mhelp-funcdesc.$tlang.pl";};
	if (%funcdesc) {
	    $lang = $tlang;
	}
    }
}

%f = %keyfunc;
%keyfunc = ();
while (($key, $fname) = each %f) {
	$key = &norm_key($key);
	$keyfunc{$key} = $fname;
}

if (-f $keymap) {
    open(KEYMAP, "< $keymap") || die "cannot open keymap: $keymap, $!";
    &load_keymap(*KEYMAP, $func);
    close(KEYMAP);
}

local (%funckeydesc, $key, $fname, $desc);

%funcname = (%funcname, %buf_funcname, %lineedit_funcname, %menu_funcname);

%funcdesc = (%funcdesc, %buf_funcdesc, %lineedit_funcdesc, %menu_funcdesc);
# sort for consistent order each time this is run
foreach my $fname (sort keys %funcdesc) {
    $funckeydesc{$funcname{$fname}} = "$fname\n$funcdesc{$fname}\n";
}

foreach $key (sort keys %keyfunc) {
    $keydata{$key} && next;
    $funckeydesc{$funcname{$keyfunc{$key}}} .= "$key,";
}
foreach $key (sort keys %buf_keyfunc) {
    $keydata{$key} && next;
    $funckeydesc{$funcname{$buf_keyfunc{$key}}} .= "$key,";
}
foreach $key (sort keys %lineedit_keyfunc) {
    $keydata{$key} && next;
    $funckeydesc{$funcname{$lineedit_keyfunc{$key}}} .= "$key,";
}
foreach $key (sort keys %menu_keyfunc) {
    $keydata{$key} && next;
    $funckeydesc{$funcname{$menu_keyfunc{$key}}} .= "$key,";
}

print <<HEADING;
Content-Type: text/html; charset=$charset

<HTML>
<HEAD>
<TITLE>w3m help page</TITLE>
</HEAD>
<BODY>
<CENTER>
******* 
<A HREF="http://w3m.sourceforge.net/">w3m</A>
 (WWW-wo-Miru)  Version $version by 
<A HREF="mailto:aito\@fw.ipsj.or.jp">A.ITO</A> ********
</CENTER>

HEADING

$q_version = $version;
$q_version =~ s/[^A-Za-z0-9_\$\.\-]/sprintf('%%%02X', ord($&))/ge;
$script = "<A HREF=\"$ENV{'SCRIPT_NAME'}?version=$q_version&amp;lang=";

# doc:en_English doc-jp:ja_Japanese doc-de:de_German
for $otherlang (@docdirs) {
    local(@d) = split(/[:_]/, $otherlang);
    
    if ($d[1] ne $lang) {
	$d[1] =~ s/[^A-Za-z0-9_\$\.\-]/sprintf('%%%02X', ord($&))/ge;
	print $script, $d[1], "\">[$d[2]]</A>\n";
    }
}

$keymap =~ s/[<>&]/$htmlesc{$&}/ge;
$head = 'Current keymap file';
if (defined($title{$head})) {
	$head = $title{$head};
	$head =~ s/[<>&]/$htmlesc{$&}/ge;
}
print "<P><A HREF=\"$keymap\">$head</A>\n";

&show_keymap('In-page Navigation', 
	     split(" ", "pgFore pgBack movR movL movD movU
		movR1 movL1 movD1 movU1 ldown1 lup1
		shiftl shiftr col1L col1R linbeg linend ctrCsrH ctrCsrV
		goLine goLineF goLineL movRW movLW
		topA lastA nextA prevA movlistMn
		nextR nextL nextD nextU nextRD nextLU
		undoPos redoPos cursorTop cursorMiddle cursorBottom"));

&show_keymap('Hyperlink Operations',
	     split(" ", "followA tabA svA followI svI submitForm
		curURL peekURL peekIMG pginfo curlno chkURL chkWORD chkNMID
		rFrame extbrz linkbrz linkLst listMn linkMn accessKey"));

&show_keymap('File/Stream Operations',
	     split(" ", "goURL gorURL tabURL tabrURL ldfile readsh pipesh
		pipeBuf"));

&show_keymap('Buffer Operations',
	     split(" ", "backBf nextBf prevBf goHome selMn selBuf vwSrc svSrc
		svBuf editBf editScr reload reshape rdrwSc dispI stopI"));

&show_keymap('Tab Operations',
	     split(" ", "newT closeT nextT prevT tabMn tabR tabL"));

&show_keymap('Bookmark Management',
	     split(" ", "ldBmark adBmark"));

&show_keymap('Searches',
	     split(" ", "srchfor srchbak srchnxt srchprv isrchfor isrchbak"));

&show_keymap('Dictionary Lookup',
	     split(" ", "dictword dictwordat"));

&show_keymap('Mark Operations',
	     split(" ", "_mark nextMk prevMk reMark"));

&show_keymap('Miscellaneous',
	     split(" ", "mainMn ldhelp ldOpt dispVer cooLst ldHist ldDL
		docCSet defCSet
		msgs msToggle wrapToggle execCmd setAlarm setOpt setEnv defKey
		reinit execsh susp qquitfm quitfm"));

&show_keymap_data('User-defined key bindings');

print "<BR>\n<HR WIDTH=80%>\n";

&show_keymap('Buffer and Tab Selection Mode',
	     split(" ", "buffer_next buffer_prev buffer_delete buffer_go"));

print "<BR>\n<HR WIDTH=80%>\n";

&show_keymap('Input Line Editing Mode',
	     split(" ", "lineedit_forward lineedit_back lineedit_backspace 
		lineedit_delete lineedit_kill_after lineedit_kill_before
		lineedit_top lineedit_bottom lineedit_prev lineedit_next
		lineedit_editor lineedit_complete lineedit_accept"));

print "<BR>\n<HR WIDTH=80%>\n";

&show_keymap('Popup Menu Mode',
	     split(" ", "menu_select menu_close menu_cancel menu_down menu_up
		menu_line_up menu_line_down menu_top menu_last menu_next
		menu_prev menu_search_fore menu_search_back menu_search_next
		menu_search_prev menu_suspend"));

print <<PAGE;
<HR>
</BODY>
</HTML>
PAGE

exit 0;

sub load_keymap {
    local(*FH) = shift;
    local($func) = @_;

    while (<FH>) {
	/^#/ && next;
	s/^\s*keymap\s+// || next;
	s/^(\"(\\\"|[^\"])+\"|\'(\\\'|[^\'])+\'|\S+)\s+(\S+)\s*// || next;
	($key, $fname) = ($1, $4);
	$data = $_;
	$fname =~ tr/a-z/A-Z/;
	defined($funcdesc{$fname}) || next;
	$key =~ s/^["'](.*)["']$/$1/;
	$key = &norm_key($key);
	$keyfunc{$key} = $fname;
	if ($data) {
		$keydata{$key} = $data;
	} else {
		delete $keydata{$key};
	}
    }
}

sub norm_key {
    local($_) = @_;

    s/(ESC|SPC|TAB|DEL|UP|DOWN|RIGHT|LEFT)/\U$1/i;
    s/\\(.)/$1/g;
    s/(^|\s+|-)\^(.)/${1}C-$2/g;
    s/(^|\s+|-)(C-\[|M-)/${1}ESC-/g;
    if (/^ESC-\[/) {
	/^ESC-\[A$/ && return "UP";
	/^ESC-\[B$/ && return "DOWN";
	/^ESC-\[C$/ && return "RIGHT";
	/^ESC-\[D$/ && return "LEFT";
    }
    s/(^|\s+|-)ESC-\[/$1\^\[\[/g;
    s/(^|\s+|-)ESC-\^(.)/${1}ESC-C-$2/g;
    s/(^|\s+|-)(ESC-)?C-[iI]/$1${2}TAB/g;
    s/(^|\s+|-)(ESC-)?C-\?/$1${2}DEL/g;
    return $_;
}

sub show_keymap {
    local($head, @list) = @_;
    local($fid);
    local($attr) = " WIDTH=140";

    if (defined($title{$head})) {
	$head = $title{$head};
	$head =~ s/[<>&]/$htmlesc{$&}/ge;
    }

    print <<PAGE;
<H2>$head</H2>
<table cellpadding=0>
PAGE
    foreach $fid (@list) {
	local ($name, $desc, $keys) = split("\n", $funckeydesc{$fid}, 3);
	$keys =~ s/,$//;
	$keys = '<NOT ASSIGNED>' if ($keys eq '');
	$keys =~ s/[<>&]/$htmlesc{$&}/ge;
	if ($name =~ /:/) {
		$name = "";
	} else {
		$name =~ s/[<>&]/$htmlesc{$&}/ge;
		$name = " (<b>$name</b>)";
	}
	$desc =~ s/[<>&]/$htmlesc{$&}/ge;
	print <<PAGE;
<TR><TD$attr>$keys<TD><NOBR>$desc$name</NOBR>
PAGE
	$attr = "";
    }
    print "</table>\n";
}

sub show_keymap_data {
    local($head, @list) = @_;
    local($fid);
    local($attr) = " WIDTH=140";

    if (defined($title{$head})) {
	$head = $title{$head};
	$head =~ s/[<>&]/$htmlesc{$&}/ge;
    }

    print <<PAGE;
<H2>$head</H2>
<table cellpadding=0>
PAGE
    foreach $keys (sort keys %keydata) {
	$keys =~ s/[<>&]/$htmlesc{$&}/ge;
	$name = $keyfunc{$keys};
	$data = $keydata{$keys};
	$name =~ s/[<>&]/$htmlesc{$&}/ge;
	$data =~ s/[<>&]/$htmlesc{$&}/ge;
	print <<PAGE;
<TR><TD$attr>$keys<TD>$name<TD><NOBR>$data</NOBR>
PAGE
	$attr = "";
    }
    print "</table>\n";
}


sub cygwin_pathconv {
  local($_) = @_;
  local(*CYGPATH);

  open(CYGPATH, '-|') || exec('cygpath', '-w', $_);
  $_ = <CYGPATH>;
  close(CYGPATH);
  s/\r?\n$//;
  s!\\!/!g;
  s!/$!!;
  return $_;
}
