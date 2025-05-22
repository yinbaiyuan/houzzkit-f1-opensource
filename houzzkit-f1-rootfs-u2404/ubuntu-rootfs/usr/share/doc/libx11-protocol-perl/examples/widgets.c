#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <X11/cursorfont.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#define clamp(min, x, max) ((x) < (min) ? (min) : (x) > (max) ? (max) : (x))
#define sign(x) ((x) > 0 ? 1 : (x) < 0 ? -1 : 0)
#define abs(x) ((x) >= 0 ? (x) : -(x))
#define min(a, b) ((a) <= (b) ? (a) : (b))
#define max(a, b) ((a) >= (b) ? (a) : (b))

#ifdef NEED_HYPOT
/* SVID 3, BSD 4.3, XOpen, C99 and GNU all have hypot(). Why don't you? */
#define hypot(a, b) sqrt((a)*(a) + (b)*(b))
#endif

/* Look and feel parameters to play with: */
int length = 300;
int thumb = 100;
int thickness = 20;
int padding = 5;
int depth = 2;
double relief_frac = .1; /*relief area / thickness, 0 => relief doesn't scale*/
XColor trough = {0, 0xa3a3, 0xa3a3, 0xb3b3, 0,  0};
XColor bg = {0, 0xc6c6, 0xc6c6, 0xd6d6, 0,  0};
XColor fill = {0, 0xb6b6, 0x3030, 0x6060, 0,  0};
double shade = .5001; /* 0 => shadows black, hilights white; 1 => no shading */
/* for relief, 0 => raised, 1 => sunk, 2 => ridge, 3 => groove */
int prog_relief = 1; int sbar_relief = 1; int slider_relief = 0;
int arrow_relief = 0; int dimple_relief = 1;
int arrow_change = 1; /* these bits will flip when pressed */
double dimple = .3001; /* size / scrollbar thickness, 0 for none */
double font_frac = .6001;/* text fills 60% of the height of the progresss bar*/
/* Note that the progress bar prefers scalable fonts, so that it can keep
   the same proportions when the window is resized. Depending on how modern
   your X installation is, this may be nontrivial.
   * The best case is if you have a font that includes both hand-edited
   bitmaps for small sizes and outlines that can be scaled arbitrarily.
   All recent X releases come with bitmaps provided by Adobe for Helvetica,
   so if you also have a corresponding Type 1 outline, that's the best
   choice: 
   (bitmaps for sizes 8, 10, 11, 12, 14, 17, 18, 20, 24, 25, and 34) */
/*char *fontname="-adobe-helvetica-medium-r-normal--%d-*-*-*-*-*-iso8859-1";*/
/* Appending the following subsetting hint will speed up resizes, at the
   expense of excluding premade bitmaps:
   "[48 49 50 51 52 53 54 55 56 57 37]"; */
/* (If you're using Debian Linux like me, you'll need to install the
   gsfonts and gsfonts-x11 packages to get the Type 1 versions. The
   outline isn't the genuine Adobe version; it's a free clone that
   can also be accessed directly (without Adobe's bitmaps) as)*/
char *fontname = "-urw-nimbus sans l-regular-r-normal--%d-*-*-*-*-*-iso8859-1";
/* * Recent X releases also include some scalable fonts, though not any
   sans-serif ones. In the following, adobe-utopia can be replaced by
   adobe-courier, bitstream-courier, or bitstream-charter:
char *fontname = "-adobe-utopia-medium-r-normal--%d-*-*-*-*-*-iso8859-1";
   * Also, recent X servers can scale bitmaps, though the results are usually
   fairly ugly.
   * If your X system predates XLFD (the 14-hyphen names), your font
   selection is probably pretty miniscule; try to pick something around
   12 pixels:
char *fontname = "7x13"; */
int cursor_id = XC_top_left_arrow;
int initial_delay = 150000; /* usecs */
int delay = 50000; /* usecs */
double accel = 0.5;
Bool smooth_progress = False; /* and un-smooth scrollbar */
int text_shading_style = 1; /* 0 => diagonalish, 1 => squarish */

