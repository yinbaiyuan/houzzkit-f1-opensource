#!/usr/bin/perl

use strict;

use X11::Protocol;
use IO::Select;
use Time::HiRes 'gettimeofday';

sub min { $_[0] <= $_[1] ? $_[0] : $_[1] }
sub max { $_[0] >= $_[1] ? $_[0] : $_[1] }

my $X = new X11::Protocol;
$X->init_extension("RENDER") or die "The Render extension is required";

my($rgba32, $screen_fmt);

my($formats, $screens,) = $X->RenderQueryPictFormats();
for my $f (@$formats) {
    $rgba32 = $f->[0] if $f->[2] == 32 and $f->[3] == 16 and $f->[5] == 8
      and $f->[7] == 0 and $f->[9] == 24;
}
for my $s (@$screens) {
    my @s = @$s;
    shift @s;
    for my $d (@s) {
	my @d = @$d;
	next unless shift(@d) == $X->root_depth;
	for my $v (@d) {
	    if ($v->[0] == $X->root_visual) {
		$screen_fmt = $v->[1];
	    }
	}
    }
}

my $size = 70;
my($width_fact, $radius, $tick_size, $depth);
use constant PI => 4*atan2(1,1);

sub tri_to_traps {
    my($x1, $y1, $x2, $y2, $x3, $y3) = @_;
    my @points = ([$x1, $y1], [$x2, $y2], [$x3, $y3]);
    @points = sort {$a->[1] <=> $b->[1]} @points;
    ($x1, $y1, $x2, $y2, $x3, $y3) =
      (@{$points[0]}, @{$points[1]}, @{$points[2]});
    my($trap1, $trap2);
    if (($x2-$x1)*($y3-$y1) < ($x3-$x1)*($y2-$y1)) {
        $trap1 = [$y1, $y2, ($x1, $y1), ($x2, $y2), ($x1, $y1), ($x3, $y3)];
        $trap2 = [$y2, $y3, ($x2, $y2), ($x3, $y3), ($x1, $y1), ($x3, $y3)];
    } else {
        $trap1 = [$y1, $y2, ($x1, $y1), ($x3, $y3), ($x1, $y1), ($x2, $y2)],
        $trap2 = [$y2, $y3, ($x1, $y1), ($x3, $y3), ($x2, $y2), ($x3, $y3)];
    }
    return ($trap1, $trap2);
}

sub render_tri {
    my($op, $src_pict, $src_x, $src_y, $dst_pict, $mask, $tri) = @_;
    my($trap1, $trap2) = tri_to_traps(@$tri);
    $X->RenderTrapezoids($op, $src_pict, $src_x, $src_y, $dst_pict,
			 $mask, $trap1, $trap2);
#    $X->RenderTriangles($op, $src_pict, $src_x, $src_y, $dst_pict, $mask,
#			$tri);
}

sub render_quad {
    my($op, $src_pict, $src_x, $src_y, $dst_pict, $mask, @points) = @_;
    render_tri($op, $src_pict, $src_x, $src_y, $dst_pict, $mask,
	       [@points[0,1, 2,3, 4,5]]);
    render_tri($op, $src_pict, $src_x, $src_y, $dst_pict, $mask,
	       [@points[0,1, 4,5, 6,7]]);
}

sub polar2rect {
    my($r, $theta) = @_;
    my $x = $size/2 + $r * sin($theta);
    my $y = $size/2 - $r * cos($theta);
    return ($x, $y);
}

my $win = $X->new_rsrc;
$X->CreateWindow($win, $X->root, 'InputOutput', $X->root_depth,
                 'CopyFromParent', (0, 0), $size, $size, 0,
                 'background_pixel' => $X->white_pixel,
                 'event_mask' =>
                   $X->pack_event_mask('Exposure', 'KeyPress', 'ButtonRelease',
                                       'StructureNotify'));

$X->ChangeProperty($win, $X->atom('WM_ICON_NAME'),
                   $X->atom('STRING'), 8, 'Replace', "render-clock");
$X->ChangeProperty($win, $X->atom('WM_NAME'), $X->atom('STRING'),
                   8, 'Replace', "Rendered Clock");
$X->ChangeProperty($win, $X->atom('WM_NORMAL_HINTS'),
                   $X->atom('WM_SIZE_HINTS'), 32, 'Replace',
                   pack("Lx40llllx12", 128, 1, 1, 1, 1));
