## Copyright (C) 2014 Andreas Weber <andy.weber.aw@gmail.com>
##
## This script is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## It is is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {Function File} {[@var{HxA}, @var{HyA}, @var{HxP}, @var{HyP}] =} rfxpert_read (@var{file})
## Read the measurement data (HxAmplitude, HyAmplitude,
## HxPhase and HyPhase) captured from a Emscan RFxpert and saved as .xls.
##
## Try "demo rfxpert_read"
##
## You'll need xls2csv (package catdoc in debian/ubuntu) and sed.
## @end deftypefn

function [HxA, HyA, HxP, HyP] = rfxpert_read (fn)

  if (! exist(fn, 'file'))
    error('File %s not found...', fn);
  endif

  tmp_fn = tmpnam();
  cmd = sprintf('xls2csv %s | sed s/\\\"//g > %s', fn, tmp_fn);
  s = system (cmd);
  in = csvread(tmp_fn);
  assert ( size (in), [165, 40]);
  unlink(tmp_fn);
  sheet_idx = find (all ( bsxfun (@eq, in, 1:40), 2));
  sheet_idx(end+1) = rows(in);

  HxA = in(__get_idx__(sheet_idx, 1), :);
  HyA = in(__get_idx__(sheet_idx, 2), :);
  HxP     = in(__get_idx__(sheet_idx, 3), :);
  HyP     = in(__get_idx__(sheet_idx, 4), :);
endfunction

function idx = __get_idx__(sheet_idx, n)
  idx = sheet_idx(n)+1:sheet_idx(n+1)-1;
  assert (length (idx), 40);
endfunction

%!demo
%! [hxa, hya, hxp, hyp] = rfxpert_read ("sample_data/rfxpert.xls");
%! imagesc (hxa)
%! title ('HxAmplitude')
