/*
 * Copyright (C) 2017 Andreas Weber <octave@tech-chat.de>
 */

#include <octave/oct.h>

// http://reveng.sourceforge.net/crc-catalogue/16.htm

// only reflected in and output
uint16_t __crc16__ (const char *p, size_t len, uint16_t rev_poly, int16_t initial)
{
  uint16_t crc = initial;
  for (int k=0; k < len; ++k)
    {
      int i;
      crc ^= p[k];
      for (i = 0; i < 8; ++i)
        {
          if (crc & 1)
            crc = (crc >> 1) ^ rev_poly;
          else
            crc = (crc >> 1);
        }
    }
  return crc;
}

uint16_t __crc16_ccitt__ (const char *p, size_t len)
{
  uint16_t crc = 0xFFFF;
  for (int k=0; k < len; ++k)
    {
      uint8_t data = p[k];
      data ^= crc & 0xFF;
      data ^= data << 4;
      crc = ((((uint16_t)data << 8) | (crc >> 8) ) ^ (uint8_t)(data >> 4) 
            ^ ((uint16_t)data << 3));
    }
  return crc;
}

DEFUN_DLD (crc16, args, nargout,
           "-*- texinfo -*-\n\
@deftypefn  {Loadable Function} {[@var{c}] =} crc16 (@var{v}, @var{id})\n\
\n\
Calculate CRC16 with given ID\n\
\n\
@table @asis\n\
@item ARC, CRC-16, CRC-IBM\n\
x^16 + x^15 + x^2 + 1 (rev_poly = 0xA001, init = 0)\n\
\n\
@item DNP\n\
rev_poly = 0x8408, init = 0xFFFF)\n\
\n\
@item CCITT\n\
x^16 + x^12 + x^5 + 1 (rev_poly = 0x8408, init = 0xFFFF)\n\
@end table\n\
@end deftypefn")
{
  int nargin = args.length ();
  uint16_t ret = 0;
  
  if (nargin == 2)
    {
      std::string v = args(0).string_value ();
      std::string id = args(1).string_value ();
      if (id == "ARC" || id == "CRC-16" || id == "CRC-IBM")
        {
          ret = __crc16__ (v.c_str (), v.length (), 0xA001, 0);
        }
      else if (id == "CCITT")
        {
          ret = __crc16_ccitt__ (v.c_str (), v.length ());
        }
      else
        error ("Unkown ID '%s'", id.c_str ());
    }
  else
    {
      print_usage ();
      return octave_value ();
    }

  return ovl(ret);
}

/*
%!test
%! assert (crc16 ("hello world", "CRC-IBM"), 0x39C1);

%!test
%! assert (crc16 ("hello world", "CCITT"), 0xEFEB);

*/
