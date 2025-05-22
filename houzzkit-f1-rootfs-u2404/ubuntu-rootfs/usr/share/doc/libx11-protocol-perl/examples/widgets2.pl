#!/usr/bin/perl
use X11::Lib;

use IO::Select;
use strict;

sub clamp { $_[1] < $_[0] ? $_[0] : $_[1] > $_[2] ? $_[2] : $_[1] }
sub sign { $_[0] ? $_[0] / abs($_[0]) : 0 }
sub min { $_[0] <= $_[1] ? $_[0] : $_[1] }
sub max { $_[0] >= $_[1] ? $_[0] : $_[1] }

# Look and feel parameters to play with:
my $length = 300;
my $thumb = 100;
my $thickness = 20;
my $padding = 5;
my $depth = 2;
my $relief_frac = .1; # relief area / thickness, 0 => relief doesn't scale
my $trough_rgb = [0xa3a3, 0xa3a3, 0xb3b3];
my $bg_rgb = [0xc6c6, 0xc6c6, 0xd6d6];
my $fill_rgb = [0xb6b6, 0x3030, 0x6060];
my $shade = .5; # 0 => shadows black, hilights white; 1 => no shading
# for relief, 0 => raised, 1 => sunk, 2 => ridge, 3 => groove
my $prog_relief = 1; my $sbar_relief = 1; my $slider_relief = 0;
my $arrow_relief = 0; my $dimple_relief = 1;
my $arrow_change = 1; # these bits will flip when pressed
my $dimple = .3; # size / scrollbar thickness, 0 for none
my $font_frac = .6; # text fills 60% of the height of the progresss bar
# Note that the progress bar prefers scalable fonts, so that it can keep
# the same proportions when the window is resized. Depending on how modern
# your X installation is, this may be nontrivial.
# * The best case is if you have a font that includes both hand-edited
# bitmaps for small sizes and outlines that can be scaled arbitrarily.
# All recent X releases come with bitmaps provided by Adobe for Helvetica,
# so if you also have a corresponding Type 1 outline, that's the best
# choice: 
# (bitmaps for sizes 8, 10, 11, 12, 14, 17, 18, 20, 24, 25, and 34)
#my $fontname = "-adobe-helvetica-medium-r-normal--%d-*-*-*-*-*-iso8859-1";
# (If you're using Debian Linux like me, you'll need to install the
#  gsfonts and gsfonts-x11 packages to get the Type 1 versions. The
#  outline isn't the genuine Adobe version; it's a free clone that
#  can also be accessed directly (without Adobe's bitmaps) as)
my $fontname = "-urw-nimbus sans l-regular-r-normal--%d-*-*-*-*-*-iso8859-1";
# * Recent X releases also include some scalable fonts, though not any
# sans-serif ones. In the following, adobe-utopia can be replaced by
# adobe-courier, bitstream-courier, or bitstream-charter:
#my $fontname = "-adobe-utopia-medium-r-normal--%d-*-*-*-*-*-iso8859-1";
# * Also, recent X servers can scale bitmaps, though the results are usually
# fairly ugly.
# * If your X system predates XLFD (the 14-hyphen names), your font
# selection is probably pretty miniscule; try to pick something around
# 12 pixels:
#my $fontname = "7x13";
my $cursor_id = 132;
my $initial_delay = 0.15; # secs
my $delay = 0.05; # secs
my $accel = 0.5;
my $smooth_progress = 0; # and un-smooth scrollbar
my $text_shading_style = 1; # 0 => diagonalish, 1 => squarish

#   +--------------------------------------------------+
#   | main_win     ^v padding           [bg]           |
#   | +----------------------------------------------+ |
#   | |#prog_win###########        ^                 |<|
#   | |##########[fill]####        :thickness        |>|
#   | |####################        :                 |:|
#   | |<-------- length -----------:---------------->|:|
#   | |####################        V     [trough]    |:|
#   | +----------------------------------------------+:|
#   |                ^v padding                       :|
#   | +----------------------------------------------+:|
#   | | sbar_win +------------------------+          |:|
#   |<|          |+----+ slider_win +----+| [trough] |:|
#   |>|<-slider->|| <| |<-lt_win    | |> ||          |:|
#   |:|   pos    |+----+    rt_win->+----+|          |:|
#   |:|          +------------------------+          |:|
#   |:+----------:------------------------:----------+:|
#   |:           :   ^v padding           :           :|
#   +:-----------:------------------------:-----------:+
#    :           :                        :           :
#    :           :                        :           :
#  padding       :<------- thumb -------->:     

