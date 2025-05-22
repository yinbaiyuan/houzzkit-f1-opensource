#!/usr/bin/perl

# This is a virtually complete test of all of the protocol's features
# -- it was used by the author during development. It generates a lot
# of output to STDOUT, uses a bunch of memory, and messes with your
# display in various ways. (Though some of the most egregious have
# been commented out). Run it at your own risk.

use X11::Protocol 0.02;

use X11::Keysyms qw(%Keysyms MISCELLANY XKB_KEYS LATIN1);
%Keysyms_name = reverse %Keysyms;

sub pretty
{
    my($x) = @_;
    if (not ref $x)
    {
	if ($x == 0 and $x ne "0")
	{
	    $x = "..." if $x =~ /[\cA-\cZ]/;
	    print "`$x'";
	}
	else
	{
	    printf "$x=0x%x", $x;
	}
    }
    elsif (ref($x) eq "ARRAY")
    {
	my($i);
	print "[";
	for $i (@$x) { pretty($i); print ", ";}
	print "]";
    }
    elsif (ref($x) eq "HASH" or ref($x) eq "X11::Protocol")
    {
	my($k, $v);
	print "{";
	while (($k, $v) = each(%$x))
	{
	    print "$k => ";
	    pretty($v);
	    print ", ";
	}
	print "}";
    }
    else
    {
	print $x;
    }
}

sub my_sleep {
    my($secs) = @_;
    $x->flush();
    sleep($secs);
}

%opts = @ARGV;
$display = $opts{'-d'} || $opts{'-display'} || $ENV{'DISPLAY'} || ":0.0"; 

$x = X11::Protocol->new($display);
pretty $x;
print "\n";
$win = $x->new_rsrc;
print "$win\n";
$x->error_handler(sub {});
$x->error_handler(\&X11::Protocol::default_error_handler);
sub print_event
{
    my(%e) = @_;
    my($i);
    $last_event_time = $e{'time'} if $e{'time'};
    exit if $e{'name'} eq "KeyPress" and ($e{'detail'} == 24 or $done);
    print delete($e{'name'}), ": ";
    print join(", ", map("$_ $e{$_}", keys %e)), "\n";
}
$x->{'event_handler'} = \&print_event;
#$x->{'event_handler'} = 'queue';

$x->req('CreateWindow', $win, $x->{'root'}, "InputOutput",
	$x->{'root_depth'}, "CopyFromParent",
	(0, 0), 100, 100, 1, "backing_store" => "WhenMapped",
	'background_pixel' => $x->{'white_pixel'});
$x->req('ChangeProperty', $win,
	$x->req('InternAtom', "WM_NAME", 0), 
	$x->req('InternAtom', "STRING", 0), 8, "Replace", "Perl X11 Client");  
$x->req('ChangeWindowAttributes', $win, "event_mask" => #0x01ebffff);
	$x->pack_event_mask('KeyPress', 'KeyRelease', 'ButtonPress',
			    'ButtonRelease', 'EnterWindow', 'LeaveWindow',
			    'PointerMotion', 'ButtonMotion', 'KeymapState',
			    'Exposure', 'VisibilityChange', 'StuctureNotify',
			    'SubstructureNotify', 'FocusChange',
			    'PropertyChange', 'ColormapChange'));
print join " ", $x->req('GetWindowAttributes', $win), "\n";
$x->request('MapWindow', $win);
req $x 'ConfigureWindow', $win, "height" => 200, "width" => 200;
$kid1 = $x->new_rsrc;
$x->req('CreateWindow', $kid1, $win, 'InputOutput', $x->{'root_depth'},
	'CopyFromParent', (50, 50), 75, 75, 4);
$kid2 = $x->new_rsrc;
$x->req('CreateWindow', $kid2, $win, 'InputOutput', $x->{'root_depth'},
	'CopyFromParent', (100, 100), 75, 75, 4);
$x->req('MapSubwindows', $win);
my_sleep 2;
$x->req('CirculateWindow', $win, "LowerHighest");
my_sleep 2;
$x->req('DestroySubwindows', $win);
print join " ", $x->req('GetGeometry', $win), "\n";
print join " ", 
    $x->req('GetGeometry', $x->{'root'}), "\n";