/*
   +--------------------------------------------------+
   | main_win	   ^v padding   	[bg]          |
   | +----------------------------------------------+ |
   | |#prog_win###########        ^                 |<|
   | |##########[fill]####        :thickness        |>|
   | |####################        :                 |:|
   | |<-------- length -----------:---------------->|:|
   | |####################        V     [trough]    |:|
   | +----------------------------------------------+:|
   |         	     ^v padding 	             :|
   | +----------------------------------------------+:|
   | | sbar_win +------------------------+          |:|
   |<|          |+----+ slider_win +----+| [trough] |:|
   |>|<-slider->|| <| |<-lt_win    | |> ||          |:|
   |:|	  pos  	|+----+    rt_win->+----+|          |:|
   |:|	       	+------------------------+          |:|
   |:+----------:------------------------:----------+:|
   |:         	 :   ^v padding           :          :|
   +:-----------:------------------------:-----------:+
    :  	 :	                  :	      :
    :           :	                  :	      :
  padding       :<------- thumb -------->:	   padding
*/

Window main_win, prog_win, sbar_win, slider_win, lt_win, rt_win;
GC trough_gc, bg_gc, fill_gc, hilite_gc, shadow_gc; 
double frac = 0;

Display *dpy;
Colormap cmap;

XColor shadow, hilite;
Atom delete_atom;

int fontsize;
XFontStruct *font;
char buf[256];

int total_wd, base_wd, total_ht, base_ht;

int inner_thick, slider_pos, pos_min, pos_max;

int lt_state, rt_state;

int text_wd, text_x, text_baseline;

Pixmap prog_pixmap;

int font_height;

/* floor : ceil :: int : away */
int away(double x) {
    return sign(x) * (int)(abs(x) + 0.9999);
}

void draw_slope_poly(Window win, int relief, int dep, GC fill,
		     XPoint *p, int n) {
    GC tl, br;
    GC *gc;
    XPoint *ip;
    int j;

    if (relief > 1) {
	draw_slope_poly(win, relief ^ 3,  dep,      fill,     p, n);
	/* tail recurse( */  relief &= 1; dep /= 2; fill = 0;
    }
    if (relief) {
	tl = shadow_gc; br = hilite_gc;
    } else {
	tl = hilite_gc; br = shadow_gc;
    }
    gc = (GC*)malloc(n * sizeof(GC));
    ip = (XPoint*)malloc(n * sizeof(XPoint));
    for (j = 0; j < n; j++) {
	int j_t_1 = (j + 1) % n; int j_t_2 = (j + 2) % n;
	double ix = (double)p[j_t_1].x - (double)p[j].x;
	double iy = (double)p[j_t_1].y - (double)p[j].y;
	double ox, oy, in, on, mx, my, mn;
	ox = (double)p[j_t_2].x - (double)p[j_t_1].x;
	oy = (double)p[j_t_2].y - (double)p[j_t_1].y;
	gc[j] = ix > iy ? tl : ix < iy ? br : ix > 0 ? tl : br;
	if (ix * oy > iy * ox) {
	    ix = -ix; iy = -iy;
	} else {
	    ox = -ox; oy = -oy;
	}
	in = hypot(ix, iy); ix /= in; iy /= in;
	on = hypot(ox, oy); ox /= on; oy /= on;
	mx = (ix + ox) / 2; my = (iy + oy) / 2;
	mn = max(abs(mx), abs(my)); mx /= mn; my /= mn;
	ip[j_t_1].x = p[j_t_1].x + away((double)(dep - 1) * mx);  
	ip[j_t_1].y = p[j_t_1].y + away((double)(dep - 1) * my);  
    }

    if (fill)
	XFillPolygon(dpy, win, fill, ip, n, Nonconvex, CoordModeOrigin);

    for (j = 0; j < n; j++) {
	XPoint quad[4];
	int j_t_1 = (j + 1) % n;
	quad[0] = p[j];      quad[1] = ip[j];
	quad[2] = ip[j_t_1]; quad[3] = p[j_t_1];
	XFillPolygon(dpy, win, gc[j], quad, 4, Convex, CoordModeOrigin);
	XDrawLine(dpy, win, gc[j], p[j].x, p[j].y, p[j_t_1].x, p[j_t_1].y);
	XDrawLine(dpy, win, gc[j], ip[j].x, ip[j].y, ip[j_t_1].x, ip[j_t_1].y);
    }

    for (j = 0; j < n; j++) {
	int j_t_1 = (j + 1) % n;
	if (gc[j] != gc[j_t_1])
	    XDrawLine(dpy, win, bg_gc, p[j_t_1].x, p[j_t_1].y,
		      ip[j_t_1].x, ip[j_t_1].y);
    }
    free(gc);
    free(ip);
}

