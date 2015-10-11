#generator.m

%% Copyright (C) 2015 Enrico Saul <enrico.saul[at]b-tu.de>
%%
%% This program is free software; you can redistribute it and/or modify it under
%% the terms of the GNU General Public License as published by the Free Software
%% Foundation; either version 3 of the License, or (at your option) any later
%% version.
%%
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%% details.
%%
%% You should have received a copy of the GNU General Public License along with
%% this program; if not, see <http://www.gnu.org/licenses/>.

#[values]=generator(deviation,distribution,count)

function values=generator(devi,distri,count);



if (distri=="n")

values = normrnd (1,devi/2,[count 1]);

elseif (distri=="r")

values = unifrnd(1-(devi/sqrt(3)), 1+(devi/sqrt(3)), [count 1]);

elseif (distri=="u")

values = (sin((rand([count 1]) - 0.5)*pi).*(devi/sqrt(2)))+1;

end

return