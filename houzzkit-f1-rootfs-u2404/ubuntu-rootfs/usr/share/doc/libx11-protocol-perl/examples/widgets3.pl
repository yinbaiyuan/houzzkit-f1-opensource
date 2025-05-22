#!/usr/bin/perl
use X11::Window;
use X11::Constants qw(Exposure_m ButtonPress_m ButtonRelease_m ButtonMotion_m
		      PointerMotionHint_m StructureNotify_m
		      Expose ButtonPress ButtonRelease MotionNotify
		      ClientMessage ConfigureNotify
		      Convex);
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
my $cursor = "top_left_arrow";
my $initial_delay = 0.15; # secs
my $delay = 0.05; # secs
my $accel = 0.5;
my $smooth_progress = 0; # and un-smooth scrollbar
my $text_shading_style = 1; # 0 => diagonalish, 1 => squarish

#   +--------------------------------------------------+
#   | main_win	   ^v padding   	[bg]           |
#   | +----------------------------------------------+ |
#   | |#prog_win###########        ^                 |<|
#   | |##########[fill]####        :thickness        |>|
#   | |####################        :                 |:|
#   | |<-------- length -----------:---------------->|:|
#   | |####################        V     [trough]    |:|
#   | +----------------------------------------------+:|
#   |         	     ^v padding 	              :|
#   | +----------------------------------------------+:|
#   | | sbar_win +------------------------+          |:|
#   |<|          |+----+ slider_win +----+| [trough] |:|
#   |>|<-slider->|| <| |<-lt_win    | |> ||          |:|
#   |:|	  pos  	 |+----+    rt_win->+----+|          |:|
#   |:|	       	 +------------------------+          |:|
#   |:+----------:------------------------:----------+:|
#   |:         	 :   ^v padding           :           :|
#   +:-----------:------------------------:-----------:+
#    :  	 :	                  :	      :
#    :           :	                  :	      :
#  padding       :<------- thumb -------->:	   padding

my($main_win, $prog_win, $sbar_win, $slider_win, $lt_win, $rt_win);
my($trough_gc, $bg_gc, $fill_gc, $hilite_gc, $shadow_gc); 
my $frac = 0;

my $d = X11::Display->new;
my $s = $d->default_screen;
my $cmap = $s->default_cmap;

my $bg = $cmap->color->rgb(@$bg_rgb)->alloc;
my $trough = $cmap->color->rgb(@$trough_rgb)->alloc;
my $shadow = $cmap->color->rgb(map($_ * $shade, @$bg_rgb))->alloc;
my $hilite = $cmap->color->rgb(map(65535 - $shade * (65535 - $_),
				   @$bg_rgb))->alloc;

my $delete_atom = $d->atom('WM_DELETE_WINDOW')->id;

my $fontsize = $font_frac * $thickness;
my $font = $d->font(sprintf($fontname, $fontsize));

my $total_wd = 2*$padding + $length;
my $base_wd =  2*$padding + 2*$depth + 4;
my $total_ht = 3*$padding + 2*$thickness;
my $base_ht =  3*$padding + 4*$depth + 3;

$main_win = $s->root->new_subwin(-wd => $total_wd, -ht => $total_ht,
				 -cursor => $d->cursor(-shape => $cursor),
				 -bg => $bg, -event_mask => StructureNotify_m);

$main_win->prop('WM_ICON_NAME' => "widgets")
         ->prop('WM_NAME' => "Raw X widgets (X11::Window)")
         ->prop('WM_CLASS' => "widgets\0Widgets")
         ->prop('WM_NORMAL_HINTS' => pack("Lx16llx16llllllx4", 8|16|128|256,
					  $base_wd, $base_ht,
					  3, 2, 1000, 1, $base_wd, $base_ht),
		-type => 'WM_SIZE_HINTS', -format => 32)
         ->prop('WM_HINTS' => pack("LLLx24", 1|2, 1, 1),
	        -type => 'WM_HINTS', -format => 32)
         ->prop('WM_PROTOCOLS' => pack("L", $delete_atom),
		-type => 'ATOM', -format => 32);