void draw_slope(Window win, int x, int y, int wd, int ht, int relief) {
    XPoint rect[4];
    rect[0].x = x;          rect[0].y = y;
    rect[1].x = x + wd - 1; rect[1].y = y;
    rect[2].x = x + wd - 1; rect[2].y = y + ht - 1;
    rect[3].x = x;          rect[3].y = y + ht - 1;
    draw_slope_poly(win, relief, depth, 0, rect, 4);
}

void paint_arrow(Window win, int x, int y, int s, int dir, int relief) {
    XPoint p[3];
    int S[4];
    S[0] = 0; S[1] = s / 2; S[2] = s; S[3] = s / 2;
    p[0].x = x + S[(dir + 1) % 4]; p[0].y = y + S[dir];
    if (!(dir & 1) == !(dir & 2)) {
	p[1].x = x + s; p[1].y = y + s;
    } else {
	p[1].x = x; p[1].y = y;
    }
    if (dir & 2) {
	p[2].x = x + s; p[2].y = y;
    } else {
	p[2].x = x; p[2].y = y + s;
    }
    if (dir & 1) {
	XPoint temp;
	temp = p[1];
	p[1] = p[2];
	p[2] = temp;
    }
    draw_slope_poly(win, relief, depth, bg_gc, p, 3);
}

void paint_slope_circle(Window win, int x, int y, int s, int dep, int relief) {
    GC tl, br;
    int inner_x = x + dep; int inner_y = y + dep; int inner_s = s - 2 * dep;
    if (relief & 1) {
	tl = shadow_gc; br = hilite_gc;
    } else {
	tl = hilite_gc; br = shadow_gc;
    }
    XFillArc(dpy, win, bg_gc, x, y, s, s, 0, 360 * 64);
    XFillArc(dpy, win, tl, x, y, s, s, 35 * 64, 160 * 64);
    XDrawArc(dpy, win, tl, x, y, s, s, 35 * 64, 160 * 64);
    XDrawArc(dpy, win, tl, inner_x, inner_y, inner_s, inner_s, 35*64, 160*64);
    XFillArc(dpy, win, br, x, y, s, s, 215 * 64, 160 * 64);
    XDrawArc(dpy, win, br, x, y, s, s, 215 * 64, 160 * 64);
    XDrawArc(dpy, win, br, inner_x, inner_y, inner_s, inner_s, 215*64, 160*64);
    if (relief & 2) {
	int mid_x = x + dep / 2; int mid_y = y + dep / 2; int mid_s = s - dep;
	XFillArc(dpy, win, br, mid_x, mid_y, mid_s, mid_s, 35*64, 160*64);
	XFillArc(dpy, win, tl, mid_x, mid_y, mid_s, mid_s, 215*64, 160*64);
    }
    XFillArc(dpy, win, bg_gc, inner_x, inner_y, inner_s, inner_s, 0, 360*64);
}