$X->ChangeProperty($win, $X->atom('WM_HINTS'), $X->atom('WM_HINTS'),
                   32, 'Replace', pack("IIIx24", 1|2, 1, 1));

my $delete_atom = $X->atom('WM_DELETE_WINDOW');
$X->ChangeProperty($win, $X->atom('WM_PROTOCOLS'), $X->atom('ATOM'),
                   32, 'Replace', pack("L", $delete_atom));

my $progname = $0;
$progname =~ s[^.*/][];
$progname = $ENV{'RESOURCE_NAME'} || $progname;

$X->ChangeProperty($win, $X->atom('WM_CLASS'), $X->atom('STRING'),
                   8, 'Replace', "$progname\0Render-clock");

my($tick_color, $minute_color, $hour_color, $second_color);

#                Red    Green  Blue   Opacity
# $tick_color   = [0,     0,     0,     0xffff];
# $minute_color = [0xffff,0,     0,     0x8000];
# $hour_color   = [0,     0xffff,0,     0x8000];
# $second_color = [0,     0,     0xffff,0x8000];

# #                Red    Green  Blue   Opacity
# $tick_color   = [0,     0,     0,     0xffff];
# $minute_color = [0,     0,     0,     0x8000];
# $hour_color   = [0,     0,     0,     0x8000];
# $second_color = [0,     0,     0,     0x8000];

# #                Red    Green  Blue   Opacity
# $tick_color   = [0,     0,     0,     0xffff];
# $minute_color = [0,     0,     0x4fff,0x8000];
# $hour_color   = [0,     0,     0x4fff,0x8000];
# $second_color = [0,     0,     0x4fff,0x8000];

#                Red    Green  Blue   Opacity
$tick_color   = [0,     0,     0,     0xffff];
$minute_color = [0xffff,0,     0,     0x8000];
$hour_color   = [0,     0x4fff,0,     0x8000];
$second_color = [0,     0,     0x4fff,0x8000];


my($face_pixmap, $face_pict);

my $black_pixmap = $X->new_rsrc;
$X->CreatePixmap($black_pixmap, $win, 32, 1, 1);
my $black_pict = $X->new_rsrc;
$X->RenderCreatePicture($black_pict, $black_pixmap, $rgba32, 'repeat' => 1);
$X->RenderFillRectangles('Src', $black_pict, $tick_color, [0, 0, 1, 1]);

my $red_pixmap = $X->new_rsrc;
$X->CreatePixmap($red_pixmap, $win, 32, 1, 1);
my $red_pict = $X->new_rsrc;
$X->RenderCreatePicture($red_pict, $red_pixmap, $rgba32, 'repeat' => 1);
$X->RenderFillRectangles('Src', $red_pict, $minute_color, [0, 0, 1, 1]);

my $green_pixmap = $X->new_rsrc;
$X->CreatePixmap($green_pixmap, $win, 32, 1, 1);
my $green_pict = $X->new_rsrc;
$X->RenderCreatePicture($green_pict, $green_pixmap, $rgba32, 'repeat' => 1);
$X->RenderFillRectangles('Src', $green_pict, $hour_color, [0, 0, 1, 1]);

my $blue_pixmap = $X->new_rsrc;
$X->CreatePixmap($blue_pixmap, $win, 32, 1, 1);
my $blue_pict = $X->new_rsrc;
$X->RenderCreatePicture($blue_pict, $blue_pixmap, $rgba32, 'repeat' => 1);
$X->RenderFillRectangles('Src', $blue_pict, $second_color, [0, 0, 1, 1]);

my $hilite_pixmap = $X->new_rsrc;
$X->CreatePixmap($hilite_pixmap, $win, 32, 1, 1);
my $hilite_pict = $X->new_rsrc;
$X->RenderCreatePicture($hilite_pict, $hilite_pixmap, $rgba32, 'repeat' => 1);

my($buffer_pixmap, $buffer_pict);

