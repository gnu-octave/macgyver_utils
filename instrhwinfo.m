## Copyright (C) 2016 Andreas Weber <andy.weber.aw@gmail.com>
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{list} =} instrhwinfo (@var{interface})
## Query available hardware for instrument-control
##
## Currently only interface "serial" is supported-
## @end deftypefn

function out = instrhwinfo (interface)

  if (nargin != 1)
    print_usage ();
  endif

  if (strcmpi (interface, "serial"))

    if (ispc ()) # windoze

      Skey = 'HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM';
      ## Find connected serial devices and clean up the output
      [~, list] = dos(['REG QUERY ' Skey]);
      [~, ~, ~, out]=regexp (list, "COM[0-9]+");

    elseif (isunix ()) # GNU/Linux, BSD...

      ## only devices with device/driver
      tmp = glob ("/sys/class/tty/*/device/driver");
      tmp = strrep (tmp, "/sys/class/tty/", "");
      out = strrep (tmp, "/device/driver", "");

    endif
   else
    error ("Interface '%s' not yet implemented...", interface);
  endif

endfunction
