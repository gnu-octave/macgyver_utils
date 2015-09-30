## Copyright (C) 2012 - 2015 Markus Bergholz <markuman@gmail.com>
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
## used by Octave

function memory()

    if isunix
    
      # open /proc/meminfo 
      meminfo   = fopen("/proc/meminfo", "r");
      PID     = getpid;
      total   = str2double(cell2mat(cell2mat(regexp(fread(meminfo, "char=>char").', "MemTotal:(.*?) kB\n", "tokens"))));
      fclose(meminfo);

      
      # open /proc/<pid>/statm
      statm     = fopen(sprintf("/proc/%d/statm", PID), "r");
      mem       = sscanf(fread(statm, "char=>char").', "%d ")'([1 6]);
      fclose(statm);
      
      # print verbose output
      fprintf("\n Total memory usage by GNU Octave: \t %g MB", mem(1)/1024)
      fprintf("\n Data + Stack Size: \t\t\t %g MB", mem(2)/1024)
      fprintf("\n Physical Memory (RAM): \t\t %g MB\n\n", total/1024)

    else
      error("Function MEMORY is not available on this platform.")

    endif
endfunction