sub setup_face {
    $width_fact = 2;
    $radius = 0.475 * $size;
    $tick_size = $size / 10;
    $depth = $size / 150;

    if ($face_pixmap) {
	$X->FreePixmap($face_pixmap);
	$X->RenderFreePicture($face_pict);
    } else {
	$face_pixmap = $X->new_rsrc;
	$face_pict = $X->new_rsrc;
    }
    $X->CreatePixmap($face_pixmap, $win, 32, $size, $size);
    $X->RenderCreatePicture($face_pict, $face_pixmap, $rgba32,
			    'poly_edge' => 'Smooth', 'poly_mode' => 'Precise');
    $X->RenderFillRectangles('Src', $face_pict, [0xefff,0xefff,0xefff,0xffff],
			     [0, 0, $size, $size]);

    for my $tick (0 .. 59) {
	my $theta = $tick/30 * PI;
	my $size_outer = 0.01;
	my $inner_rad;
	if ($tick % 5) {
	    $inner_rad = $radius - $tick_size/2;
	} else {
	    $inner_rad = $radius - $tick_size;
	}
	my $size_inner = $size_outer * ($radius/$inner_rad);
	my($x1, $y1) = polar2rect($radius, $theta - $size_outer);
	my($x2, $y2) = polar2rect($radius, $theta + $size_outer);
	my($x3, $y3) = polar2rect($inner_rad, $theta + $size_inner);
	my($x4, $y4) = polar2rect($inner_rad, $theta - $size_inner);
	render_quad('Over', $black_pict, $size, $size, $face_pict, 'None',
		    ($x1, $y1), ($x2, $y2), ($x3, $y3), ($x4, $y4));
    }
    #$X->RenderFillRectangles('Over', $face_pict, [0,0,0,0xffff],
    #			 [$size/2-5, $size/2-5, 10, 10]);

    if ($buffer_pixmap) {
	$X->FreePixmap($buffer_pixmap);
	$X->RenderFreePicture($buffer_pict);
    } else {
	$buffer_pixmap = $X->new_rsrc;
	$buffer_pict = $X->new_rsrc;
    }
    $X->CreatePixmap($buffer_pixmap, $win, $X->root_depth, $size, $size);
    $X->RenderCreatePicture($buffer_pict, $buffer_pixmap, $screen_fmt,
			    'poly_edge' => 'Smooth', 'poly_mode' => 'Precise');
}

setup_face();

my $copy_gc = $X->new_rsrc;
$X->CreateGC($copy_gc, $win);

$X->MapWindow($win);

sub draw_hand {
    my($pict, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4) = @_;
    my @p = ([$x1, $y1], [$x2, $y2], [$x3, $y3], [$x4, $y4]);
    my @ip;
    $#ip = $#p;
    for my $j (-2 .. $#p - 2) {
	my($ix, $iy) = ($p[$j+1][0] - $p[$j][0], $p[$j+1][1] - $p[$j][1]);
        my($ox, $oy) = ($p[$j+2][0] - $p[$j+1][0], $p[$j+2][1] - $p[$j+1][1]);
        if ($ix*$oy > $iy*$ox) {
            $ix = -$ix; $iy = -$iy;
        } else {
            $ox = -$ox; $oy = -$oy;
        }
        my($in) = sqrt($ix*$ix + $iy*$iy); $ix /= $in; $iy /= $in;
        my($on) = sqrt($ox*$ox + $oy*$oy); $ox /= $on; $oy /= $on;
        my($mx, $my) = (($ix + $ox)/2, ($iy + $oy)/2);
        my($mn) = max(abs($mx), abs($my)); $mx /= $mn; $my /= $mn;
        $ip[$j+1][0] = $p[$j+1][0] + $depth * $mx;
        $ip[$j+1][1] = $p[$j+1][1] + $depth * $my;

    }
    render_quad('Over', $pict, $size, $size, $buffer_pict, 'None',
		($x1, $y1), ($x2, $y2), ($x3, $y3), ($x4, $y4));
    for my $j (-1 .. $#p - 1) {
	my $angle = atan2($p[$j+1][1]-$p[$j][1], $p[$j+1][0]-$p[$j][0]);
	my $gray = 0x8000 + 0x4000 * sin($angle + 3*PI / 4);
	my $alpha = 0.5;
	$X->RenderFillRectangles('Src', $hilite_pict,
				 [$gray, $gray, $gray,
				  $alpha*0xffff],
				 [0, 0, 1, 1]);
	render_quad('Over', $hilite_pict, $size, $size, $buffer_pict, 'None',
		    @{$p[$j]}, @{$ip[$j]}, @{$ip[$j + 1]}, @{$p[$j + 1]});
    }
}

