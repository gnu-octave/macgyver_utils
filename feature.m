## Copyright (C) 2015 Markus Bergholz <markuman@gmail.com>
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
##
## wraps some matlab functions, lol

function ret = feature(opt1)

  if (nargin == 0)
    error("not enough input arguments")
  elseif ischar(opt1)
    if strcmp(tolower(opt1), "getpid")
      ret = getpid;
    elseif strcmp(tolower(opt1), "numthreads")
      ret = nproc;
    elseif strcmp(tolower(opt1), "getos")
      ret = uname;
      ret = sprintf("%s %s %s %s", ret.sysname, ret.release, ret.version, ret.machine);
    else
      error("Feature %s not found", opt1)
    endif
  else
    error("Feature %s not found", num2str(opt1))
  endif

endfunction