my $frac = 0;

my $dpy = X::OpenDisplay("");
my $cmap = X::DefaultColormap($dpy, X::DefaultScreen($dpy));

sub alloc_color {
    my($cmap, $r, $g, $b) = @_;
    my $xcolor_data = pack("ISSScx", 0, $r, $g, $b, 7);
    my $xcolor_addr = unpack("I", pack("P", $xcolor_data));
    my $xcolor_obj = \$xcolor_addr;
    bless $xcolor_obj, "X::Color";
    X::AllocColor($dpy, $cmap, $xcolor_obj);
    return unpack("Ix2x2x2xx", $xcolor_data);
} 
my $bg = alloc_color($cmap, @$bg_rgb); 
my $trough = alloc_color($cmap, @$trough_rgb);
my $shadow = alloc_color($cmap, map($_ * $shade, @$bg_rgb));
my $hilite = alloc_color($cmap, map(65535 - $shade * (65535 - $_), @$bg_rgb));
my $fill = alloc_color($cmap, @$fill_rgb);

my $delete_atom = X::InternAtom($dpy, "WM_DELETE_WINDOW", 0);

my $fontsize = $font_frac * $thickness;
my $font = X::LoadQueryFont($dpy, sprintf($fontname, $fontsize));

my $total_wd = 2*$padding + $length;
my $base_wd =  2*$padding + 2*$depth + 4;
my $total_ht = 3*$padding + 2*$thickness;
my $base_ht =  3*$padding + 4*$depth + 3;

my $cursor = X::CreateFontCursor($dpy, $cursor_id);
my $root = X::RootWindow($dpy, X::DefaultScreen($dpy));
my $attr_data = pack("x4Ix4x4x4x4x4x4x4x4Ix4x4x4I", $bg,
		     X::StructureNotifyMask, $$cursor);
my $attr_addr = unpack("I", pack("P", $attr_data));
my $attr_obj = \$attr_addr;
bless $attr_obj, "X::SetWindowAttributes";
my $copy_from_parent_visual = 0;
my $copy_from_parent_visual_obj = \$copy_from_parent_visual;
bless $copy_from_parent_visual_obj, "X::Visual";
my $main_win = X::CreateWindow($dpy, $root, 0, 0, $total_wd, $total_ht, 0,
			       X::CopyFromParent, X::CopyFromParent,
			       $copy_from_parent_visual_obj,
			       X::CWCursor | X::CWBackPixel | X::CWEventMask,
			       $attr_obj);

my $wm_hints = X::AllocWMHints();
my $wm_data = pack("IIix24", 1+2, 1, 1);
$$wm_hints = unpack("I", pack("P", $wm_data));
X::SetWMHints($dpy, $main_win, $wm_hints);

my $normal_hints = X::AllocSizeHints();
my $normal_data = pack("Iiiiiiiiiiiiiiiiii", 8+16+128+256, 0, 0,
		       $base_wd, $base_ht, $base_wd, $base_ht,
		       0, 0, 0, 0, 3, 2, 1000, 1, $base_ht, $base_wd, 0);
$$normal_hints = unpack("I", pack("P", $normal_data));
X::SetWMNormalHints($dpy, $main_win, $normal_hints);

my $class_hint = X::AllocClassHint();
$class_hint->name($0);
$class_hint->class("widgets");
# XXX Why does this need an X?
X::XSetClassHint($dpy, $main_win, $class_hint);

my $STRING = X::InternAtom($dpy, "STRING", 0);

my $window_name = "Raw X Widgets (X11::Lib)";
my $window_name_data = pack("pIiI", $window_name, $$STRING, 8,
			    length $window_name);