sub draw {
    $X->RenderFillRectangles('Src', $buffer_pict,
			     [0xffff, 0xffff, 0xffff, 0xffff],
			     [0, 0, $size, $size]);
    $X->RenderComposite('Over', $face_pict, 'None', $buffer_pict, 0, 0,
			0, 0, 0, 0, $size, $size);

    my($unix_time, $microsec) = gettimeofday();
    my($sec, $min, $hour) = localtime($unix_time);
    $sec += $microsec / 1_000_000;

    {
	my $hour_theta = ($hour % 12 + $min/60 + $sec/3600)/6 * PI;
	my $hour_size_outer = 0.04 * $width_fact;
	my $hour_size_inner = $hour_size_outer * (.6/.3) * 1.4;
	my($x1, $y1) = polar2rect(.6*$radius, $hour_theta - $hour_size_outer);
	my($x2, $y2) = polar2rect(.6*$radius, $hour_theta + $hour_size_outer);
	my($x3, $y3) = polar2rect(-.3*$radius, $hour_theta - $hour_size_inner);
	my($x4, $y4) = polar2rect(-.3*$radius, $hour_theta + $hour_size_inner);
	draw_hand($green_pict,
		  ($x1, $y1), ($x2, $y2), ($x3, $y3), ($x4, $y4));
    }

    {
	my $min_theta = ($min + $sec/60)/30 * PI;
	my $min_size_outer = 0.02 * $width_fact;
	my $min_size_inner = $min_size_outer * (.8/.2) * 1.3;
	my($x1, $y1) = polar2rect(.8*$radius, $min_theta - $min_size_outer);
	my($x2, $y2) = polar2rect(.8*$radius, $min_theta + $min_size_outer);
	my($x3, $y3) = polar2rect(-.2*$radius, $min_theta - $min_size_inner);
	my($x4, $y4) = polar2rect(-.2*$radius, $min_theta + $min_size_inner);
	draw_hand($red_pict,
		  ($x1, $y1), ($x2, $y2), ($x3, $y3), ($x4, $y4));
    }

    {
	my $sec_theta = $sec/30 * PI;
	my $sec_size_outer = 0.01 * $width_fact;
	my $sec_size_inner = $sec_size_outer * (.95/.15) * 1.3;
	my($x1, $y1) = polar2rect(.95*$radius, $sec_theta - $sec_size_outer);
	my($x2, $y2) = polar2rect(.95*$radius, $sec_theta + $sec_size_outer);
	my($x3, $y3) = polar2rect(-.15*$radius, $sec_theta - $sec_size_inner);
	my($x4, $y4) = polar2rect(-.15*$radius, $sec_theta + $sec_size_inner);
	draw_hand($blue_pict,
		  ($x1, $y1), ($x2, $y2), ($x3, $y3), ($x4, $y4));
    }

    $X->CopyArea($buffer_pixmap, $win, $copy_gc,
		 0, 0, $size, $size, 0, 0);
}

$X->event_handler('queue');
my $fds = IO::Select->new($X->connection->fh);

my $start_time = time;
my $sample_time = Time::HiRes::time;
my $frames = 0;
my $delay = 0.00001;

for (;;) {
    $X->flush();
    $X->GetScreenSaver(); # AKA XSync()
    #$X->handle_input if $fds->can_read(0);
    Time::HiRes::sleep(0.01 + $delay);
    my %e;
    while (%e = $X->dequeue_event) {
	if ($e{'name'} eq "Expose") {
	    draw();
	} elsif ($e{'name'} eq "ButtonRelease"
		 or $e{'name'} eq "KeyPress") {
	    exit;
	} elsif ($e{'name'} eq "ConfigureNotify") {
	    my($w, $h) = @e{'width', 'height'};
	    $size = min($w, $h);
	    setup_face();
	    $frames = 0;
	    $start_time = time;
	    $sample_time = Time::HiRes::time;
	} elsif ($e{'name'} eq "ClientMessage"
		 and unpack("L", $e{'data'}) == $delete_atom) {
	    exit;
	}
    }
    draw();
    $frames++;
    if (!($frames % 20)) {
	my $fps = $frames/(Time::HiRes::time-$sample_time);
	#print "$fps FPS delay $delay\n";
	if ($fps > 30) {
	    $delay = 0.75 * $delay + 0.25 * ($delay + 1/30 - 1/$fps);
	} elsif ($fps < 30) {
	    $delay = 0.75 * $delay;
	}
    }
}
