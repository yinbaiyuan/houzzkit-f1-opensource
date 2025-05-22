#!/usr/bin/perl

use X11::Protocol;
use strict;

use IO::Select;

my $X = new X11::Protocol;

$X->init_extension("RENDER") or die;

my($mono1, $rgb24, $rgba32);

my($formats, $screens, $subpixels) = $X->RenderQueryPictFormats();

print "Formats:\n";
for my $f (@$formats) {
    print "    ", join(", ", @$f), "\n";
    $mono1 = $f->[0] if $f->[2] == 1 and $f->[10] == 1;
    $rgb24 = $f->[0] if $f->[2] == 24 and $f->[3] == 16 and $f->[5] == 8
      and $f->[7] == 0;
    $rgba32 = $f->[0] if $f->[2] == 32 and $f->[3] == 16 and $f->[5] == 8
      and $f->[7] == 0 and $f->[9] == 24;
}
print "Screens:\n";
for my $s (@$screens) {
    my @s = @$s;
    print "    Fallback: $s[0]\n";
    shift @s;
    for my $d (@s) {
	my @d = @$d;
	print "        Depth: $d[0]\n";
	shift @d;
	for my $v (@d) {
	    print "            @$v\n";
	}
    }
}
print "Subpixels:\n";
for my $sp (@$subpixels) {
    print "    $sp\n";
}

my $win = $X->new_rsrc;
$X->CreateWindow($win, $X->root, 'InputOutput', $X->root_depth,
                 'CopyFromParent', (0, 0), 500, 500, 4,
                 'background_pixel' => $X->white_pixel,
                 'bit_gravity' => 'Static',
                 'event_mask' =>
                   $X->pack_event_mask('Exposure', 'KeyPress', 'ButtonPress',
                                       'StructureNotify'));
my($filters, $aliases) = $X->RenderQueryFilters($win);
print "Aliases: " . join(" ", @$aliases), "\n";
print "Filters: " . join(" ", @$filters), "\n";


$X->MapWindow($win);
my $picture = $X->new_rsrc;
$X->RenderCreatePicture($picture, $win, $rgb24);
$X->RenderChangePicture($picture, 'poly_mode' => 'Imprecise');

$X->RenderSetPictureClipRectangles($picture, 0, 0,
                                   [50, 0, 400, 50],
				   [0, 50, 500, 400],
				   [50, 450, 400, 50]);

my $pixmap = $X->new_rsrc;
$X->CreatePixmap($pixmap, $win, 32, 1000, 1000);
my $pix_pict = $X->new_rsrc;
$X->RenderCreatePicture($pix_pict, $pixmap, $rgba32);
$X->RenderFillRectangles('Src', $pix_pict, [0xffff, 0, 0, 0x8000],
			 [0, 0, 1000, 1000]);

my $pixmap2 = $X->new_rsrc;
$X->CreatePixmap($pixmap2, $win, 32, 1000, 1000);
my $pix_pict2 = $X->new_rsrc;
$X->RenderCreatePicture($pix_pict2, $pixmap2, $rgba32);
$X->RenderSetPictureFilter($pix_pict2, "bilinear");
$X->RenderSetPictureFilter($picture, "bilinear");

my $cursor1_pixmap = $X->new_rsrc;
$X->CreatePixmap($cursor1_pixmap, $win, 32, 32, 32);
my $cursor1_pict = $X->new_rsrc;
$X->RenderCreatePicture($cursor1_pict, $cursor1_pixmap, $rgba32);
$X->RenderFillRectangles('Src', $cursor1_pict, [0, 0, 0xffff, 0xffff],
			 [0, 0, 32, 32]);
$X->RenderFillRectangles('Src', $cursor1_pict, [0, 0, 0, 0x4000],
			 [4, 4, 24, 24]);
my $cursor1 = $X->new_rsrc;
$X->RenderCreateCursor($cursor1, $cursor1_pict, 16, 16);

my $cursor2_pixmap = $X->new_rsrc;
$X->CreatePixmap($cursor2_pixmap, $win, 32, 32, 32);
my $cursor2_pict = $X->new_rsrc;
$X->RenderCreatePicture($cursor2_pict, $cursor2_pixmap, $rgba32);
$X->RenderFillRectangles('Src', $cursor2_pict, [0, 0x8000, 0xffff, 0xffff],
			 [0, 0, 32, 32]);
$X->RenderFillRectangles('Src', $cursor2_pict, [0, 0, 0, 0x4000],
			 [4, 4, 24, 24]);
my $cursor2 = $X->new_rsrc;
$X->RenderCreateCursor($cursor2, $cursor2_pict, 16, 16);

my $anim_cursor = $X->new_rsrc;
$X->RenderCreateAnimCursor($anim_cursor, [$cursor1, 500], [$cursor2, 100]);

$X->ChangeWindowAttributes($win, 'cursor' => $anim_cursor);

my $fixed_gs = $X->new_rsrc;
$X->RenderCreateGlyphSet($fixed_gs, $mono1);

my $fixed_font = $X->new_rsrc;
$X->OpenFont($fixed_font, "fixed");