void paint_shaded_text(Drawable dable, int x, int y, XTextItem *text, int n) {
    GC br_gc = shadow_gc;
    GC tl_gc = hilite_gc;
    
    if (text_shading_style)
	XDrawText(dpy, dable, br_gc, x + 1, y + 1, text, n);
    XDrawText(dpy, dable, br_gc, x, y + 1, text, n);
    XDrawText(dpy, dable, br_gc, x + 1, y, text, n);

    if (text_shading_style)
	XDrawText(dpy, dable, tl_gc, x - 1, y - 1, text, n);
    XDrawText(dpy, dable, tl_gc, x, y - 1, text, n);
    XDrawText(dpy, dable, tl_gc, x - 1, y, text, n);

    XDrawText(dpy, dable, bg_gc, x, y, text, n);
}

void prog_update(double newfrac, int increm) {
    double oldfrac = frac;
    char str[5]; /* 1 0 0 % \0 */
    int realend, end, n, wd;
    XTextItem text[4];
    frac = newfrac;
    sprintf(str, "%d%%", (int)(frac * 100.0));
    for (n = 0; str[n] != '\0'; n++) {
	text[n].font = None;
	text[n].nchars = 1;
	text[n].chars = &str[n];
	text[n].delta = 1;
    }
    if (str[0] == '1')
	text[1].delta = -font_height / 10; /* kerning */
    realend = (int)(frac * (double)(length - 2 * depth)) + depth;
    if (increm) {
	int newend = realend;
	int oldend = (int)(oldfrac * (double)(length - 2 * depth)) + depth;
	int x, *left, *right, count = 0;
	if (newend > oldend) {
	    right = &newend; left = &oldend;
	} else {
	    right = &oldend; left = &newend;
	}
	if (*left >= text_x && *left < text_x + text_wd) {
	    *left = text_x + text_wd - 1;
	    count++;
	}
	if (*right >= text_x && *right < text_x + text_wd) {
	    *right = text_x;
	    count++;
	}
	if (count == 2) {
	    /* do nothing */
	} else if (newend > oldend) {
	    if (smooth_progress) {
		for (x = oldend; x < newend; x++) {
		    XDrawLine(dpy, prog_win, fill_gc, x, depth, x,
			      thickness - depth - 1);
		}
	    } else {
		XFillRectangle(dpy, prog_win, fill_gc, oldend, depth,
			       newend - oldend, inner_thick);
	    }
	} else if (newend < oldend) {
	    if (smooth_progress) {
		for (x = oldend - 1; x >= newend; x--) {
		    XDrawLine(dpy, prog_win, trough_gc, x, depth,
			      x, thickness - depth - 1);
		}
	    } else {
		XFillRectangle(dpy, prog_win, trough_gc, newend, depth,
			       oldend - newend, inner_thick);
	    }
	}
    } else {
	XFillRectangle(dpy, prog_win, fill_gc, depth, depth,
		       realend - depth, inner_thick);
    }
    end = clamp(0, realend - text_x, text_wd);
    if (end > 0)
	XFillRectangle(dpy, prog_pixmap, fill_gc, 0, 0, end, inner_thick);
    if (end < text_wd)
	XFillRectangle(dpy, prog_pixmap, trough_gc, end, 0,
	text_wd - end, inner_thick);
    wd = XTextWidth(font, str, n);
    paint_shaded_text(prog_pixmap, 1 + (text_wd - wd) / 2, text_baseline,
		      text, n);
    XCopyArea(dpy, prog_pixmap, prog_win, bg_gc, 0, 0, text_wd, inner_thick,
	      text_x, depth);
}

void slider_update(double delta, Bool warp) {
    XWindowChanges changes;
    int old_pos = slider_pos;
    slider_pos = clamp(pos_min, slider_pos + delta, pos_max);
    if (warp)
	XWarpPointer(dpy, None, None, 0, 0, 0, 0, slider_pos - old_pos, 0);
    changes.x = slider_pos;
    XConfigureWindow(dpy, slider_win, CWX, &changes);
    prog_update((double)(slider_pos - pos_min) / (pos_max - pos_min), 1);
}

void mainloop(void);

