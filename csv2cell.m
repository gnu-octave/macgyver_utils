%% Copyright (C) 2012 Markus Bergholz <markuman@gmail.com>
%%
%% This program is free software; you can redistribute it and/or modify it under
%% the terms of the GNU General Public License as published by the Free Software
%% Foundation; either version 3 of the License, or (at your option) any later
%% version.
%%
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%% details.
%%
%% You should have received a copy of the GNU General Public License along with
%% this program; if not, see <http://www.gnu.org/licenses/>.


function ret = csv2cell(file, sep, heads)

	switch nargin
		case 0
			print_help
		case 1
			sep = ',';
			heads = 0;
			ret = read_file(file, sep, heads);
		case 2
			heads = 0;
			ret = read_file(file, sep, heads);
		case 3
			ret = read_file(file, sep, heads);
		otherwise
			print_help
	end

end

function print_help()

	fprintf('\n ret = csv2cell ( FILE )\n')
	fprintf(' ret = csv2cell ( FILE , SEPARATOR )\n')
	fprintf(' ret = csv2cell ( FILE , SEPARATOR , HEADERS )\n\n')
	fprintf(' FILE must be a char equal to the filename.\n')
	fprintf(' SEPARATOR is the value separator in the name file. Default value separator is '',''.\n')
	fprintf(' HEADERS is the number of header-lines that have to be skipped. Default value is 0.\n\n\n')

end

function ret = read_file(file, sep, heads)

	% open file
	f = fopen(file);
	if f < 3
		error('Unable to open file')
		return
	end

	% skip headers
	if heads > 0
		for n = 1:heads
			fgetl(f);
		end
	end

	% count separators
	mark = ftell(f);
	tmp = fgetl(f);
	num_sep = numel(strfind(tmp,sep));
	fseek(f, mark, 'bof');

	% read values
	ret = fread (f, 'char=>char').';

    % check end of line
	if tmp(end)~=sep
		ret = regexprep (ret,'\n',[sep '\n']);
	end
	% remove all newlines
	ret=regexprep (ret,'(\n)+','');

	% parsing values
	ret = regexp(ret,sep,'split');

	% format output
	% delete empty last field
	if mod(size(ret,2),num_sep)~=0
		% yes, because we split after each separator
		if numel(ret{1,end}) == 0
			ret = ret(1,1:end-1);
		end
		% if each line wasn't termed by a seperator
		if mod(size(ret,2),num_sep)~=0
			num_sep=num_sep+1;
		end

		if mod(size(ret,2),num_sep)==0
			ret = reshape (ret,num_sep,[])';
		end
		% else, ret is given to user without reshaping
	end

end
