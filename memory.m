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
      # statm is measured in pages. the pagesize is 4096 bytes
      mem       = sscanf(fread(statm, "char=>char").', "%d ")'([1 2 3 6]) * 4 / 1024;
      fclose(statm);
      
      # print verbose output
      fprintf("\n Total memory usage by GNU Octave (VmSize): \t %g MB", mem(1))
      fprintf("\n RSS Size: \t\t\t\t\t %g MB", mem(2))
      fprintf("\n shared pages: \t\t\t\t\t %g MB", mem(3))
      fprintf("\n data + stack size: \t\t\t\t %g MB", mem(4))
      fprintf("\n Physical Memory (RAM): \t\t\t %g MB\n\n", total/1024)

    else
      error("Function MEMORY is not available on this platform.")

    endif
endfunction