int main(int argc, char **argv) {
    XSetWindowAttributes attr;
    XGCValues gc_values;

    dpy = XOpenDisplay(0);
    cmap = DefaultColormap(dpy, DefaultScreen(dpy));

    shadow.red = (unsigned short)((double)(bg.red) * shade);
    shadow.green = (unsigned short)((double)(bg.green) * shade);
    shadow.blue = (unsigned short)((double)(bg.blue) * shade);

    hilite.red = 65535 - (unsigned short)((65535.0-(double)(bg.red)) * shade);
    hilite.green = 65535-(unsigned short)((65535.0-(double)(bg.green))*shade);
    hilite.blue = 65535 - (unsigned short)((65535.0-(double)(bg.blue))*shade);

    XAllocColor(dpy, cmap, &bg);
    XAllocColor(dpy, cmap, &trough);
    XAllocColor(dpy, cmap, &shadow);
    XAllocColor(dpy, cmap, &hilite);
    XAllocColor(dpy, cmap, &fill);

    fontsize = (int)(font_frac * (double)thickness);
    sprintf(buf, fontname, fontsize);
    font = XLoadQueryFont(dpy, buf);

    total_wd = 2 * padding + length;
    base_wd =  2 * padding + 2 * depth + 4;
    total_ht = 3 * padding + 2 * thickness;
    base_ht =  3 * padding + 4 * depth + 3;

    attr.cursor = XCreateFontCursor(dpy, cursor_id);
    attr.background_pixel = bg.pixel;
    attr.event_mask = StructureNotifyMask;
    main_win = XCreateWindow(dpy, RootWindow(dpy, DefaultScreen(dpy)),
			     0, 0, total_wd, total_ht, 0,
			     CopyFromParent,CopyFromParent,CopyFromParent,
			     CWCursor|CWBackPixel|CWEventMask, &attr);
    
    {
	XSizeHints normal_hints;
	XWMHints wm_hints;
	XClassHint class_hints;
	XTextProperty window_name, icon_name;
	char *window_str = "Raw X Widgets (C Xlib)";
	char *icon_str = "widgets";
	normal_hints.min_width = normal_hints.base_width = base_wd;
	normal_hints.min_height = normal_hints.base_height = base_ht;
	normal_hints.min_aspect.x = 3; normal_hints.min_aspect.y = 2;
	normal_hints.max_aspect.x = 1000; normal_hints.max_aspect.y = 1;
	normal_hints.flags = PSize | PMinSize | PAspect | PBaseSize;
	wm_hints.input = True;
	wm_hints.initial_state = NormalState;
	wm_hints.flags = InputHint | StateHint;
	class_hints.res_name = argv[0];
	class_hints.res_class = "widgets";
	XStringListToTextProperty(&window_str, 1, &window_name);
	XStringListToTextProperty(&icon_str, 1, &icon_name);
	XSetWMProperties(dpy, main_win, &window_name, &icon_name, argv, argc,
			 &normal_hints, &wm_hints, &class_hints);
    }

    delete_atom = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
    XSetWMProtocols(dpy, main_win, &delete_atom, 1);

    attr.background_pixel = trough.pixel;
    attr.event_mask = ExposureMask;
    prog_win = XCreateWindow(dpy, main_win, padding, padding,
			     length, thickness, 0,
			     CopyFromParent,CopyFromParent,CopyFromParent,
			     CWBackPixel|CWEventMask, &attr);

    attr.background_pixel = trough.pixel;
    attr.event_mask = ExposureMask;
    sbar_win = XCreateWindow(dpy, main_win, padding, 2* padding + thickness,
			     length, thickness, 0,
			     CopyFromParent,CopyFromParent,CopyFromParent,
			     CWBackPixel|CWEventMask, &attr);

    gc_values.foreground = bg.pixel;
    bg_gc = XCreateGC(dpy, main_win, GCForeground, &gc_values);

    gc_values.foreground = shadow.pixel;
    shadow_gc = XCreateGC(dpy, main_win, GCForeground, &gc_values);

    gc_values.foreground = hilite.pixel;
    hilite_gc = XCreateGC(dpy, main_win, GCForeground, &gc_values);

    inner_thick = thickness - 2 * depth;
    slider_pos = depth;
    pos_min = depth;
    pos_max = length - thumb - depth - 2 * inner_thick;

    attr.background_pixel = bg.pixel;
    attr.event_mask = ExposureMask | ButtonPressMask | ButtonMotionMask
	| PointerMotionHintMask;
    slider_win = XCreateWindow(dpy, sbar_win, slider_pos, depth,
			       thumb + 2 * inner_thick, inner_thick, 0,
			       CopyFromParent,CopyFromParent,CopyFromParent,
			       CWBackPixel|CWEventMask, &attr);

    attr.background_pixel = trough.pixel;
    attr.event_mask = ExposureMask | ButtonPressMask | ButtonReleaseMask;
    lt_win = XCreateWindow(dpy, slider_win, 0, 0,
			   inner_thick, inner_thick, 0,
			   CopyFromParent,CopyFromParent,CopyFromParent,
			   CWBackPixel|CWEventMask, &attr);
    rt_win = XCreateWindow(dpy, slider_win, thumb + inner_thick, 0,
			   inner_thick, inner_thick, 0,
			   CopyFromParent,CopyFromParent,CopyFromParent,
			   CWBackPixel|CWEventMask, &attr);

    lt_state = rt_state = 0;

    XMapWindow(dpy, lt_win);
    XMapWindow(dpy, rt_win);
    XMapWindow(dpy, slider_win);

    text_wd = XTextWidth(font, "100%", 4) + 4 + 2;
    text_x = (length - text_wd) / 2;
    text_baseline = (thickness + font->ascent - font->descent) / 2 - depth;

    prog_pixmap = XCreatePixmap(dpy, prog_win, text_wd, inner_thick,
				DisplayPlanes(dpy, DefaultScreen(dpy)));

    gc_values.foreground = trough.pixel;
    gc_values.font = font->fid;
    trough_gc = XCreateGC(dpy, main_win, GCForeground|GCFont, &gc_values);

    gc_values.foreground = fill.pixel;
    fill_gc = XCreateGC(dpy, main_win, GCForeground|GCFont, &gc_values);

    XSetFont(dpy, shadow_gc, font->fid);
    XSetFont(dpy, hilite_gc, font->fid);
    XSetFont(dpy, bg_gc, font->fid);

    font_height = font->ascent + font->descent;

    XMapWindow(dpy, prog_win);
    XMapWindow(dpy, sbar_win);
    XMapWindow(dpy, main_win);

    mainloop();
    return 0;
}