($root, $parent, @kids) = $x->req('QueryTree', $x->{'root'});
for $kid (@kids) {
    print join " ", $x->req('GetGeometry', $kid), "\n";
}
print $x->req('InternAtom', "WM_NAME", 0), "\n";
for $atom (1 .. 90) {
    print "$atom: ", $x->req('GetAtomName', $atom), ", ";
}
print "\n\n";
for $atom ($x->req('ListProperties', $win)) {
    print $x->atom_name($atom), " => ";
    print join(",", $x->req('GetProperty', $win, $atom, "AnyPropertyType",
			    0, 200, 0)), "\n";
}
$root_wid = $x->{'root'};
for (1 .. 10)
{
    my($e) = $x->pack_event('code' => 2, 'detail' => 25, 'time' => 0,
			    'root' => $root_wid, 'event' => $win, 'child' => 0,
			    'root_x' => 100, 'root_y' => 100, 'event_x' => 5,
			    'event_y' => 5, 'state' => 0, 'same_screen' => 1,
			    'synthetic' => 0);
    $x->req('SendEvent', "PointerWindow", 0, 0, $e);
    $x->req('SendEvent', "PointerWindow", 0, 0,
	    $x->pack_event('name' => "KeyRelease", 'detail' => 25, 'time' => 0,
			   'root' => $root_wid, 'event' => $win, 'child' => 0,
			   'root_x' => 100, 'root_y' => 100, 'event_x' => 5,
			   'event_y' => 5, 'state' => 0, 'same_screen' => 1));
}
print "Grabbing...";
$x->req('GrabPointer', $win, 0, 0, 'Asynchronous', 'Asynchronous', $win, 0, 0);
my_sleep 2;
$x->req('UngrabPointer', 0);
print "done.\n";
my_sleep 2;
print "Grabbing server...";
$x->req('GrabServer');
my_sleep 2;
$x->req('UngrabServer');
print "done.\n";
print "->", join(" ", $x->req('QueryPointer', $win)), "\n";
for $motion ($x->req('GetMotionEvents', $last_event_time, 'CurrentTime', $win))
{
    print "$motion->[0]: ($motion->[1], $motion->[2])\n";
}
print "-->", join(" ", $x->req('TranslateCoordinates',
				      $win => $root_wid, 50, 50)), "\n";
for (1 .. 10)
{
    $x->req('WarpPointer', 'None', $root_wid, 0, 0, 0, 0,
	    rand($x->{'width_in_pixels'} * .9),
	    rand($x->{'height_in_pixels'} * .9));
    my_sleep 1;
}
print "--->", join(" ", $x->req('GetInputFocus')), "\n";
print "---->", $x->req('QueryKeymap'), "\n";
$fid = $x->new_rsrc;
$x->req('OpenFont', $fid, 'fixed');
print "`fixed' = $fid\n";

%fixed = $x->req('QueryFont', $fid);
print join(" ", %fixed), "\n";
print join(" ", @{$fixed{'min_bounds'}}), "\n";
print join(" ", @{$fixed{'max_bounds'}}), "\n";
%prop = %{$fixed{'properties'}};
foreach $atom (keys %prop)
{
    print $x->atom_name($atom), " => ", $prop{$atom}, "; ";
}
print "\n"; 
foreach $ci (@{$fixed{'char_infos'}})
{
    print join (" ", @$ci), "; ";
}
print "\n";
print join(" ", $x->req('QueryTextExtents', $fid, "\0H\0e\0l\0l\0o")), "\n";
print join("\n", $x->req('ListFonts', '-adobe-*', 50)), "\n";
foreach $font ($x->req('ListFontsWithInfo', '-adobe-*', 5))
{
    %info = %$font;
    print join(" ", %info), "\n";
    print join(" ", @{$info{'min_bounds'}}), "\n";
    print join(" ", @{$info{'max_bounds'}}), "\n";
    %prop = %{$info{'properties'}};
    foreach $atom (keys %prop)
    {
	print $x->atom_name($atom), " => ", $prop{$atom}, "; ";
    }
    print "\n"; 
}
print join(", ", $x->req('GetFontPath')), "\n";
#$x->req('SetFontPath', $x->req('GetFontPath'));
#print join(", ", $x->req('GetFontPath')), "\n";
$pixmap = $x->new_rsrc;
$x->req('CreatePixmap', $pixmap, $win, $x->{'root_depth'}, 50, 50); 
$x->req('FreePixmap', $pixmap);
$gc = $x->new_rsrc;
$x->req('CreateGC', $gc, $win, 'function' => 'Xor', 'line_width' => 2,
	'join_style' => 'Miter', 'font' => $fid, 'arc_mode' => 'PieSlice',
	'foreground' => $x->{'white_pixel'},
	'background' => $x->{'black_pixel'},
	'graphics_exposures' => 0);
