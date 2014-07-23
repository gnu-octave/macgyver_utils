## Copyright (C) 2012 Markus Bergholz <markuman@gmail.com>
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
##
## memory returns information about how much physical
## memory is available and how much is currently being
## used by Octave without shared libraries.
##
## It just support Linux Plattform
##
## Linux Dependencies: pmap awk free (should be out of the box available on every distribution)
##
## Never testet on Mac
##
## MAC Dependencies: vmmap awk top
## pkg-config, gnu-sed, texinfo, fftw, readline, suite-sparse, glpk, graphicsmagick, hdf5, pcre, 
## fltk, qhull, qrupdate



if isunix == 1

	% Process's memory incl. shares libraries
	% Programm + Heap + Stack
	% Virtual size (in paging space) in kilobytes of the data section of the process (displayed as SZ by other flags).

	%% [~,memory.size]=system(sprintf("pmap -x %g |awk '/total/ { print $3 }'",getpid));
	%% memory.size=str2num (memory.size);

	% RSS = Resident Set Size
	% The resident set size is the portion of a process's memory that is held in RAM
	% Real-memory (resident set) size in kilobytes of the process

	[~,memory.rss]=system(sprintf("pmap -x %g |awk '/total/ { print $4 }'",getpid));
	memory.rss=str2num (memory.rss);

	% Dirty Pages

	%% [~,memory.dirty]=system(sprintf("pmap -x %g |awk '/total/ { print $5 }'",getpid));
	%% memory.dirty=str2num (memory.dirty);

	% Available physical RAM

	[~,memory.available]=system("free|awk '/Mem:/ { print $2 }'");
	memory.available=str2num (memory.available);


	fprintf("\n Memory used by Octave:   %g MB \n", memory.rss/1024)
%	fprintf(" Dirty Pages used by Octave:   %g MB \n", memory.dirty/1024)
%	fprintf(" Octave + Heap + Stack:   %g MB \n", memory.size/1024)
	fprintf(" Physical Memory (RAM): %g MB \n\n", memory.available/1024)
	clear memory

elseif ismac == 1

	[~,memory.available]=system(sprintf("top -l 1 | awk '/PhysMem:/ {print $10}'"));
	memory.available=str2num (memory.available);

        [~,memory.rss]=system(sprintf("vmmap -resident %g |awk '/TOTAL/ { print $3 }'|head -1",getpid));
        memory.rss=str2num (memory.rss);

	fprintf("\n Memory used by Octave:   %g MB \n", memory.rss)
	fprintf(" Physical Memory (RAM): %g MB \n\n", memory.available/1024)
	clear memory

elseif ispc == 1
	error('Function MEMORY is not available on this platform.')

else 
	error('Function MEMORY is not available on unknown platforms.')

end