sub pad_bit {
    my($bits) = @_;
#    return join("", map($_ ? "\x80\x00\x00\x00" : "\x00\xff\xff\xff",
#			unpack("b*", $bits)));
    return join("", map($_ . "\0\0\0", split(//, $bits)));
#    return $bits;
}

my @glyphs =
  ([0, 8, 8, 0, 0, 9, 0, pad_bit("\x00\x00\x00\x00\x00\x00\x00\x00")],
   [1, 8, 8, 0, 0, 9, 0, pad_bit("\xff\xff\xff\xff\xff\xff\xff\xff")],
   [2, 8, 8, 0, 0, 9, 0, pad_bit("\xff\x81\x81\x81\x81\x81\x81\xff")]);

$X->RenderAddGlyphs($fixed_gs, $glyphs[0]);
$X->RenderAddGlyphs($fixed_gs, $glyphs[1]);
$X->RenderAddGlyphs($fixed_gs, $glyphs[2]);

$X->event_handler('queue');
my $fds = IO::Select->new($X->connection->fh);

sub draw {
    $X->RenderFillRectangles('Src', $picture, [(0xffff)x4],
			     [0, 0, 500, 500]);
    $X->RenderFillRectangles('Src', $pix_pict, [0xffff, 0, 0, 0x8000],
			     [0, 0, 1000, 1000]);
    $X->RenderFillRectangles('Src', $pix_pict2, [0, 0x8000, 0, 0x8000],
			     [0, 0, 1000, 1000]);

    my @rects;
    for my $i (0 .. 11) {
	for my $j (0 .. 11) {
	    push @rects, [40 * $i, 40 * $j, 35, 35];
	}
    }
    $X->RenderFillRectangles('Over', $picture, [0, 0, 0xffff, 0x8000],
			     @rects);
    @rects = ();
    for my $i (0 .. 11) {
	for my $j (0 .. 11) {
	    push @rects, [40 * $i + 23, 40 * $j + 23, 15, 15];
	}
    }
    $X->RenderFillRectangles('Src', $picture, [0, 0, 0xffff, 0x8000],
			     @rects);

    $X->RenderTriangles('Over', $pix_pict, 500, 500, $picture, 'None',
 			[(250, 100), (100, 350), (400, 350)]);

    $X->RenderTrapezoids('Over', $pix_pict, 240, 0, $picture, 'None',
 			 [100, 200, ((240, 0),(0,500)),((500,500),(260,0))]);

    my @strip;
    for my $i (0 .. 40) {
	push @strip, [300 + 100*sin($i/10), 300 + 100*cos($i/10)];
	push @strip, [300 + 120*sin($i/10 + .05), 300 + 120*cos($i/10 + .05)];
    }

    $X->RenderTriStrip('Over', $pix_pict2, 500, 500, $picture, 'None',
		       @strip);

    my @spiral;
    for my $i (0 .. 40) {
	push @spiral, [150 + (50 + $i*2)*sin($i/10),
		       300 + (50 + $i*2)*cos($i/10)];
    }
    $X->RenderTriFan('Over', $pix_pict2, 500, 500, $picture, 'None',
		     [150, 300], @spiral);

    $X->RenderFillRectangles('Src', $pix_pict2, [0, 0, 0, 0x8000],
			     [0, 0, 1000, 1000]);
    $X->RenderTriangles('Atop', $pix_pict, 500, 500, $pix_pict2, 'None',
 			[(125, 50), (50, 175), (200, 175)]);
    $X->RenderComposite('Over', $pix_pict2, 'None', $picture, 0, 0,
 			0, 0, 200, 240, 250, 250);

    $X->RenderSetPictureTransform($pix_pict2, (0.5, -0.5, 0),
				  (0, 0.5, 0), (0, 0, 0.5));
    $X->RenderComposite('Over', $pix_pict2, 'None', $picture, 0, 0,
  			0, 0, 50, 50, 500, 250);

    $X->RenderCompositeGlyphs8('Over', $pix_pict, $picture, 'None', $fixed_gs,
			       0, 0,
			       [150, 50, "\0\1\2\2\2\1\1\0\0\1\2\2\1"],
			       $fixed_gs,
			       [-100, 50, "\1\2"x10]);

    $X->RenderCompositeGlyphs16('Over', $pix_pict, $picture, 'None', $fixed_gs,
				0, 0,
				[150, 60, pack("S*", 2, 0, 1, 2)]);

    $X->RenderCompositeGlyphs32('Over', $pix_pict, $picture, 'None', $fixed_gs,
				0, 0,
				[150, 70, pack("L*", 2, 1, 0, 2)]);

#     $X->RenderCompositeGlyphs8('Over', $pix_pict, $picture, 'None',
# 			       $fixed_font, 100, 100, [150, 50, "Perl"]);
}

for (;;) {
    my %e;
    $X->handle_input;
    if (%e = $X->dequeue_event) {
	if ($e{'name'} eq "Expose") {
	    draw();
	} elsif ($e{'name'} eq "ButtonPress" or $e{'name'} eq "KeyPress") {
	    exit;
	}
    }
}
