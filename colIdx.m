## Copyright (C) 2016 Markus Bergholz <markuman@gmail.com>
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

# Transform Octave Index to Excel Column Name

function this = colIdx(n, this = "")
	n = n - 1;
	if n < 0 
		this = this(end:-1:1);
	else
		this = [this char(mod(n, 26) + 65)];
		this = colIdx(floor(n/26), this);
	end
end

%!test assert (colIdx(1), 'A')
%!test assert (colIdx(26), 'Z')
%!test assert (colIdx(27), 'AA')
%!test assert (colIdx(28), 'AB')
%!test assert (colIdx(52), 'AZ')
%!test assert (colIdx(3702), 'ELJ')
%!test assert (colIdx(702), 'ZZ')
%!test assert (colIdx(703), 'AAA')
%!test assert (colIdx(18279), 'AAAA')