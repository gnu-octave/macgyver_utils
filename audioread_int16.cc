/*
 * Based on GNU Octaves audioread.cc
 *
 * See http://www.gomatlab.de/bug-bei-audioread-t43590.html
 *
 * compile with
 * $ mkoctfile audioread_int16.cc -lsndfile
 */

/*
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
*/

#include <string>
#include <map>

#include "oct-locbuf.h"
#include "unwind-prot.h"

#include "defun-dld.h"
#include "error.h"
#include "errwarn.h"
#include "ovl.h"
#include "ov.h"
#include "ov-struct.h"
#include "pager.h"

#include <sndfile.h>

static void
safe_close (SNDFILE *file)
{
  sf_close (file);
}

DEFUN_DLD (audioread_int16, args, , "audioread_int16 (@var{filename})")
{
  int nargin = args.length ();

  if (nargin != 1)
    print_usage ();

  std::string filename = args(0).xstring_value ("audioread_int16: FILENAME must be a string");

  SF_INFO info;
  info.format = 0;
  SNDFILE *file = sf_open (filename.c_str (), SFM_READ, &info);

  if (! file)
    error ("audioread_int16: failed to open input file %s", filename.c_str ());

  octave::unwind_protect frame;

  frame.add_fcn (safe_close, file);

  int16NDArray audio (dim_vector (info.frames, info.channels));
  octave_int16 *paudio = audio.fortran_vec ();

  sf_read_short (file, (short *) paudio, info.frames * info.channels);

  return ovl (audio, info.samplerate);
}