$x->req('ChangeGC', $gc, 'join_style' => 'Round');
$fancy_gc = $x->new_rsrc;
$x->req('CreateGC', $fancy_gc, $win);
$x->req('CopyGC', $gc, $fancy_gc, 'function', 'line_width', 'join_style',
	'font', 'arc_mode', 'background', 'graphics_exposures');
$x->req('ChangeGC', $fancy_gc, 'line_style' => 'OnOffDash');
$x->req('SetDashes', $fancy_gc, 0, (1, 2, 1, 3, 1));
$x->req('SetClipRectangles', $fancy_gc, (0, 0), 'UnSorted', [0, 40, 100, 20],
	[40, 0, 20, 100]);
$x->req('ClearArea', $win, (0, 0), 200, 200, 0);
$white = $x->{'white_pixel'};
$black = $x->{'black_pixel'};
$x->req('ChangeGC', $gc, 'function' => 'Copy', 'background' => $white,
	'foreground' => $black);
for (1 .. 500)
{
    push @points, rand(200);
}
$x->PolyPoint($win, $gc, 'Origin', @points);
for $c (@points)
{
    $c = 200 - $c;
}
$x->PolySegment($win, $gc, @points);
for $c (@points)
{
    $c /= 10;
    $c -= 10;
}
$x->ClearArea($win, (0, 0), 200, 200, 0);
$x->PolyLine($win, $gc, 'Previous', (100, 100), @points);
$x->ChangeGC($gc, 'function' => "Xor");
for (1 .. 200)
{
    $x->req('CopyArea', $win, $win, $gc, (rand(160), rand(160)), 40, 40,
	    (rand(160), rand(160)));
}
$x->req('ChangeGC', $gc, 'function' => "Copy");
for (1 .. 200)
{
    $x->req('CopyPlane', $win, $win, $fancy_gc, (rand(160), rand(160)), 
	    40, 40, (rand(160), rand(160)), 1 << 0);
}
$x->req('ClearArea', $win, (0, 0), 200, 200, 0);
for (1 .. 25)
{
    push @rects, [rand(100), rand(100), rand(100), rand(100)];
}
$x->req('PolyRectangle', $win, $gc, @rects);
for (1 .. 16)
{
    push @arcs, [rand(150), rand(150), 50, 50, 0, rand(360 * 64)];
}
$x->req('PolyArc', $win, $gc, @arcs);
$x->req('FillPoly', $win, $gc, 'Convex', 'Origin',
	(100,0)=>(150,150)=>(0,100));
@rects = ();
for (1 .. 100)
{
    push @rects, [rand(190), rand(190), rand(10), rand(10)];
}
$x->req('PolyFillRectangle', $win, $gc, @rects);
@arcs = ();
for (1 .. 25)
{
    push @arcs, [rand(175), rand(175), 25, 25, 90 * 64, rand(360 * 64)];
}
$x->req('PolyFillArc', $win, $gc, @arcs);
$x->req('ClearArea', $win, (0, 0), 200, 200, 0);
if ($x->{'bitmap_bit_order'} eq 'LeastSignificant' 
    and $x->{'bitmap_scanline_unit'} == 32
    and $x->{'bitmap_scanline_pad'} == 32)
{
    $bmap = 
	"\0\0\xff\xff\xff\xff\x0f\0" x 8 .
	"\0\0\xff\0\0\0\xff\0" x 8 .
	"\0\0\xff\xff\xff\xff\x0f\0" x 8 .
	"\0\0\xff\0\0\0\0\0" x 8 .
	"\0\0\xff\0\0\0\0\0" x 8;
    for $shift (0 .. 3)
    {
	$x->req('PutImage', $win, $gc, 1, 56, 40,
		(0, 2 + 42 * $shift), 8, 'Bitmap', $bmap);
    }
}