my $window_name_addr = unpack("I", pack("P", $window_name_data));
my $window_name_obj = \$window_name_addr;
bless $window_name_obj, "X::TextProperty";
X::SetWMName($dpy, $main_win, $window_name_obj);

my $icon_name = "widgets";
my $icon_name_data = pack("pIiI", $icon_name, $$STRING, 8, length $icon_name);
my $icon_name_addr = unpack("I", pack("P", $icon_name_data));
my $icon_name_obj = \$icon_name_addr;
bless $icon_name_obj, "X::TextProperty";
X::SetWMIconName($dpy, $main_win, $icon_name_obj);

my $protos_data = pack("I", $$delete_atom);
my $protos_addr = unpack("I", pack("P", $protos_data));
my $protos_obj = \$protos_addr;
bless $protos_obj, "DUMMY_AtomPtr";
X::SetWMProtocols($dpy, $main_win, $protos_obj, 1);

my $prog_win = X::CreateSimpleWindow($dpy, $main_win, $padding, $padding,
				     $length, $thickness, 0, 0, $trough);
X::SelectInput($dpy, $prog_win, X::ExposureMask);

my $sbar_win = X::CreateSimpleWindow($dpy, $main_win, $padding,
				     2*$padding + $thickness,
				     $length, $thickness, 0, 0, $trough);
X::SelectInput($dpy, $sbar_win, X::ExposureMask);

my $dummy_gcvals = new X::GCValues;

my $bg_gc = X::CreateGC($dpy, $main_win, 0, $dummy_gcvals);
X::SetForeground($dpy, $bg_gc, $bg);

my $shadow_gc = X::CreateGC($dpy, $main_win, 0, $dummy_gcvals);
X::SetForeground($dpy, $shadow_gc, $shadow);

my $hilite_gc = X::CreateGC($dpy, $main_win, 0, $dummy_gcvals);
X::SetForeground($dpy, $hilite_gc, $hilite);

# floor : ceil :: int : away
sub away { sign($_[0]) * int(abs($_[0]) + .9999) }

sub draw_slope_poly {
    my($win, $relief, $dep, $fill, @p) = @_;
    if ($relief > 1) {
	draw_slope_poly($win, $relief ^ 3,  $dep,      $fill, @p);
	                      $relief &= 1; $dep /= 2; $fill = 0;
    }
    my($tl, $br) = ($hilite_gc, $shadow_gc)[$relief, !$relief];
    my(@gc, @ip); $#gc = $#ip = $#p;
    my $j;

    for $j (-2 .. $#p - 2) {
        my($ix, $iy) = ($p[$j+1][0] - $p[$j][0], $p[$j+1][1] - $p[$j][1]);
        $gc[$j] = $ix > $iy ? $tl : $ix < $iy ? $br : $ix > 0 ? $tl : $br;
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
        $ip[$j+1][0] = $p[$j+1][0] + away(($dep - 1) * $mx);
        $ip[$j+1][1] = $p[$j+1][1] + away(($dep - 1) * $my);
    }
    
    if ($fill) {
	my $ip_data = pack("s*", map(@{$_}[0,1], @ip));
	my $ip_addr = unpack("I", pack("P", $ip_data));
	my $ip_obj = \$ip_addr;
	bless $ip_obj, "X::Point";
	X::FillPolygon($dpy, $win, $fill, $ip_obj, scalar @ip, X::Nonconvex,
		       X::CoordModeOrigin);
    }

    for $j (-1 .. $#p - 1) {
	my $quad_data = pack("s*", map(@{$_}[0, 1], $p[$j], $ip[$j],
				    $ip[$j + 1], $p[$j + 1]));
	my $quad_addr = unpack("I", pack("P", $quad_data));
	my $quad_obj = \$quad_addr;
	bless $quad_obj, "X::Point";
	X::FillPolygon($dpy, $win, $gc[$j], $quad_obj, 4, X::Convex,
		       X::CoordModeOrigin);
	&X::DrawLine($dpy, $win, $gc[$j], @{$p[$j]} => @{$p[$j+1]});
	&X::DrawLine($dpy, $win, $gc[$j], @{$ip[$j]} => @{$ip[$j+1]});
    }

    for $j (-1 .. $#p - 1) {
        &X::DrawLine($dpy, $win, $bg_gc, @{$p[$j+1]} => @{$ip[$j+1]})
          if $gc[$j] != $gc[$j + 1];
    }
}

