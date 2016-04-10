## This code is based on fwhm.m from the octave-signal package
## https://sourceforge.net/p/octave/signal/ci/default/tree/inst/fwhm.m
## which is granted to the public domain.
## 
## fwhm aus octave-forge signal package aufs Nötigste gestripped.
## Nur "zero" detection.
##
## Als Einzelaufruf (y ein Vektor) ist stripped_fwhm langsamer als fwhm
## aber bei einer Matix 17x700 um den Faktor 50 schneller

function ret = stripped_fwhm (yin, level = 0.5)

  ## case: full-width at half maximum
  y = bsxfun (@minus, yin, level * max(yin));

  ## case: full-width above background
  #y = y - level * repmat((max(y) + min(y)), nr, 1);

  d = [diff(y > 0); zeros(1, columns (y))];
  pos = diff ([zeros(1, columns(d)); cumsum(d == 1) > 0]);
  neg = flipud(diff ([zeros(1, columns(d)); cumsum(flipud(d == -1)) > 0]));

  # ungültige suchen (nur positive oder negative Flanke)
  invalid = sum (pos) < 1 | sum (neg) < 1;

  # ungültige einfach entfernen
  pos(:, invalid) = neg(:, invalid) = y(:, invalid) = [];

  pos_idx = find (pos);
  neg_idx = find (neg);

  xx1 = pos_idx - y(pos_idx) ./ (y(pos_idx + 1) - y(pos_idx));
  xx2 = neg_idx - y(neg_idx) ./ (y(neg_idx + 1) - y(neg_idx));

  ret = zeros (1, numel (invalid));
  ret (! invalid) = (xx2 - xx1);

endfunction