if (0) 
{
    $pixmap = 
#        1234567890123456789012345678
	"                            ".
	" ####  ##### ####  #        ".
	" #   # #     #   # #        ".
        " ####  ####  ####  #        ".
	" #     #     #   # #        ".
        " #     ##### #   # #####    ".
	"                            ";

    @pixels = unpack("C*", $pixmap);
    for $p (@pixels)
    {
	$p = 0 if $p == ord("#");
    }
    for (1 .. 50)
    {
	@p = @pixels;
	for $p (@p)
	{
	    $p = rand(256) if $p;
	}
	$x->req('PutImage', $win, $gc, 8, 25, 7,
		(rand(175), rand(193)), 0, 'ZPixmap', pack("C*", @p));
    }
}


($d, $v, $image) = $x->req('GetImage', $win, (0, 0), 79, 24, 0xff, 'ZPixmap');
$image =~ tr/\0/ /;
$image =~ tr/ -~/./c;
for $row (0 .. 23)
{
    print substr($image, $row * 80, 80), "\n";
}
$x->req('ClearArea', $win, (0, 0), 200, 200, 0);
$smallfid = $x->new_rsrc;
$x->req('OpenFont', $smallfid, '6x10');
$x->req('PolyText8', $win, $gc, 2, 20, [0, "Hello, "], 
	$smallfid, [-3, "world!"]);
$x->req('PolyText8', $win, $gc, 2, 35, [0, "Perl " x 300]);
#$largefid = $x->new_rsrc;
#$x->req('OpenFont', $largefid, 
#	'-*-*-medium-r-normal--14-*-*-*-c-*-jisx0208.1983-0');
#$x->req('PolyText16', $win, $gc, 2, 50, $largefid, 
#    [0, "\061\101\061\104\061\106\061\110\061\112\061\113\061\114\061\115"
#     . "\061\116\061\117\061\122\061\125\061\130\061\133"]);
$x->req('ChangeGC', $gc, 'font' => $smallfid);
$x->req('ImageText8', $win, $gc, 2, 70, "Perl");
$x->req('ImageText16', $win, $gc, 2, 80, "\0P\0e\0r\0l");
if ($x->{'root_depth'} == 8) {
    $cmap = $x->new_rsrc;
    $x->req('CreateColormap', $cmap, $x->{'root_visual'}, $win, 'All');
    $new_cmap = $x->new_rsrc;
    $x->req('CopyColormapAndFree', $new_cmap, $cmap);
    $x->req('FreeColormap', $cmap);
}
$cmap = $x->{'default_colormap'};
print join(", ", $x->req('ListInstalledColormaps', $win)), "\n";
print join(", ", $x->req('ListInstalledColormaps', $root_wid)), "\n";
($color1, $r, $g, $b) = $x->req('AllocColor', $cmap, 
				1 * 65535, 0 * 65535, 0 * 65535); 
print "$color1 = ($r, $g, $b)\n";
($color2, $r1, $g1, $b1, $r2, $g2, $b2) = 
    $x->req('AllocNamedColor', $cmap, 'orange');
print "orange =~= $color2 =~= ($r1, $g1, $b1) =~= ($r2, $g2, $b2)\n";
if ($x->{'root_depth'} == 8) {
    ($pixels, $masks) = $x->req('AllocColorCells', $cmap, 1, 0, 0);
    $color3 = $pixels->[0];
    print "$color3\n";
    ($rm, $gm, $bm, @pixels) =
	$x->req('AllocColorPlanes', $cmap, 1, (0,0,1), 0);
    print "$rm|$gm|$bm = ", join(", ", @pixels), "\n";
    $x->req('StoreColors', $cmap, [$color3 => (65535, 0, 0)], 
	    [$pixels[0] => (0, 0, 0), 1]);
    $x->req('StoreNamedColor', $cmap, $color3, 'salmon', 7);
}
@colors = $x->req('QueryColors', $cmap, 0 .. 255);
for $c (@colors)
{
    printf "(0x%04x, 0x%04x, 0x%04x), ", @$c;
    print "\n" unless ++$i % 3;
}
print "\n";
($r1, $g1, $b1, $r2, $g2, $b2) = $x->req('LookupColor', $cmap, 'bisque');
print "bisque =~= ($r1, $g1, $b1) =~= ($r2, $g2, $b2)\n";

