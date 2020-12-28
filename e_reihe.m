function r = e_reihe (n)

  ## Da die Reihen E3, E6, E12 und E24 schon 1948 und 1950 und damit vor der Entstehung der Norm
  ## DIN IEC 63 festgelegt wurden, entsprechen in den E3- bis E24-Reihen die Werte von 2,7 bis 4,7 und 8,2
  ## nicht den Rundungsregeln, was aber auf Grund der großen Verbreitung nicht mehr geändert worden ist.

  if (n <= 24)

    e = [1 1.1 1.2 1.3 1.5 1.6 1.8 2 2.2 2.4 2.7 3 3.3 3.6 3.9 4.3 4.7 5.1 5.6 6.2 6.8 7.5 8.2 9.1];
    r = e(1:24/n:end);

  else
    i = 0:n-1;
    b = 10^(1/n);
    r = b.^i;

    if (n > 24)
      rnd = 100;
    else
      rnd = 10;
    endif;

    r = round(r .* rnd)/rnd;
  endif

endfunction
