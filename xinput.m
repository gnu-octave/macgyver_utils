## Copyright (C) 2002 Andy Adler
##
## This program is free software; it is distributed in the hope that it
## will be useful, but WITHOUT ANY WARRANTY; without even the implied
## warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
## the GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this file; see the file COPYING.  If not, write to the
## Free Software Foundation, 59 Temple Place - Suite 330, Boston, MA
## 02111-1307, USA.

## [...] = xinput (...)
##
## xinput: xinput points mouse clicks on the screen
##
## [x,y]= xinput(axis)
##  x -> x coordinates of the points
##  y -> y coordinates of the points
##
##  axis -> if specified then the first 2 clicks
##       must be on the appropriate axes. x and y (or just x
##       if only 2 points specified ) will then be normalised.
##
## for example: x=xinput([1 10])
##    the first two clicks should correspond to x=1 and x=10
##    subsequent clicks will then be normalized to graph units.
##
## for example: [x,y]=xinput();
##    gives x and y in screen pixel units (upper left = 0,0 )
##
## select points with button #1. Buttons #2 and #3 quit.
##
## NOTE: xinput just calls the DLD function grab. It is just
##       provided for compatibility

## $Id: ginput.m,v 1.1 2002/05/12 22:01:46 aadler Exp $
##  * The original ginput.cc was done by me in 1997 -
##    it was probably my first attempt at C++.
##    Laurent Mazet re-wrote it as grab - so now xinput.m just
##    calls that function

## Andreas Stahel
## name changed to xinput, since newer versions of ginput will nor read
## from the X-sytem, but only within the graphics window

function [x,y] = xinput (axe)
  if (nargin == 1)
    if (nargout == 2)
      [x,y] = grab (axe);
    else
      x = grab (axe);
    end
  else
    if (nargout == 2)
      [x,y] = grab ();
    else
      x = grab();
    end
  end
endfunction