sub draw_slope {
    my($win, $x, $y, $wd, $ht, $relief) = @_;
    draw_slope_poly($win, $relief, $depth, 0, [$x, $y], [$x + $wd - 1, $y],
                    [$x + $wd - 1, $y + $ht - 1], [$x, $y + $ht - 1]);
}

sub paint_arrow {
    my($win, $x, $y, $s, $dir, $relief) = @_;
    my @s = ($s / 2, $s, $s / 2, 0);
    my @p = ([$x + $s[$dir], $y + $s[$dir - 1]],
             ($dir & 1 xor $dir & 2) ? [$x, $y] : [$x + $s, $y + $s],
             ($dir & 2) ? [$x + $s, $y] : [$x, $y + $s]);
    @p[1,2] = @p[2,1] if $dir & 1;
    draw_slope_poly($win, $relief, $depth, $bg_gc, @p);
}

sub paint_slope_circle {
    my($win, $x, $y, $s, $dep, $relief) = @_;
    my($tl, $br) = ($hilite_gc, $shadow_gc)[$relief & 1, !($relief & 1)];
    my @outer = ($x, $y, $s, $s);
    my @inner = ($x + $dep, $y + $dep, $s - 2*$dep, $s - 2*$dep);
    my @tl = (35*64, 160*64);
    my @br = (215*64, 160*64);
    &X::FillArc($dpy, $win, $bg_gc, @outer, 0, 360 * 64);
    &X::FillArc($dpy, $win, $tl, @outer, @tl);
    &X::DrawArc($dpy, $win, $tl, @outer, @tl);
    &X::DrawArc($dpy, $win, $tl, @inner, @tl);
    &X::FillArc($dpy, $win, $br, @outer, @br);
    &X::DrawArc($dpy, $win, $br, @outer, @br);
    &X::DrawArc($dpy, $win, $br, @inner, @br);
    if ($relief & 2) {
	my @middle = ($x + $depth/2, $y + $depth/2, $s - $depth, $s - $depth);
	&X::FillArc($dpy, $win, $br, @middle, @tl);
	&X::FillArc($dpy, $win, $tl, @middle, @br);
    }
    &X::FillArc($dpy, $win, $bg_gc, @inner, 0, 360*64);
}

my $inner_thick = $thickness - 2 * $depth;
my $slider_pos = $depth;
my $pos_min = $depth;
my $pos_max = $length - $thumb - $depth - 2 * $inner_thick;

my $slider_win = X::CreateSimpleWindow($dpy, $sbar_win, $slider_pos, $depth,
				       $thumb + 2 * $inner_thick, $inner_thick,
				       0, 0, $bg);
X::SelectInput($dpy, $slider_win, X::ExposureMask | X::ButtonPressMask
	       | X::ButtonMotionMask | X::PointerMotionHintMask);

my $lt_win = X::CreateSimpleWindow($dpy, $slider_win, 0, 0,
				   $inner_thick, $inner_thick,
				   0, 0, $trough);
X::SelectInput($dpy, $lt_win, X::ExposureMask | X::ButtonPressMask 
	       | X::ButtonReleaseMask);

my $rt_win = X::CreateSimpleWindow($dpy, $slider_win, $thumb + $inner_thick, 0,
				   $inner_thick, $inner_thick,
				   0, 0, $trough);
X::SelectInput($dpy, $rt_win, X::ExposureMask | X::ButtonPressMask 
	       | X::ButtonReleaseMask);

my $lt_state = 0;
my $rt_state = 0;

X::MapWindow($dpy, $lt_win);
X::MapWindow($dpy, $rt_win);
X::MapWindow($dpy, $slider_win);