$fg_pm = $x->new_rsrc;
$x->send('CreatePixmap', $fg_pm, $win, 1, 16, 16); 
$mask_pm = $x->new_rsrc;
$x->send('CreatePixmap', $mask_pm, $win, 1, 16, 16);
$cursor_gc = $x->new_rsrc;
$x->send('CreateGC', $cursor_gc, $fg_pm, 'line_width' => 2,'foreground' => 0); 
$x->send('PolyFillRectangle', $fg_pm, $cursor_gc, [(0, 0), 16, 16]);
$x->send('PolyFillRectangle', $mask_pm, $cursor_gc, [(0, 0), 16, 16]);
$x->send('ChangeGC', $cursor_gc, 'foreground' => 1);
$x->send('PolyArc', $mask_pm, $cursor_gc, [1, 1, 13, 13, 0, 360*64]);
$x->send('ChangeGC', $cursor_gc, 'line_style' => 'OnOffDash');
$x->send('PolyArc', $fg_pm, $cursor_gc, [1, 1, 13, 13, 0, 360*64]);
$cursor = $x->new_rsrc;
$x->send('CreateCursor', $cursor, $fg_pm, $mask_pm, (65535, 0, 0), 
	 (45000, 45000, 45000), (8, 8));
$x->send('ChangeWindowAttributes', $win, 'cursor' => $cursor);
$x->send('FreePixmap', $fg_pm);
$x->send('FreePixmap', $mask_pm);
$x->send('FreeGC', $cursor_gc);

my_sleep 5;
$cursor_fnt = $x->new_rsrc;
$x->req('OpenFont', $cursor_fnt, 'cursor');
$new_cursor = $x->new_rsrc;
$x->req('CreateGlyphCursor', $new_cursor, $cursor_fnt, $cursor_fnt, 0, 1,
	(65535, 65535, 65535), (0, 0, 0));
$x->req('CloseFont', $cursor_fnt);
$x->req('ChangeWindowAttributes', $win, 'cursor' => $new_cursor);
$x->req('FreeCursor', $cursor);
$cursor = $new_cursor;
for $p (0 .. 10)
{
    $x->req('RecolorCursor', $cursor,
	    (65535, 65535 - $p*6553.5, 65535- $p*6553.5), (0, 0, 0));
    my_sleep 1;
}
($w, $h) = $x->req('QueryBestSize', 'Cursor', $root_wid, 16, 16);
print "$w x $h is a good size for a cursor.\n";

for $ext ($x->req('ListExtensions'))
{
    ($major, $event, $error) = $x->req('QueryExtension', $ext);
    print "$ext: request $major, event $event, error $error\n";
}

($old) = $x->req('GetKeyboardMapping', $x->{'max_keycode'}, 1);
#$x->req('ChangeKeyboardMapping', $x->{'max_keycode'} - 1, 4, 
#	[$Keysyms{"a"}, $Keysyms{"A"}, 0, 0],);

$i = $x->min_keycode;
for $ar ($x->req('GetKeyboardMapping', $x->{'min_keycode'}, 
		 $x->{'max_keycode'} - $x->{'min_keycode'} + 1))
#		 10))
{
    print "$i: ", join(", ", map($Keysyms_name{$_} || 'NoSymbol',
					@$ar)), "\n";
    $i++;
}

#$x->req('ChangeKeyboardMapping', $x->{'max_keycode'}, scalar(@$old), $old);

%kc = $x->req('GetKeyboardControl');
print join(" ", %kc), "\n";
$bp = $kc{'bell_pitch'};

$x->req('Bell', 100);
$x->req('ChangeKeyboardControl', 'bell_pitch' => 2 * $bp);
my_sleep 1;
$x->req('Bell', 100);
$x->req('ChangeKeyboardControl', 'bell_pitch' => $bp);

($num, $denom, $thresh) = $x->req('GetPointerControl');
print "Acceleration: $num/$denom; Threshold: $thresh\n";
$x->req('ChangePointerControl', 1, 0, $num * 2, $denom, $thresh);
my_sleep 2;
$x->req('ChangePointerControl', 1, 0, $num, $denom, $thresh);

