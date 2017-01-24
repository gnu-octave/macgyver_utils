/*
 * Copyright (C) 2017 Andreas Weber <octave@tech-chat.de>
 */

#include <octave/oct.h>

DEFUN_DLD (crc16, args, nargout,
           "-*- texinfo -*-\n\
@deftypefn  {Loadable Function} {[@var{c}] =} crc16 (@var{v})\n\
Dumb CRC16 implementation using polynom\n\
x^16 + x^15 + x^2 + 1\n\
@end deftypefn")
{
  octave_value_list retval;
  int nargin = args.length ();
  if (nargin != 1)
    {
      print_usage ();
      return retval;
    }

  int crc = 0;
  std::string v = args(0).string_value ();
  const char *p = v.c_str ();
  for (int k=0; k < v.length(); ++k)
    {
      int i;
      crc ^= p[k];
      for (i = 0; i < 8; ++i)
        {
          if (crc & 1)
            crc = (crc >> 1) ^ 0xA001;
          else
            crc = (crc >> 1);
        }
    }
  retval = ovl (crc);
  return retval;
}

/*
%!test
%! assert (crc16 ("hello world"), 0x39C1);
*/
