##
## Copyright (C) 2019 Andreas Weber <octave@tech-chat.de>
## GPLv2
##
## make "ring" matrices, see
## https://stackoverflow.com/questions/56573666/alternating-and-shifting-sections-of-an-array

function idx = ring (m, n , v)
  if (2*(v-1) > min (m, n))
    idx = [];
  else
    r = rndtrip (m, n, v);
    c = circshift (rndtrip (n, m, v)(:), -m + 2 * v - 1).';
    idx = sub2ind ([m n], r, c);
  endif
endfunction

function r = rndtrip (m, n, v)
  # number of columns of the reduced ring matrix
  nr = n - 2 * (v - 1);
  t = ones (1, nr);
  p1 = v*t;
  p2 = v+1:m-v;
  p3 = ifelse (m - 2 * (v - 1) > 1, (m - v + 1) * t, []);
  p4 = ifelse (nr > 1, m-v:-1:v+1, []);
  r = [p1 p2 p3 p4];
endfunction

function ret = testmat (m, n, v)
  idx = ring (m, n, v);
  ret = zeros (m, n);
  ret(idx) = 1:numel(idx);
endfunction

%!test
% assert (rndtrip (2, 2, 1), [1 1 2 2])
% assert (isempty (rndtrip (2, 2, 2)))

%!test
% assert (rndtrip (3, 3, 1), [1 1 1 2 3 3 3 2])
% assert (rndtrip (3, 3, 2), [2])
% assert (isempty (rndtrip (3, 3, 3)))

%!test
% assert (rndtrip (3, 4, 1), [1 1 1 1 2 3 3 3 3 2])
% assert (rndtrip (3, 4, 2), [2 2])
% assert (isempty (rndtrip (3, 4, 3)))

%!test
% assert (rndtrip (4, 4, 1), [1 1 1 1 2 3 4 4 4 4 3 2])
% assert (rndtrip (4, 4, 2), [2 2 3 3])
% assert (isempty (rndtrip (4, 4, 3)))

%!test
% assert (rndtrip (4, 3, 1), [1 1 1 2 3 4 4 4 3 2])
% assert (rndtrip (4, 3, 2), [2 3])
% assert (isempty (rndtrip (4, 3, 3)))

%!test
% assert (rndtrip (5, 4, 1), [1 1 1 1 2 3 4 5 5 5 5 4 3 2])
% assert (rndtrip (5, 4, 2), [2 2 3 4 4 3])
% assert (isempty (rndtrip (5, 4, 3)))

%!test
% assert (rndtrip (4, 5, 1), [1 1 1 1 1 2 3 4 4 4 4 4 3 2])
% assert (rndtrip (4, 5, 2), [2 2 2 3 3 3])

%!test
% assert (rndtrip (5,7,3), [3 3 3])
% assert (rndtrip (7,5,3), [3 4 5])

%!test
% assert (testmat (1,1,1), 1)

%!test
% assert (testmat (2,1,1), [1;2])

%!test
% assert (testmat (1,2,1), [1 2])

%!test
% assert (testmat (2,2,1), [1 2; 4 3])

%!test
% assert (testmat (3,2,1), [1 2; 6 3; 5 4])

%!test
% assert (testmat (2,3,1), [1 2 3; 6 5 4])