void mainloop(void) {
    fd_set fds;
    struct timeval timeout, short_time;
    
    double slider_speed;
    int pointer_pos, last_pos = -1;
    int prog_dirty = 0, sbar_dirty = 0, slider_dirty = 0,
      lt_dirty = 0, rt_dirty = 0;
    int resize_pending = 0;
    int x_fd = ConnectionNumber(dpy);
    XEvent e;
    
    FD_ZERO(&fds);
    FD_SET(x_fd, &fds);
    timeout.tv_sec = 0; timeout.tv_usec = 0;
    
    /* Even though this program can probably handle events as fast as
       the X server can generate them, it can't hurt to use some sort
       of `flow control' to throw out excess events in case we're ever
       behind. */
    
    /* For pointer motion events, this is accomplished by selecting
       PointerMotionHint on the slider (see above), so that the server
       never sends a sequence of motion events -- instead, it sends
       one, which we throw away but use as our cue to query the
       pointer position. The query_pointer is then a sign to the
       server that we'd be willing to accept one more event, and so
       on. Notice that this requires at least one round trip between
       the server and the client for each motion, which puts a limit
       on performance. */
    
    /* Expose and ConfigureNotify (resize) events have the same
       problem, though it's only noticeable if your window manager
       supports opaque window movement or opaque resize, respectively
       (the latter is fairly rare in X, perhaps because average X
       clients handle it fairly poorly; I for one am quite envious of
       how smoothly windows resize in Windows NT). We can't do
       anything to tell the server to only send us one of these
       events, but the next best thing is to just ignore them until
       there aren't any other events pending. (In some toolkits this
       would be called `idle-loop' processing). It's always safe to
       ignore intermediate resizes, but with expose events we can only
       do this because we always redraw the whole window, instead of
       just the newly-visible part. A more sophisticated approach
       would keep track of the exposed region, either with a bounding
       box or some more precise data structure, and then clip the
       drawing to that (either client-side or using a clip mask in the
       GC). */

    for (;;) {
	if (timeout.tv_usec) {
	    XFlush(dpy);
	    while (!select(x_fd + 1, &fds, 0, 0, &timeout)) {
		FD_SET(x_fd, &fds);
		slider_update(slider_speed, 1);
		slider_speed += sign(slider_speed) * accel;
		if (slider_pos == pos_min || slider_pos == pos_max) {
		    timeout.tv_sec = timeout.tv_usec = 0;
		    break;
		} else {
		    timeout.tv_sec = 0; timeout.tv_usec = delay;
		}
		XFlush(dpy);
	    }
	}
	FD_SET(x_fd, &fds);
	XFlush(dpy);
	short_time.tv_sec = 0; short_time.tv_usec = 1000;
	if (!select(x_fd + 1, &fds, 0, 0, &short_time)) {
	    if (resize_pending) {
		XWindowChanges changes;
		
		resize_pending = 0;
		total_ht = max(total_ht, base_ht);
		length = total_wd - 2 * padding;
		thickness = (total_ht - 3 * padding + 1) / 2;
		if (relief_frac) 
		    depth = (int)(relief_frac * (double)thickness);
		inner_thick = thickness - 2 * depth;
		thumb = length / 3;
		XResizeWindow(dpy, prog_win, length, thickness);
		fontsize = (int)(font_frac * (double)thickness);
		XFreeFont(dpy, font);
		sprintf(buf, fontname, fontsize);
		font = XLoadQueryFont(dpy, buf);
		XSetFont(dpy, bg_gc, font->fid);
		XSetFont(dpy, hilite_gc, font->fid);
		XSetFont(dpy, shadow_gc, font->fid);
		
		text_wd = XTextWidth(font, "100%", 4) + 4 + 2;
		text_x = (length - text_wd) / 2;
		text_baseline = (thickness + font->ascent
				 - font->descent) / 2 - depth;
		font_height = font->ascent + font->descent;
		
		XFreePixmap(dpy, prog_pixmap);
		prog_pixmap =
		    XCreatePixmap(dpy, prog_win, text_wd, inner_thick,
				  DisplayPlanes(dpy, DefaultScreen(dpy)));
		changes.y = 2 * padding + thickness;
		changes.width = length; changes.height = thickness;
		XConfigureWindow(dpy, sbar_win, CWY|CWWidth|CWHeight,
				 &changes);
		pos_min = depth;
		pos_max = length - thumb - depth - 2 * inner_thick;
		slider_pos = pos_min
		    + (int)(frac * (double)(pos_max - pos_min));
		XMoveResizeWindow(dpy, slider_win, slider_pos, depth,
				  thumb + 2 * inner_thick, inner_thick);
		XResizeWindow(dpy, lt_win, inner_thick, inner_thick);
		changes.x = thumb + inner_thick;
		changes.width = changes.height = inner_thick;
		XConfigureWindow(dpy, rt_win, CWX|CWWidth|CWHeight,
				 &changes);
	    }
	    if (prog_dirty) {
		draw_slope(prog_win, 0, 0, length, thickness, prog_relief);
		prog_update(frac, 0);
		prog_dirty = 0;
	    }
	    if (sbar_dirty) {
		draw_slope(sbar_win, 0, 0, length, thickness, sbar_relief);
		sbar_dirty = 0;
	    }
	    if (slider_dirty) {
		draw_slope(slider_win, inner_thick, 0, thumb,
			   inner_thick, slider_relief);
		if (dimple)
		    paint_slope_circle(slider_win,
				       thumb / 2 +(int)((2.0 - dimple)/2.0
							* (double)inner_thick),
				       (int)((1.0 - dimple)
					     * (double)inner_thick / 2.0),
				       (int)(dimple * (double)inner_thick),
				       depth, dimple_relief);
		slider_dirty = 0;
	    }
	    if (lt_dirty) {
		paint_arrow(lt_win, 0, 0, inner_thick - 1, 3,
			    arrow_relief ^ lt_state);
		lt_dirty = 0;
	    }
	    if (rt_dirty) {
		paint_arrow(rt_win, 0, 0, inner_thick - 1, 1,
			    arrow_relief ^ rt_state);
		rt_dirty = 0;
	    }
	}
	XNextEvent(dpy, &e);
	switch (e.type) {
	case ClientMessage:
	    if (e.xclient.data.l[0] == delete_atom)
		exit(0);
	    break;
	case ConfigureNotify: {
	    int wd = e.xconfigure.width;
	    int ht = e.xconfigure.height;
	    if (wd != total_wd || ht != total_ht) {
		resize_pending++;
		total_wd = wd; total_ht = ht;
	    }
	    break; }
	case Expose: {
	    Window win = e.xexpose.window;
	    if (win == sbar_win) {
		if (e.xexpose.x < depth || e.xexpose.y < depth
		    || e.xexpose.x + e.xexpose.width > length - depth
		    || e.xexpose.y + e.xexpose.height > thickness - depth) {
		    /* In the scrollbar, we throw out exposures that
		       don't include the border (including all the
		       ones caused by moving the slider), since the
		       server fills the trough in with the window's
		       background color automatically. */		    
		    sbar_dirty++;
		}
	    } else if (win == prog_win)
		prog_dirty++;
	    else if (win == slider_win)
		slider_dirty++;
	    else if (win == lt_win)
		lt_dirty++;
	    else if (win == rt_win)
		rt_dirty++;
	    break; }
	case ButtonPress: {
	    Window win = e.xbutton.window;
	    if (win == slider_win) {
		pointer_pos = slider_pos;
		last_pos = e.xbutton.x_root;
	    } else if (win == lt_win) {
		if (2*abs(e.xbutton.y - inner_thick / 2) <= e.xbutton.x) {
		    lt_state = arrow_change;
		    slider_update(-1, 1);
		    paint_arrow(lt_win, 0, 0, inner_thick - 1, 3,
				arrow_relief ^ lt_state);
		    slider_speed = -1;
		    timeout.tv_sec = 0; timeout.tv_usec = initial_delay;
		}
	    } else if (win == rt_win) {
		if (2*abs(e.xbutton.y - inner_thick / 2)
		    <= inner_thick - e.xbutton.x)
		{
		    rt_state = arrow_change;
		    slider_update(1, 1);
		    paint_arrow(rt_win, 0, 0, inner_thick - 1, 1,
				arrow_relief ^ rt_state);
		    slider_speed = 1;
		    timeout.tv_sec = 0; timeout.tv_usec = initial_delay;
		}
	     }
	    break; }
	case MotionNotify:
	    if (e.xmotion.window == slider_win && last_pos != -1) {
		int na, root_x;
		Window NA;
		XQueryPointer(dpy, slider_win, &NA, &NA, &root_x, &na,
			      &na, &na, (unsigned int *)&na);
		pointer_pos += root_x - last_pos;
		slider_update(pointer_pos - slider_pos, 0);
		last_pos = root_x;
	    }
	    break;
	case ButtonRelease: {
	    Window win = e.xbutton.window;
	    if (win == slider_win && last_pos != -1) {
		slider_update(e.xbutton.x_root - last_pos, 0);
		last_pos = -1;
	    } else if (win == lt_win) {
		lt_state = 0;
		paint_arrow(lt_win, 0, 0, inner_thick - 1, 3,
			    arrow_relief ^ lt_state);
		timeout.tv_sec = 0; timeout.tv_usec = 0;
	    } else if (win == rt_win) {
		rt_state = 0;
		paint_arrow(rt_win, 0, 0, inner_thick - 1, 1,
			    arrow_relief ^ rt_state);
		timeout.tv_sec = 0; timeout.tv_usec = 0;
	    }
	    break; }
	}	
    }
}
