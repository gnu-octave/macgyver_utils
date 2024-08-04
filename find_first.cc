/*
 * Copyright (C) 2024 Andreas Weber <octave@tech-chat.de>
 *
 */

#include <octave/oct.h>

DEFUN_DLD (find_first, args, nargout,
  "-*- texinfo -*-\n\
@deftypefn  {Loadable Function} {@var{idx} =} find_first (@var{X})\n\
finds the index of the first non-zero element, or NA if there isn't one,\n\
in every column. This is basically the same as\n\
@code{[r,c] = find(A);\n\
idx = accumarray(c,r,[1,size(A,2)],@@min,NaN)}\n\
but should be much faster.\n\
@end deftypefn")
{
  octave_value_list retval;
  int nargin = args.length ();
  if (nargin != 1)
    {
      print_usage ();
      return retval;
    }

  Matrix x = args(0).matrix_value ();
  int nr = x.rows ();
  int nc = x.columns ();

  Matrix ret(1, nc, lo_ieee_na_value ());
  for (int c = 0; c < nc; ++c)
    for (int r = 0; r < nr; ++r)
      if (x(r, c) != 0)
      {
		 ret(0, c) = r + 1;
		 break;
	  }
  retval(0) = ret;
  return retval;
}

/*
%!test
%! A = randi ([0 1], 1e3, 1e2);
%! A (:,5) = 0;
%! [r,c] = find(A);
%! idx1 = accumarray (c, r, [1,size(A,2)], @min, NaN);
%! idx1(isnan (idx1)) = NA;
%! idx2 = find_first (A);
%! assert (idx2, idx1)
*/