($t_out, $interv, $pb, $allow_exp) = $x->req('GetScreenSaver');
print "Timeout: $t_out, Interval: $interv, Blanking: $pb, ";
print "Exposures: $allow_exp\n";
$x->req('SetScreenSaver', $t_out, $interv, $pb, $allow_exp);
($t_out, $interv, $pb, $allow_exp) = $x->req('GetScreenSaver');
print "Timeout: $t_out, Interval: $interv, Blanking: $pb, ";
print "Exposures: $allow_exp\n";

#$addr = pack("C4", (127, 0, 0, 1));
#sen('ChangeHosts', 'Insert', 'Internet', $addr);
($mode, @hosts) = $x->req('ListHosts');
for $ar (@hosts)
{
    print "$ar->[0]: ", join(".", unpack("C4", $ar->[1])), "\n";
}

$x->req('SetAccessControl', $mode);
$x->req('SetCloseDownMode', 'Destroy');
#$x->req('KillClient', 0x200004b);
$x->req('RotateProperties', $win, 1, ($x->req('InternAtom', 'WM_NAME', 1)));
$x->req('ForceScreenSaver', 'Activate');
@map = $x->req('GetPointerMapping');
print join(", ", @map), "\n";
$x->req('SetPointerMapping', @map);
@map = $x->req('GetModifierMapping');
for $ar (@map)
{
    print "[", join(",", @$ar), "]\n";
}
#$x->req('SetModifierMapping', @map);

$x->req('NoOperation', 4);

if ($x->{'root_depth'} == 8) {
    $x->req('FreeColors', $cmap, 0, $color1, $color2, $color3, @pixels);
} else {
    $x->FreeColors($cmap, 0, $color1, $color2);
}
$x->req('FreeGC', $fancy_gc);
$x->req('CloseFont', $fid);
$x->req('CloseFont', $smallfid);
#$x->req('CloseFont', $largefid);

$x->init_extensions;

if ($x->{'ext'}{"SHAPE"})
{
    $x->req('ShapeSelectInput', $win, 1);
    $x->req('ShapeRectangles', $win, 'Bounding', 'Set', (0, 0), 'UnSorted',
	    [(0, 0), 50, 50], [(50, 50), 50, 50]);
    $shape_pm = $x->new_rsrc;
    $x->req('CreatePixmap', $shape_pm, $win, 1, 100, 100);
    $shape_gc = $x->new_rsrc;
    $x->req('CreateGC', $shape_gc, $shape_pm, 'foreground' => 0);
    $x->req('PolyFillRectangle', $shape_pm, $shape_gc, [0, 0, 100, 100]);
    $x->req('ChangeGC', $shape_gc, 'foreground' => 1);
    $x->req('PolyFillArc', $shape_pm, $shape_gc, [0, 0, 100, 100, 0, 360*64]);
    $x->req('ShapeMask', $win, 'Bounding', 'Union', 100, 100, $shape_pm);
    $x->req('ShapeCombine', $win, 'Bounding', 'Invert', 0, 0, $x->{'root'},
	    'Bounding');
    $x->req('ShapeOffset', $win, 'Bounding', 25, 25);
    print join(", ", $x->req('ShapeQueryExtents', $win)), "\n";
    print $x->req('ShapeInputSelected', $win), "\n";
    ($ordering, @rects) = $x->req('ShapeGetRectangles', $win, 'Bounding');
    print "Ordering: $ordering\n";
    for $rr (@rects)
    {
	print "[", join(", ", @$rr), "], ";
    }
    print "\n";
}

# This should be last, since it's a REAL memory hog.
if ($x->{'ext'}{'BIG_REQUESTS'})
{
    print "Maximum request length: ", $x->maximum_request_length * 4, "\n";
    for $i (1 .. 65536)
    {
        push @points, int(rand(200)), int(rand(200));
    }
    $x->PolyPoint($win, $gc, 'Origin', @points);
}

#print_event(%e) while %e = $x->dequeue_event;
#$x->{'event_handler'} = \&print_event; 

$x->req('FreeGC', $gc);

$done = 1;
$x->handle_input while 1;
#print_event(%e) while %e = $x->next_event
