%% MU_Framework.m

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


## This example shows the advantage of Montecarloanalyses by putting four rectangulars in and getting gaussian out.

### DO NOT TOUCH!!! - unless you know what you are doing...
clear
close all
#graphics_toolkit ("gnuplot")
#graphics_toolkit ("fltk")
###

tic
### SETTINGS - PLEASE TOUCHanzahl
count		= 20e6
runs 		= 2
set_value	= 1
###


### VALUES GIVEN IN [dB] AND RECALCULATED TO [%] - PLEASE TOUCH
### CALCULATION IS DONE IN PERCENT!!!

#dB.test          = 1.00;		Uncertainty in dB
#percent.test     = 10^(test/20);	Uncertainty in % (calculation value!!!)
#distribution.test  = "n";		implemented "n"=Normaldistribution, "r"=Rectangular distribution, "u"=Sinusoidaldistribution(U-Verteilung)

dB.uncertainty1			= 0.1;
percent.uncertainty1		= 10^(dB.uncertainty1/10)-1;
distribution.uncertainty1	= "r";

dB.uncertainty2	    		= 0.1;
percent.uncertainty2	    	= 10^(dB.uncertainty2/10)-1;
distribution.uncertainty2  	= "r";

dB.uncertainty3			= 0.1;
percent.uncertainty3		= 10^(dB.uncertainty3/10)-1;
distribution.uncertainty3	= "r";

dB.uncertainty4			= 0.1;
percent.uncertainty4		= 10^(dB.uncertainty4/10)-1;
distribution.uncertainty4	= "r";
###

#### Loopstart
for x = 1:runs
####

### RANDOMNUMBERGENERATION - DO NOT TOUCH!!!

elements = fieldnames (percent);
for y = 1:numel(elements);
u.(elements{y}) = generator(percent.(elements{y}),distribution.(elements{y}),count);
end

###


### MODELEQUATION - PLEASE TOUCH

u.all = u.uncertainty1 .* u.uncertainty2 .* u.uncertainty3 .* u.uncertainty4;

# for result in percent
k = (u.all.-1).*100;
###


### CALCULATION OF MEAN AND STANDARDDEVIATION
mean_value(x) = mean(k);
standard_deviation(x) = std(k);
standard_deviation_k_2(x) = 2*std(k);
###

### HISTOGRAMM FOR EVERY RUN
figure()
hist(k,101,1)
#axis([-2 2 0 0.05])
grid minor
###

## PUTTING VECTORS TOGETHER
if (x == 1)
l = k;
else
l = [l; k];
end
##

#### END OF LOOP
end
####


printf('\n Calculate mean and standard deviation (normaldistribution)...\n')
## mean_value and standard_deviation of mean_values by runs; should be <1e-4, if bigger do more counts
m_mean_value = mean(mean_value)
u_mean_value = std(mean_value)
##


## mean_value and standard_deviation of standard_deviations by runs
m_standard_deviation = mean(standard_deviation)
u_standard_deviation = std(standard_deviation)

M_standard_deviation = mean(standard_deviation_k_2)
U_standard_deviation = std(standard_deviation_k_2)
##

### calculate shortest coverage interval
printf('\n Calculate uncertainty by GUM S1(shortest coverage Interval)...\n\tk=1\n')
[uncertaintyrange, uncertainty_leftside, uncertainty_rightside] = scovint(l, 0.6827)
printf('\n Calculate uncertainty by GUM S1(shortest coverage Interval)...\n\tk=2\n')
[uncertaintyrange, uncertainty_leftside, uncertainty_rightside] = scovint(l, 0.95)
###
toc
