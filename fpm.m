function retval = fpm(a, exponent, m)
% fast power-modulo algorithm
% https://en.wikipedia.org/wiki/Modular_exponentiation#Memory-efficient_method

  if (m == 1)
    retval = 0
  else
    retval = 1;
    for n = 1:exponent
      retval = mod(retval * a, m);
    end
  end
end

%!assert (fpm(4, 13, 497), 445)
%!assert (fpm(80, 65, 133), 54)