sub slider_update {
    my($delta, $warp) = @_;
    my $old_pos = $slider_pos;
    $slider_pos = clamp($pos_min, $slider_pos + $delta, $pos_max);
    X::WarpPointer($dpy, X::Window->nil, X::Window->nil, 0, 0, 0, 0,
		   $slider_pos - $old_pos, 0) if $warp;
    X::MoveWindow($dpy, $slider_win, $slider_pos, $depth);
    prog_update(($slider_pos - $pos_min) / ($pos_max - $pos_min), 1);
}

my $text_wd = X::TextWidth($font, "100%", 4) + 4 + 2;
my $text_x = int(($length - $text_wd) / 2);
my $dummy_charstruct_data = "\0" x 12;
my $dummy_charstruct_addr = unpack("I", pack("P", $dummy_charstruct_data));
my $dummy_charstruct_obj = \$dummy_charstruct_addr;
bless $dummy_charstruct_obj, "X::CharStruct";
my($ascent, $descent, $dummy_int);
X::TextExtents($font, "100%", 4, $dummy_int, $ascent, $descent,
	       $dummy_charstruct_obj);
my $text_baseline = int(($thickness + $ascent - $descent) / 2) - $depth;

my $root_depth = X::DisplayPlanes($dpy, X::DefaultScreen($dpy));
my $prog_pixmap = X::CreatePixmap($dpy, $prog_win, $text_wd, $inner_thick,
				  $root_depth);

my $trough_gc = X::CreateGC($dpy, $main_win, 0, $dummy_gcvals);
X::SetForeground($dpy, $trough_gc, $trough);

my $fill_gc = X::CreateGC($dpy, $main_win, 0, $dummy_gcvals);
X::SetForeground($dpy, $fill_gc, $fill);

my $fid = unpack("x4I", unpack("P8", pack("I", $$font)));
my $fid_obj = \$fid;
bless $fid_obj, "X::Font";

X::SetFont($dpy, $trough_gc, $fid_obj);
X::SetFont($dpy, $fill_gc, $fid_obj);
X::SetFont($dpy, $shadow_gc, $fid_obj);
X::SetFont($dpy, $hilite_gc, $fid_obj);
X::SetFont($dpy, $bg_gc, $fid_obj);

sub paint_shaded_text {
    my($drawable, $x, $y, $text, $n) = @_;
    my($br_gc, $tl_gc) = ($shadow_gc, $hilite_gc);
    X::DrawText($dpy, $drawable, $br_gc, $x + 1, $y + 1, $text, $n)
      if $text_shading_style;
    X::DrawText($dpy, $drawable, $br_gc, $x, $y + 1, $text, $n);
    X::DrawText($dpy, $drawable, $br_gc, $x + 1, $y, $text, $n);

    X::DrawText($dpy, $drawable, $tl_gc, $x - 1, $y - 1, $text, $n)
      if $text_shading_style;
    X::DrawText($dpy, $drawable, $tl_gc, $x, $y - 1, $text, $n);
    X::DrawText($dpy, $drawable, $tl_gc, $x - 1, $y, $text, $n);
  
    X::DrawText($dpy, $drawable, $bg_gc, $x, $y, $text, $n);
}

my $font_height = $ascent + $descent;

