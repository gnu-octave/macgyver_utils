## Copyright (C) 2016 Andreas Weber <octave@tech-chat.de>
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
## @deftypefn {Function File} {@var{r} =} uniq_c (@var{x})
## Return the unique elements and their number of occurrence.
##
## This should be equivalent to the default GNU/Linux command
## "echo x | sort | uniq -c", therefore the name "uniq_c".
##
## @example
## @group
## x = [5 2 4 6 2 4 2 3];
## [val, cnt] = uniq_c (x)
##   @result{} val = [2 3 4 5]
##   @result{} cnt = [3 1 2 1 1]
## @end group
## @end example
##
## @seealso{unique, accumarray}
## @end deftypefn

function [val, cnt] = uniq_c (X)

  [val, ~, J] = unique (X);
  cnt = accumarray (J(:), 1);
  if (rows (J) == 1)
    cnt = cnt';
  endif

endfunction

%!test
% x = [5 2 4 6 2 4 2 3];
% [val, cnt] = uniq_c (x);
% assert (val, 2:5);
% assert (cnt, [3 1 2 1 1]);

%!test
% x = randi (8, 6, 4);
% [val, cnt] = uniq_c (x);
% assert (sum (val .* cnt), sum (x(:)));