$prog_win = $main_win->new_subwin(-x => $padding, -y => $padding,
				  -wd => $length, -ht => $thickness,
				  -bg => $trough,
				  -event_mask => Exposure_m);

$sbar_win = $main_win->new_subwin(-x => $padding,
				  -y => 2*$padding + $thickness,
				  -wd => $length, -ht => $thickness,
				  -bg => $trough,
				  -event_mask => Exposure_m);

$bg_gc = $main_win->gc(-fg => $bg);
$shadow_gc = $main_win->gc(-fg => $shadow);
$hilite_gc = $main_win->gc(-fg => $hilite);

# floor : ceil :: int : away
sub away { sign($_[0]) * int(abs($_[0]) + .9999) }

sub draw_slope_poly {
    my($win, $relief, $dep, $fill, @p) = @_;
    if ($relief > 1) {
	draw_slope_poly($win, $relief ^ 3,  $dep,      $fill,     @p);
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
    $fill->fill_poly(-targ => $win, -points => [map(@{$ip[$_]}, 0..$#p)])
      if $fill;
    for $j (-1 .. $#p - 1) {
	$gc[$j]->fill_poly(-targ => $win, -shape => Convex, -points =>
			   [$p[$j], $ip[$j], $ip[$j + 1], $p[$j + 1]]);
	$gc[$j]->draw_line(-targ => $win, -line => [@{$p[$j]}, @{$p[$j+1]}]);
	$gc[$j]->draw_line(-targ => $win, -line => [@{$ip[$j]}, @{$ip[$j+1]}]);
    }
    for $j (-1 .. $#p - 1) {
	$bg_gc->draw_line(-targ => $win, -line => [@{$p[$j+1]}, @{$ip[$j+1]}])
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

sub pi () { 3.14159265358979 }

sub paint_slope_circle {
    my($win, $x, $y, $s, $dep, $relief) = @_;
    my($tl, $br) = ($hilite_gc, $shadow_gc)[$relief & 1, !($relief & 1)];
    my @outer = (-x => $x, -y => $y, -wd => $s, -ht => $s);
    my @inner = (-x => $x + $dep, -y => $y + $dep,
		 -wd => $s - 2*$dep, -ht => $s - 2*$dep);
    my @tl = (-angle1 => 0.2 * pi, -angle2 => 0.9 * pi);
    my @br = (-angle1 => 1.2 * pi, -angle2 => 0.9 * pi);
    $bg_gc->fill_oval(-targ => $win, @outer);
    $tl->fill_arc(-targ => $win, @outer, @tl);
    $tl->draw_arc(-targ => $win, @outer, @tl);
    $tl->draw_arc(-targ => $win, @inner, @tl);
    $br->fill_arc(-targ => $win, @outer, @br);
    $br->draw_arc(-targ => $win, @outer, @br);
    $br->draw_arc(-targ => $win, @inner, @br);
    if ($relief & 2) {
	my @middle = (-x => $x + $depth/2, -y => $y + $depth/2,
		      -wd => $s - $depth, -ht => $s - $depth);
	$br->fill_arc(-targ => $win, @middle, @tl);
	$tl->fill_arc(-targ => $win, @middle, @br);
    }
    $bg_gc->fill_oval(-targ => $win, @inner);
}

my $inner_thick = $thickness - 2 * $depth;
my $slider_pos = $depth;
my $pos_min = $depth;
my $pos_max = $length - $thumb - $depth - 2 * $inner_thick;
$slider_win = $sbar_win->new_subwin(-x => $slider_pos, -y => $depth,
				    -wd => $thumb + 2 * $inner_thick,
				    -ht => $inner_thick, -bg => $bg,
				    -event_mask => Exposure_m |
				    ButtonPress_m | ButtonRelease_m |
				    ButtonMotion_m | PointerMotionHint_m);
$lt_win = $slider_win->new_subwin(-x => 0, -y => 0,
				  -wd => $inner_thick, -ht => $inner_thick,
				  -bg => $trough,
				  -event_mask => Exposure_m | ButtonPress_m |
				  ButtonRelease_m);
$rt_win = $slider_win->new_subwin(-x => $thumb + $inner_thick, -y => 0,
				  -wd => $inner_thick, -ht => $inner_thick,
				  -bg => $trough,
				  -event_mask => Exposure_m | ButtonPress_m |
				  ButtonRelease_m);
my $lt_state = 0;
my $rt_state = 0;
$lt_win->map;
$rt_win->map;

$slider_win->map;

sub slider_update {
    my($delta, $warp) = @_;
    my $old_pos = $slider_pos;
    $slider_pos = clamp($pos_min, $slider_pos + $delta, $pos_max);
    $d->warp_pointer(-x => $slider_pos - $old_pos, -y => 0) if $warp;
    $slider_win->pos($slider_pos, $depth);
    prog_update(($slider_pos - $pos_min) / ($pos_max - $pos_min), 1);
}


my $text_wd = $font->text("100%")->width + 4 + 2;
my $text_x = int(($length - $text_wd) / 2);
my $text_baseline = int(($thickness + $font->ascent - $font->descent)/2)
		    - $depth;

my $prog_pixmap = $prog_win->pixmap(-wd => $text_wd, -ht => $inner_thick);
$trough_gc = $prog_pixmap->gc(-font => $font, -fg => $trough);
$fill_gc = $prog_pixmap->gc(-fg => $cmap->color->rgb(@$fill_rgb)->alloc);
$shadow_gc->font($font);
$hilite_gc->font($font);
$bg_gc->font($font);

sub paint_shaded_text {
    my($drawable, $x, $y, $text) = @_;
    my @args = (-target => $drawable, -text => $text);
    my($br_gc, $tl_gc) = ($shadow_gc, $hilite_gc);
    $br_gc->draw_str(@args, -x => $x + 1, -y => $y + 1)
      if $text_shading_style;
    $br_gc->draw_str(@args, -x => $x, -y => $y + 1);
    $br_gc->draw_str(@args, -x => $x + 1, -y => $y);
    $tl_gc->draw_str(@args, -x => $x - 1, -y => $y - 1)
      if $text_shading_style;
    $tl_gc->draw_str(@args, -x => $x, -y => $y - 1);
    $tl_gc->draw_str(@args, -x => $x - 1, -y => $y);
    $bg_gc->draw_str(@args, -x => $x, -y => $y);
}

sub prog_update {
    my($newfrac, $increm) = @_;
    my $oldfrac = $frac;
    $frac = $newfrac;
    my $str = int(100 * $frac) . "%";
    my $text = [map([1, $_], split(//, $str))];
    $text->[1][0] = -$font->height/10 if $text->[0][1] eq "1"; # kerning
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
		    $fill_gc->draw_line(-targ => $prog_win, -x1 => $x,
					-y1 => $depth, -x2 => $x,
					-y2 => $thickness - $depth - 1);
		}
	    } else {		
		$fill_gc->fill_rect(-targ => $prog_win, -x => $oldend,
				    -y => $depth, -wd => ($newend - $oldend),
				    -ht => $inner_thick);
	    }
	} elsif ($newend < $oldend) {
	    if ($smooth_progress) {
		for ($x = $oldend - 1; $x >= $newend; $x--) {
		    $trough_gc->draw_line(-targ => $prog_win, -x1 => $x,
					  -y1 => $depth, -x2 => $x,
					  -y2 => $thickness - $depth - 1);
		}
	    } else {		
		$trough_gc->fill_rect(-targ => $prog_win, -x => $newend,
				      -y => $depth, -wd => ($oldend - $newend),
				      -ht => $inner_thick);	    
	    }
	}
    } else {
	$fill_gc->fill_rect(-targ => $prog_win,
			    -x => $depth, -y => $depth,
			    -wd => $realend - $depth,
			    -ht => $inner_thick);
    }
    my $end = clamp(0, $realend - $text_x, $text_wd);
    $fill_gc->fill_rect(-x => 0, -y => 0, -wd => $end,
			-ht => $inner_thick) if $end > 0;
    $trough_gc->fill_rect(-x => $end, -y => 0, -wd => $text_wd - $end,
			  -ht => $inner_thick) if $end < $text_wd;
    paint_shaded_text($prog_pixmap,
		      1 + int(($text_wd - $font->text($str)->width) / 2),
		      $text_baseline, $text);
    $bg_gc->copy_area(-src => $prog_pixmap, -dest => $prog_win,
		      -dest_x => $text_x, -dest_y => $depth);
}

$prog_win->map;
$sbar_win->map;
$main_win->map;

my $fds = IO::Select->new($d->filehandle);
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
	while (not $fds->can_read($timeout)) {
	    slider_update(int $slider_speed, 1);
	    $slider_speed += sign($slider_speed) * $accel;
	    if ($slider_pos == $pos_min or $slider_pos == $pos_max) {
		$timeout = 0;
		last;
	    } else {
		$timeout = $delay;
	    }
	}
    }
    if (not $fds->can_read(0.001)) {
	if ($resize_pending) {
	    $resize_pending = 0;
	    $total_ht = max($total_ht, $base_ht);
	    $length = $total_wd - 2 * $padding;
	    $thickness = int(($total_ht - 3 * $padding) / 2 + 0.5);
	    $depth = int($relief_frac * $thickness) if $relief_frac;
	    $inner_thick = $thickness - 2*$depth;
	    $thumb = $length / 3;
	    $prog_win->size($length, $thickness);
	    $fontsize = int($font_frac * $thickness);
	    $font->close;
	    $font = $d->font(sprintf($fontname, $fontsize));
	    map($_->font($font), $bg_gc, $hilite_gc, $shadow_gc);
	    $text_wd = $font->text("100%")->width + 4 + 2;
	    $text_x = int(($length - $text_wd) / 2);
	    $text_baseline = int(($thickness + $font->ascent
				  - $font->descent)/2) - $depth;
	    $prog_pixmap->free;
	    $prog_pixmap = $prog_win->pixmap(-wd => $text_wd,
					     -ht => $inner_thick);
	    $trough_gc->target($prog_pixmap);
	    $fill_gc->target($prog_pixmap);
	    $sbar_win->pos($padding, 2*$padding + $thickness);
	    $sbar_win->size($length, $thickness);
	    $pos_min = $depth;
	    $pos_max = $length - $thumb - $depth - 2 * $inner_thick;
	    $slider_pos = $pos_min + $frac * ($pos_max - $pos_min);
	    $slider_win->pos($slider_pos, $depth);
	    $slider_win->size($thumb + 2 * $inner_thick, $inner_thick);
	    $lt_win->size($inner_thick, $inner_thick);
	    $rt_win->pos($thumb + $inner_thick, 0);
	    $rt_win->size($inner_thick, $inner_thick);
	}
	if ($dirty{$prog_win->id}) {
	    draw_slope($prog_win, 0, 0, $length, $thickness, $prog_relief);
	    prog_update($frac, 0);
	    $dirty{$prog_win->id} = 0;
	}
	if ($dirty{$sbar_win->id}) {
	    draw_slope($sbar_win, 0, 0, $length, $thickness, $sbar_relief);
	    $dirty{$sbar_win->id} = 0;
	}
	if ($dirty{$slider_win->id}) {
	    draw_slope($slider_win, $inner_thick, 0, $thumb,
		       $inner_thick, $slider_relief);
	    paint_slope_circle($slider_win,
			       $thumb / 2 + (2 - $dimple)/2*$inner_thick,
			       (1 - $dimple) * $inner_thick / 2,
			       $dimple * $inner_thick,
			       $depth, $dimple_relief) if $dimple;
	    $dirty{$slider_win->id} = 0;
	}
	if ($dirty{$lt_win->id}) {
	    paint_arrow($lt_win, 0, 0, $inner_thick - 1, 3,
			$arrow_relief ^ $lt_state);
	    $dirty{$lt_win->id} = 0;
	}
	if ($dirty{$rt_win->id}) {
	    paint_arrow($rt_win, 0, 0, $inner_thick - 1, 1,
			$arrow_relief ^ $rt_state);
	    $dirty{$rt_win->id} = 0;
	}
    }
    my $e = $d->next_event;
    if ($e->code == ClientMessage and ($e->longs)[0] == $delete_atom) {
	exit;
    } elsif($e->code == ConfigureNotify) {
	if ($e->wd != $total_wd or $e->ht != $total_ht) {
	    $resize_pending++;
 	    ($total_wd, $total_ht) = ($e->wd, $e->ht);
	}
    } elsif ($e->code == Expose) {
	next unless $e->count == 0;
	my $id = $e->window->id;
	if ($id == $sbar_win->id) {
	    if ($e->x < $depth or $e->y < $depth
		or $e->x + $e->wd > $length - $depth
		or $e->y + $e->ht > $thickness - $depth)
	    {
		# In the scrollbar, we throw out exposures that don't
		# include the border (including all the ones caused by
		# moving the slider), since the server fills the
		# trough in with the window's background color
		# automatically.
		$dirty{$sbar_win->id}++;
	    }
	} else {
	    $dirty{$id}++;	
	}
    } elsif ($e->code == ButtonPress) {
	my $id = $e->window->id;
	if ($id == $slider_win->id) {
	    $pointer_pos = $slider_pos;
	    $last_pos = $e->root_x;
	} elsif ($id == $lt_win->id) {
	    next if 2*abs($e->y - $inner_thick / 2) > $e->x;
	    $lt_state = $arrow_change;
	    slider_update(-1, 1);
	    paint_arrow($lt_win, 0, 0, $inner_thick - 1, 3,
			$arrow_relief ^ $lt_state);
	    $slider_speed = -1;
	    $timeout = $initial_delay;
	} elsif ($id == $rt_win->id) {
	    next if 2*abs($e->y - $inner_thick / 2) > $inner_thick - $e->x;
	    $rt_state = $arrow_change;
	    slider_update(1, 1);
	    paint_arrow($rt_win, 0, 0, $inner_thick - 1, 1,
			$arrow_relief ^ $rt_state);
	    $slider_speed = 1;
	    $timeout = $initial_delay;
	}
    } elsif ($e->code == MotionNotify) {
	my $id = $e->window->id;
	if ($id == $slider_win->id and defined $last_pos) {
	    my %e2 = $slider_win->query_pointer;
	    $pointer_pos += $e2{'root_x'} - $last_pos;
	    slider_update($pointer_pos - $slider_pos, 0);
	    $last_pos = $e2{'root_x'};
	}
    } elsif ($e->code == ButtonRelease) {
	my $id = $e->window->id;
	if ($id == $slider_win->id and defined $last_pos) {
	    slider_update($e->root_x - $last_pos, 0);
	    undef $last_pos;
	} elsif ($id == $lt_win->id) {
	    $lt_state = 0;
	    paint_arrow($lt_win, 0, 0, $inner_thick - 1, 3,
			$arrow_relief ^ $lt_state);
	    $timeout = 0;
	} elsif ($id == $rt_win->id) {
	    $rt_state = 0;
	    paint_arrow($rt_win, 0, 0, $inner_thick - 1, 1,
			$arrow_relief ^ $rt_state);
	    $timeout = 0;
	}
    }
}