sub prog_update {
    my($newfrac, $increm) = @_;
    my $oldfrac = $frac;
    $frac = $newfrac;
    my $str = int(100 * $frac) . "%";
    my $text = [map([1, $_], split(//, $str))];
    $text->[1][0] = -$font_height/10 if $text->[0][1] eq "1"; # kerning
    my $text_data = join("", map(pack("PiiL", $_->[1], 1, $_->[0], 0),
				 @$text));
    my $text_addr = unpack("I", pack("P", $text_data));
    my $text_obj = \$text_addr;
    bless $text_obj, "X::TextItem";
    my $realend = int($frac * ($length - 2 * $depth)) + $depth;
    if ($increm) {
        my $newend = $realend;
        my $oldend = int($oldfrac * ($length - 2 * $depth)) + $depth;
        my $x;
        my($left, $right);
        my $count = 0;
        if ($newend > $oldend) {
            $right = \$newend; $left = \$oldend;
        } else {
            $right = \$oldend; $left = \$newend;
        }
        if ($$left >= $text_x and $$left < $text_x + $text_wd) {
            $$left = $text_x + $text_wd - 1;
            $count++;
        }
        if ($$right >= $text_x and $$right < $text_x + $text_wd) {
            $$right = $text_x;
            $count++;
        }
        if ($count == 2) {
            # do nothing
        } elsif ($newend > $oldend) {
            if ($smooth_progress) {
                for ($x = $oldend; $x < $newend; $x++) {
		    X::DrawLine($dpy, $prog_win, $fill_gc, $x, $depth =>
				$x, $thickness - $depth - 1);
                }
            } else {            
                X::FillRectangle($dpy, $prog_win, $fill_gc, $oldend, $depth,
                                      $newend - $oldend, $inner_thick);
            }
        } elsif ($newend < $oldend) {
            if ($smooth_progress) {
                for ($x = $oldend - 1; $x >= $newend; $x--) {
                    X::DrawLine($dpy, $prog_win, $trough_gc, $x, $depth =>
				$x, $thickness - $depth - 1);
                }
            } else {            
                X::FillRectangle($dpy, $prog_win, $trough_gc,
				 $newend, $depth, $oldend - $newend,
				 $inner_thick);
            }
        }
    } else {
        X::FillRectangle($dpy, $prog_win, $fill_gc, $depth, $depth,
			 $realend - $depth, $inner_thick);
    }
    my $end = clamp(0, $realend - $text_x, $text_wd);
    X::FillRectangle($dpy, $prog_pixmap, $fill_gc, 0, 0, $end, $inner_thick)
      if $end > 0;
    X::FillRectangle($dpy, $prog_pixmap, $trough_gc, $end, 0,
		     $text_wd - $end, $inner_thick)
      if $end < $text_wd;
    my $wd = X::TextWidth($font, $str, length $str);
    paint_shaded_text($prog_pixmap, 1 + int(($text_wd - $wd) / 2),
                      $text_baseline, $text_obj, scalar @$text);
    X::CopyArea($dpy, $prog_pixmap, $prog_win, $bg_gc, 0, 0,
		$text_wd, $inner_thick, $text_x, $depth);
}

X::MapWindow($dpy, $prog_win);
X::MapWindow($dpy, $sbar_win);
X::MapWindow($dpy, $main_win);

my $fds = IO::Select->new(X::ConnectionNumber($dpy));
my $timeout = 0;

my($slider_speed, $pointer_pos, $last_pos);

my(%dirty); my $resize_pending = 0;

# Since this program can't necessarily handle events as fast as the X
# server can generate them, it's important to use some sort of `flow
# control' to throw out excess events when we're behind.

# For pointer motion events, this is accomplished by selecting
# PointerMotionHint on the slider (see above), so that the server
# never sends a sequence of motion events -- instead, it sends one,
# which we throw away but use as our cue to query the pointer
# position. The query_pointer is then a sign to the server that we'd
# be willing to accept one more event, and so on. Notice that this
# requires several round trips between the server and the client for
# each motion, which in C programs is a source of performance
# problems, but here the difference is lost in the noise (we also do a
# round trip to calculate the width of the text when updating the
# progress bar, which could be done on the client side the way Xlib
# does).

# Expose and ConfigureNotify (resize) events have the same problem,
# though it's only noticeable if your window manager supports opaque
# window movement or opaque resize, respectively (the latter is fairly
# rare in X, perhaps because average X clients handle it fairly
# poorly; I for one am quite envious of how smoothly windows resize in
# Windows NT). We can't do anything to tell the server to only send us
# one of these events, but the next best thing is to just ignore them
# until there aren't any other events pending. (In some toolkits this
# would be called `idle-loop' processing). It's always safe to ignore
# intermediate resizes, but with expose events we can only do this
# because we always redraw the whole window, instead of just the
# newly-visible part. A more sophisticated approach would keep track
# of the exposed region, either with a bounding box or some more
# precise data structure, and then clip the drawing to that (either
# client-side or using a clip mask in the GC). Of course, that almost
# certainly wouldn't be a speed win, because it would be doing a lot
# of work in perl to save a few iterations of highly optimized C in
# the server.


for (;;) {
    if ($timeout) {
	X::Flush($dpy);
	while (not $fds->can_read($timeout)) {
            slider_update(int $slider_speed, 1);
            $slider_speed += sign($slider_speed) * $accel;
            if ($slider_pos == $pos_min or $slider_pos == $pos_max) {
                $timeout = 0;
                last;
            } else {
                $timeout = $delay;
            }
	    X::Flush($dpy);
	}
    }
    X::Flush($dpy);
    if (not $fds->can_read(0.001)) {
	if ($resize_pending) {
	    $resize_pending = 0;
	    $total_ht = max($total_ht, $base_ht);
	    $length = $total_wd - 2 * $padding;
	    $thickness = int(($total_ht - 3 * $padding + 1) / 2);
	    $depth = int($relief_frac * $thickness) if $relief_frac;
	    $inner_thick = $thickness - 2 * $depth;
	    $thumb = $length / 3;
	    X::ResizeWindow($dpy, $prog_win, $length, $thickness);
	    $fontsize = int($font_frac * $thickness);
	    # XXX - where is XFreeFont()?
	    #X::FreeFont($dpy, $font);
	    $font = X::LoadQueryFont($dpy, sprintf($fontname, $fontsize));
	    $fid = unpack("x4I", unpack("P8", pack("I", $$font)));
	    X::SetFont($dpy, $bg_gc, $fid_obj);
	    X::SetFont($dpy, $hilite_gc, $fid_obj);
	    X::SetFont($dpy, $shadow_gc, $fid_obj);
	    
	    $text_wd = X::TextWidth($font, "100%", 4) + 4 + 2;
	    $text_x = int(($length - $text_wd) / 2);
	    X::TextExtents($font, "100%", 4, $dummy_int, $ascent,
			   $descent, $dummy_charstruct_obj);
	    $text_baseline = int(($thickness + $ascent - $descent) / 2)
			     - $depth;
	    $font_height = $ascent + $descent;
	    
	    # XXX - let me guess; same place as XFreeFont()?
	    #X::FreePixmap($dpy, $prog_pixmap);
	    $prog_pixmap = X::CreatePixmap($dpy, $prog_win, $text_wd,
					   $inner_thick, $root_depth);

	    X::MoveResizeWindow($dpy, $sbar_win, $padding,
				2 * $padding + $thickness, $length,
				$thickness);

	    $pos_min = $depth;
	    $pos_max = $length - $thumb - $depth - 2 * $inner_thick;
	    $slider_pos = $pos_min + $frac * ($pos_max - $pos_min);
	    X::MoveResizeWindow($dpy, $slider_win, $slider_pos, $depth,
				$thumb + 2 * $inner_thick, $inner_thick);
	    X::ResizeWindow($dpy, $lt_win, $inner_thick, $inner_thick);
	    X::MoveResizeWindow($dpy, $rt_win, $thumb + $inner_thick, 0,
				$inner_thick, $inner_thick);
	}
	if ($dirty{$$prog_win}) {
            draw_slope($prog_win, 0, 0, $length, $thickness, $prog_relief);
            prog_update($frac, 0);
            $dirty{$$prog_win} = 0;
        }
        if ($dirty{$$sbar_win}) {
            draw_slope($sbar_win, 0, 0, $length, $thickness, $sbar_relief);
            $dirty{$$sbar_win} = 0;
        }
        if ($dirty{$$slider_win}) {
            draw_slope($slider_win, $inner_thick, 0, $thumb,
                       $inner_thick, $slider_relief);
            paint_slope_circle($slider_win,
                               $thumb / 2 + (2 - $dimple)/2*$inner_thick,
                               (1 - $dimple) * $inner_thick / 2,
                               $dimple * $inner_thick,
                               $depth, $dimple_relief) if $dimple;
            $dirty{$$slider_win} = 0;
        }
        if ($dirty{$$lt_win}) {
            paint_arrow($lt_win, 0, 0, $inner_thick - 1, 3,
                        $arrow_relief ^ $lt_state);
            $dirty{$$lt_win} = 0;
        }
        if ($dirty{$$rt_win}) {
            paint_arrow($rt_win, 0, 0, $inner_thick - 1, 1,
                        $arrow_relief ^ $rt_state);
            $dirty{$$rt_win} = 0;
        }
    }
    my $e = X::Event::internal_new(0);
    X::NextEvent($dpy, $e);
    my $type = $e->type;
    if ($type == X::ClientMessage) {
	if (unpack("x28I", unpack("P32", pack("I", $$e))) == $$delete_atom) {
	    exit;
	}
    } elsif ($type == X::ConfigureNotify) {
	my($wd, $ht) = unpack("x32ii", unpack("P40", pack("I", $$e)));
        if ($wd != $total_wd or $ht != $total_ht) {
            $resize_pending++;
            ($total_wd, $total_ht) = ($wd, $ht);
        }
    } elsif ($type == X::Expose) {
	bless $e, "X::Event::ExposeEvent";
        next unless unpack("x36i", unpack("P40", pack("I", $$e))) == 0;
        my $id = $e->window;
        if ($$id == $$sbar_win) {
            if ($e->x < $depth or $e->y < $depth
                or $e->x + $e->width > $length - $depth
                or $e->y + $e->height > $thickness - $depth)
            {
                # In the scrollbar, we throw out exposures that don't
                # include the border (including all the ones caused by
                # moving the slider), since the server fills the
                # trough in with the window's background color
                # automatically.
                $dirty{$$sbar_win}++;
            }
        } else {
            $dirty{$$id}++;      
        }
    } elsif ($type == X::ButtonPress) {
	bless $e, "X::Event::ButtonEvent";
	my $id = $e->window;
        if ($$id == $$slider_win) {
            $pointer_pos = $slider_pos;
            $last_pos = unpack("x40i", unpack("P44", pack("I", $$e)));
        } elsif ($$id == $$lt_win) {
            next if 2*abs($e->y - $inner_thick / 2) > $e->x;
            $lt_state = $arrow_change;
            slider_update(-1, 1);
            paint_arrow($lt_win, 0, 0, $inner_thick - 1, 3,
                        $arrow_relief ^ $lt_state);
            $slider_speed = -1;
            $timeout = $initial_delay;
        } elsif ($$id == $$rt_win) {
            next if 2*abs($e->y - $inner_thick / 2)
              > $inner_thick - $e->x;
            $rt_state = $arrow_change;
            slider_update(1, 1);
            paint_arrow($rt_win, 0, 0, $inner_thick - 1, 1,
                        $arrow_relief ^ $rt_state);
            $slider_speed = 1;
            $timeout = $initial_delay;
        }
    } elsif ($type == X::MotionNotify) {
	if ($ {$e->window} == $$slider_win and defined $last_pos) {
	    my($dummy_win, $root_x);
	    $dummy_win = X::Window->nil;
	    X::QueryPointer($dpy, $slider_win, $dummy_win, $dummy_win, $root_x,
			    $dummy_int, $dummy_int, $dummy_int, $dummy_int);
	    $pointer_pos += $root_x - $last_pos;
	    slider_update($pointer_pos - $slider_pos, 0);
	    $last_pos = $root_x
	}
    } elsif ($type == X::ButtonRelease) {
	bless $e, "X::Event::ButtonEvent";
	my $id = $e->window;
	if ($$id == $$slider_win and defined $last_pos) {
            my $root_x = unpack("x40i", unpack("P44", pack("I", $$e)));
            slider_update($root_x - $last_pos, 0);
            undef $last_pos;
        } elsif ($$id == $$lt_win) {
            $lt_state = 0;
            paint_arrow($lt_win, 0, 0, $inner_thick - 1, 3,
                        $arrow_relief ^ $lt_state);
            $timeout = 0;
        } elsif ($$id == $$rt_win) {
            $rt_state = 0;
            paint_arrow($rt_win, 0, 0, $inner_thick - 1, 1,
                        $arrow_relief ^ $rt_state);
            $timeout = 0;
        }
    }
}
