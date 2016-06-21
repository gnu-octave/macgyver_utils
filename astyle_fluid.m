#! /usr/local/bin/octave -qf

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

## Loads a fluid file (FLTK), finds code in "code {...}" and "callback {..}"
## blocks, feed them through astyle --style=gnu -s2 and replace original file
## The original file is renamed to file.orig

arg_list = argv ();

if (numel (arg_list) == 1)
  fn = arg_list{1};
  if (! exist (fn, "file"))
    error ("file '%s' deoesn't exist", fn)
  endif
else
  error ("USAGE: astyle_fluid.m FILE");
endif

fn_out = tmpnam;

fid = fopen (fn, "r");
fid_out = fopen (fn_out, "w");
f = char (fread (fid))';

header = "# data file for the Fltk User Interface Designer (fluid)";
if (! strcmp (f(1:numel (header)), header))
  error ("file '%s' doesn't look like a fluid file", fn)
endif

function stops = find_closing (f, starts)

  stops = zeros (size (starts));
  for k = 1:numel (starts)
    if (k == numel (starts))
      p = f(starts(k):end);
    else
      p = f(starts(k):starts(k+1));
    endif

    s = cumsum(p == '{') - cumsum(p == '}');
    stops(k) = starts(k) + find (s == 0, 1) - 1;

  endfor
endfunction

function [op, cl] = find_embedded_code (f)

  op = strfind (f, "code {") + 5;
  op = cat (2, op, strfind (f, "callback {") + 9);
  op = sort (op);
  cl = find_closing (f, op);

endfunction

[op, cl] = find_embedded_code (f);

## feed code to astyle using pipes
out_idx = 1;
for k=1:numel(op)
  code = f(op(k)+1:cl(k)-1);
  [in, out, pid] = popen2 ("astyle", {"--style=gnu", "-s2"});
  fputs (in, code);
  fclose (in);
  waitpid (pid);
  formated = char(fread (out)(1:end-1))';
  fputs (fid_out, f(out_idx:op(k)));
  fputs (fid_out, formated);
  out_idx = cl(k);
endfor

## copy remaining data to target
fputs (fid_out, f(out_idx:end));
fclose (fid_out);
fclose (fid);

[ERR, MSG]  = rename (fn, [fn, ".orig"]);
if (ERR)
  error (MSG);
endif
[ERR, MSG]  = rename (fn_out, fn);
if (ERR)
  error (MSG);
endif
