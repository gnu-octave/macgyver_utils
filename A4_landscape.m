set (gcf, "paperunits", "centimeters")
set (gcf, "papersize", [29.7 21]);
set (gcf, "paperposition", [1 1 fliplr(get(gcf, "papersize"))-2])

## cset http://hg.savannah.gnu.org/hgweb/octave/log?rev=d084f11189f9
## changed how landscape works, this script may now be useless

## see also http://savannah.gnu.org/bugs/?40259
## "orient landscape"
