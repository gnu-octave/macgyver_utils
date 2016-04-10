/*
 * Copyright (C) 2016 Andreas Weber <octave@tech-chat.de>
 *
 * This program is based on Eli Billauers peakdet.m
 * from http://billauer.co.il/peakdet.html
 * 
 * from his page:
 * "Eli Billauer, 3.4.05 (Explicitly not copyrighted).
 *  This function is released to the public domain; Any use is allowed."
 */

#include <octave/oct.h>

DEFUN_DLD (peakdet, args, nargout,
  "-*- texinfo -*-\n\
@deftypefn  {Loadable Function} {[@var{maxtab}, @var{mintab}] =} peakdet (@var{v}, @var{delta})\n\
finds the local maxima and minima \"peaks\" in the vector @var{v}.\n\
If @var{v} is a Matrix, return maximas and minimas for each column\n\
@end deftypefn")
{
  octave_value_list retval;
  int nargin = args.length ();
  if (nargin != 2)
    {
      print_usage ();
      return retval;
    }

  //FIXME: check, dass v is a vector and doesn't have complex numbers
  //ColumnVector x (args(0).vector_value ());

  Matrix v = args(0).matrix_value ();
  int nr = v.rows ();
  int nc = v.columns ();

  double delta = args(1).double_value ();
  if (error_state || delta <= 0)
    error ("peakdet: delta has to be a real value > 0");

  Cell ret_max(nc, 1);
  Cell ret_min(nc, 1);
  for (int j=0; j<nc; ++j)
    {
      Matrix mintab(nr, 1);
      Matrix maxtab(nr, 1);
      double mn   = v(0, j);
      double mx   = v(0, j);
      int mnpos   = 0;
      int mxpos   = 0;
      int num_max = 0;
      int num_min = 0;
      bool lookformax = 1;

      double t;
      for (int k=1; k<nr; ++k)
        {
          t = v(k, j);
          if (t > mx)
            {
              mx    = t;
              mxpos = k;
            }
          if (t < mn)
            {
              mn    = t;
              mnpos = k;
            }
          if (lookformax)
            {
              if (t < (mx-delta))
                {
                  maxtab(num_max++) = mxpos+1;
                  mn = t;
                  mnpos = k;
                  lookformax = 0;
                }
            }
          else
            {
              if (t > mn+delta)
                {
                  mintab(num_min++) = mnpos+1;
                  mx = t;
                  mxpos = k;
                  lookformax = 1;
                }
            }
        }

      maxtab.resize(num_max, 1);
      mintab.resize(num_min, 1);

      ret_max(j) = maxtab;
      ret_min(j) = mintab;
    }

  if (nc > 1)
    {
      retval(0) = ret_max;
      retval(1) = ret_min;
    }
  else
    {
      // Nur 1 Spalte -> Vektor zurückgeben
      retval(0) = ret_max(0);
      retval(1) = ret_min(0);
    }

  return retval;
}

/*
%!test
%! t=linspace(0,10,1000);
%! old_state = randn ('seed');
%! restore_state = onCleanup (@() randn ('seed', old_state));
%! randn ('seed', 10);
%! x=0.3*sin(t) + sin(1.3*t) + 0.9*sin(4.2*t) + 0.02*randn(size(t));
%! [maxtab, mintab] = peakdet(x', 0.5);
%! max_ref=[48   178   329   496   637   784   936];
%! min_ref=[112   273   411   558   716   856];
%!
%! assert(maxtab,max_ref')
%! assert(mintab,min_ref')
%!
*/
