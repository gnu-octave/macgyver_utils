/*
 * Get graphical coordinates from screen
 *
 * This contains bits of code hacked from the
 * X Consortium and from Octave. Please see the
 * appropriate licences. The rest is mine, and
 * you can do what you want with that part.
 *
 * Copyright (C) 1997 Andy Adler <adler@ncf.ca>
 *
 * Compile with "mkoctfile grab.cc"
 * Please excuse the ugly code. I wrote while I was learning C.
 */

/*
 * Copyright (C) 2001 Laurent Mazet <mazet@crm.mot.com>
 *
 * Fix error handler to avoid octave core-dump.
 * Change to avoid the input limit.
 * Minimize the number of cliks for full x-y axis definitions.
 * Make the code a bit less ugly.
 */

// This source is also available at
// https://staff.ti.bfh.ch/sha1/Labs/PWF/Extras/Demos/input/

#include <string>

#include <octave/oct.h>
#include <octave/toplev.h>
#include <octave/pager.h>

extern "C" {
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
}
using namespace std;

#define maxpoints 10

DEFUN_DLD (grab, args, nargout,
           "[...] = grab (...)\n"
           "\n"
           "grab: grab points mouse clicks on the screen\n"
           " \n"
           "[x,y]= grab(axis)\n"
           " x -> x coordinates of the points\n"
           " y -> y coordinates of the points\n"
           "\n"
           " axis -> if specified then the first 2 clicks\n"
           "      must be on the appropriate axes. x and y (or just x\n"
           "      if only 2 points specified ) will then be normalised.\n"
           "\n"
           "for example: x=grab([1 10]) \n"
           "   the first two clicks should correspond to x=1 and x=10 \n"
           "   subsequent clicks will then be normalized to graph units.  \n"
           "\n"
           "for example: [x,y]=grab; \n"
           "   gives x and y in screen pixel units (upper left = 0,0 ) \n"
           "\n"
           "select points with button #1. Buttons #2 and #3 quit. ") {

  ColumnVector axis;
  ColumnVector xaxis(2);
  ColumnVector yaxis(2);
  int nc;

  switch (args.length()) {
  case 0:
    nc = 0;
    break;
  case 1:
      { // we need to do this to allow arbitrary orientation
         ColumnVector tmp( args(0).vector_value() );
	 if (error_state) return octave_value_list();
         axis = tmp;
      }
      nc = axis.numel ();
      if ((nc == 2) || (nc == 4))
        break;
  default:
    print_usage ();
    return octave_value_list();
  }

  switch (nc) {
  case 2:
    octave_stdout << "First click on x-axis " << axis(0) << endl;
    octave_stdout << "Then click on x-axis " << axis(1) << endl;
    flush_octave_stdout();
    break;
  case 4:
    octave_stdout << "First click on point "
                  << "(" << axis(0) << "," << axis(2) << ")" << endl;
    octave_stdout << "Then click on point "
                  << "(" << axis(1) << "," << axis(3) << ")" << endl;
    flush_octave_stdout();
    break;
  }

  char *displayname = NULL;
  Display *dpy = XOpenDisplay (displayname);

  if (!dpy) {
    error ("grab: unable to open display %s.", XDisplayName(displayname));
    return octave_value_list();
  }

  Cursor  cursor = XCreateFontCursor(dpy, XC_crosshair);

  /* Grab the pointer using target cursor, letting it room all over */
  Window root = RootWindow(dpy,0);
  int done = XGrabPointer(dpy, root, False, ButtonPressMask,
                          GrabModeSync, GrabModeAsync, root,
                          cursor, CurrentTime);
  if (done != GrabSuccess) {
    error ("grab: Can't grab the mouse.");
    return octave_value_list();
  };

  XEvent event;
  XButtonEvent *e = NULL;

  if (nc != 0)
    for (int i=0; i<2; i++) {
      XAllowEvents(dpy, SyncPointer, CurrentTime);
      XWindowEvent(dpy, root, ButtonPressMask, &event);

      e = (XButtonEvent *) &event;

      if (e->button != 1) {
        XUngrabPointer(dpy, CurrentTime);      /* Done with pointer */
        XCloseDisplay (dpy);
        error ("grab: Not enough points selected.");
        return octave_value_list();
      }

      xaxis (i) = double(e->x_root);
      yaxis (i) = double(e->y_root);
    }


  /* Wait for a click */
  dim_vector dv (maxpoints, 1);
  int32NDArray xc (dv);
  int32NDArray yc (dv);

  int nb_elements = 0;
  while (1) {
    XAllowEvents(dpy, SyncPointer, CurrentTime);
    XWindowEvent(dpy, root, ButtonPressMask, &event);

    e = (XButtonEvent *) &event;

    if (e->button != 1)
      break;

    xc (nb_elements) = e->x_root;
    yc (nb_elements) = e->y_root;

    nb_elements++;

    if (nb_elements == xc.rows()) {
      dv (1) += maxpoints;
      xc.resize (dv);
      yc.resize (dv);
    }
  }

  XUngrabPointer(dpy, CurrentTime);      /* Done with pointer */
  XCloseDisplay (dpy);

  double xb=0.0, xm=1.0, yb=0.0, ym=1.0;
  if ((nc == 2) || (nc == 4)) {
    double xdiff = xaxis(1) - xaxis(0);
    xm = -(axis(0)-axis(1)) / xdiff;
    xb = (xaxis(1)*axis(0)-xaxis(0)*axis(1)) / xdiff;
    if (nc == 4) {
      double ydiff = yaxis(1) - yaxis(0);
      ym = -(axis(2)-axis(3)) / ydiff;
      yb = (yaxis(1)*axis(2)-yaxis(0)*axis(3)) / ydiff;
    }
  }

  ColumnVector x(nb_elements), y(nb_elements);
  for(int i=0; i<nb_elements; i++) {
    x(i) = double(xc(i))*xm + xb;
    y(i) = double(yc(i))*ym + yb;
  }

  octave_value_list retval;
  retval (0) = x;
  if (nargout == 2)
      retval(1) = y;

  return retval;
}
