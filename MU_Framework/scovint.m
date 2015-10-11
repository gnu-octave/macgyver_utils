## Modifications made for make it run with GNU Octave (3.8.1) by Enrico Saul (enrico.saul[at]b-tu.de)
##
##
## Copyright (C) 2012 Martin Šíra
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{sloci}, @var{sqL}, @var{sqR}] =} scovint (@var{data}, @var{cp}, [ @var{verbose} ] )
## Calculates shortest coverage interval for given coverage 
## probability cp from vector of samples of distribution. 
## The interval can be asymmetric. Thus the output is uncertainty
## according to Evaluation of measurement data - Supplement 1 
## to the "Guide to the expression of uncertainty in measurement"
## - Propagation of distributions using a Monte Carlo method, JCGM, 
## 2008. In the case of multiple shortest coverage intervals, the one 
## symmetric to expectation (mean) is selected.
##
## Input variables:
## @table @samp
## @item @var{data} - vector of numbers
## @item @var{cp} - coverage interval probability
## @item @var{verbose} - displays output and figures
## @end table
##
## Output variables:
## @table @samp
## @item @var{sloci} - shortest coverage interval
## @item @var{sqL} - value of output quantity at the left side of shortest coverage interval
## @item @var{sqR} - value of output quantity at the right side of shortest coverage interval
## @end table
##
## Example:
## generate random numbers according to normal distribution and calculate 
## uncertainty of the result (compare it with standard deviation times two):
## @example
## a=randn(1,1e5);
## [sloci, sqL, sqR] = scovint(a, 0.6827, 1)
## 2.*std(a)
## @end example
## @end deftypefn

## Author: Martin Šíra <msiraATcmi.cz>
## Created: July 2012
## Version: 1.11
## Keywords: coverage interval GUM


function [selsloci, selsqL, selsqR] = scovint(data, cp, verbose=0)

        % --------------------------- check input parameters %<<<1
        % check No of arguments
        if ( not( nargin == 2 || nargin == 3 ) )
                print_usage();
        endif
        % check if input data is vector 
        if ( isvector(data)~=1 )
                error ("scovint: DATA must be vector");
        endif
        % check cp
        if ( !isscalar(cp) )
                if ( !isnumeric(cp) )
                        error ("scovint: CP must be a scalar number");
                endif
        endif
        % check correct cp
        if ( cp<=0 || cp>=1 )
                error ("scovint: CP must be greater than 0 and smaller than 1");
        endif
        % check correct verbose
        if ( !isscalar(verbose) )
                error ("scovint: verbose must be scalar");
        endif

        % --------------------------- inner constants %<<<1
        % output quantity resolution (defines resolution of result):
        % XXX POSSIBLY CHANGE THIS VALUES IN THE CASE OF IMPROPER RESULTS:
        % XXX BUT THE CALCULATION WILL TAKE LONGER TIME
        cdfxlength = 500;
        probvalraster = 0.0001;

        % --------------------------- preliminary values %<<<1
        N=length(data);

        % --------------------------- cumulative distribution function: %<<<1
        % see figure 1 of 1st GUM supplement

        % output quantity vector (x axis of the cdf plot):
        cdfx=linspace(min(data),max(data),cdfxlength);
        % probability vector (y axis of the cdf plot):
        cdfy=[];
        % calculate cdf for all output quantities:
        % XXX SOME MORE OPTIMIZATION WOULD BE GOOD:
        for x=cdfx
                cdfy=[cdfy sum(data<=x)];
        endfor
        % normalize cdf:
        cdfy=cdfy./N;
                
        % --------------------------- coverage interval length: %<<<1
        % plot of the length of the 95 % coverage interval, as a function of the probability at 
	% its left-hand endpoint
        % (figure 7 of 1st GUM supplement)

        % left hand probability vector (x axis of the plot):
        pL=[];
        % length of coverage interval vector (y axis of the plot):
        loci=[];
        % shortest length of coverage interval (starting value):
        sloci=inf;
        % left hand probability of the shortest coverage interval
        spL = [];
        % curpL (current left hand probability) goes through left hand probability values:
        % OPTIMIZATION IS NEEDED!
        % through left hand probability:
        for curpL=[0:probvalraster:1]
                % right hand probability of coverage interval:
                curpR = curpL + cp;
                % if right hand probability is > 1 no reason to calculate further:
                if ( curpR > 1 )
                        break
                endif
                % index of the value from probability vector nearest to the left hand probability:
                [tmp, curpLind]=min(abs(cdfy-curpL));
                % building data for the plot of length of coverage interval:
                pL=[pL cdfy(curpLind)];
                % output quantity corresponing to the left hand probability:
                qL = cdfx(curpLind);
                % index of the value from probability vector nearest to the right hand probability:
                [tmp, curpRind]=min(abs(cdfy - curpR));
                % output quantity corresponing to the right hand probability:
                qR = cdfx(curpRind);
                % length of coverage interval:
                curloci = qR - qL;
                % building data for the plot of length of coverage interval:
                loci = [loci curloci];
                % shortest length of coverage interval values:
                if curloci < sloci(1)
                        sloci = curloci;
                        % throw away values other than for shortest coverage interval lengths:
                        sqL = qL;
                        sqR = qR;
                        spL = cdfy(curpLind);
                elseif curloci == sloci
                        % cumulate values in the case of multiple shortest coverage interval lengths:
                        sloci = [sloci curloci];
                        sqL = [sqL qL];
                        sqR = [sqR qR];
                        % left hand probability of coverage interval:
                        spL = [spL cdfy(curpLind)];
                endif

        endfor
                        %%%%%%%%sqL 
                        %%%%%%%%sqR 
                        %%%%%%%%spL 

        % --- selection of the apropriate shortest coverage interval in the case of multiple results: %<<<1
        % expectation:
        expe = mean(data);
        % select only those shortest intervals which cover expectation:
        selsqL = [];
        selsqR = [];
        selsloci = [];
        selspL = [];
        for i=1:length(sloci)
                if ( sqL(i) <= expe ) && ( sqR(i) >= expe )
                        selsqL = [selsqL sqL(i)];
                        selsqR = [selsqR sqR(i)];
                        selsloci = [selsloci sloci(i)];
                        selspL = [selspL spL(i)];
                endif
        endfor
        % in the case of no appropriate coverage interval:
        if ( sum(size(sloci)) == 0 )
                error("no shortest coverage interval covering expectation found")
        endif
        % in the case of multiple coverage interval, find most symetric results:
        tmp = abs( abs(selsqL - expe) - abs(selsqR - expe) );
        symr = min(tmp);
        symrind = find(tmp == symr);
        % if more symetric results, use middle one:
        if ( length(symrind) > 1 )
                resind = symrind( round( length(symrind)/2 ) );
        else
                resind = symrind;
        endif
        % get final values
        selsqL = selsqL(resind);
        selsqR = selsqR(resind);
        selsloci = selsloci(resind);
        selspL = selspL(resind);

        % --------------------------- plotting: %<<<1

        % plot of the cumulative distribution function:
        if verbose
                figure
                % cdf:
                plot(cdfx,cdfy,'-x')
                hold on
                xl=xlim;
                yl=ylim;
                % show expectation:
                plot([expe expe], [yl(1) yl(2)], '-g');
                % lines to show selected shortest coverage interval:
                plot([xl(1) selsqL], [selspL selspL], '-r')
                plot([selsqL selsqL], [yl(1) selspL], '-r');
                plot([selsqR xl(1)], [selspL+cp selspL+cp], '-r');
                plot([selsqR selsqR], [yl(1) selspL+cp], '-r');
                legend('cdf','expectation','shortest cov. int.');
                xlabel('output quantity')
                ylabel('probability')
                title('cumulative distribution function');
                hold off
        endif

        % plot of the length of coverage interval
        if verbose
                figure
                hold on
                plot(pL,loci,'o-')
                plot(spL, ones(size(sqL)).*sloci, 'xg', 'linewidth',4,'markersize',10)
                plot(selspL, selsloci, 'xr', 'linewidth',4, 'markersize',10)
                legend('length of coverage interval','shortest l. of c. i.','selected s. l. of c. i.'); 
                title(['length of ' num2str(cp) ' coverage interval'])
                xlabel('left hand probability')
                ylabel('length of coverage interval')
                hold off
        endif

endfunction

% --------------------------- tests: %<<<1

%!shared a, b, c, sloci, sqL, sqR
%! a=[-10:0.1:10];
%! b=stdnormal_pdf(a);
%! c=[];
%! for i=1:length(b)
%!         c=[c ones(1,  round(b(i).*1000)  ).*a(i)];
%! endfor
%! [sloci, sqL, sqR] = scovint(c, 0.6827,0);
%!assert(sloci, std(c).*2, 0.005)
%!assert(sqL<0)
%!assert(sqR>0)
%!assert(sloci, sqR-sqL, 2*eps)
%! a=[0:0.01:10];
%! b=gampdf(a,1,2);
%! c=[];
%! for i=1:length(b)
%!         c=[c ones(1,  round(b(i).*1000)  ).*a(i)];
%! endfor
%! [sloci, sqL, sqR] = scovint(c, 0.6827,0);
%!assert(sloci, 2.26226452905812, 0.00000000000002);
%!assert(sqL,0.01);
%!assert(sqR, sloci+sqL, 0.00000000000002);


% --------------------------- demo: %<<<1
%!demo
%! % chosen coverage interval probability:
%! cp=0.6827;
%! % generate points at which distribution will be evaluated:
%! a=[0:0.01:10];
%! % generate probability density function of gamma distribution:
%! b=gampdf(a,2,2);
%! % prepare variable:
%! c=[];
%! % generate samples of the gamma distribution:
%! for i=1:length(b)
%! % for every point of pdf b(i) generate appropriate number of values:
%!         c=[c ones(1,  round(b(i).*1000)  ).*a(i)];
%! endfor
%! % calculate shortest coverage interval:
%! [sloci, sqL, sqR] = scovint(c, cp, 1);
%! % calculate twice the standard deviation:
%! stddouble=std(c).*2;
%! % plot histogram figure:
%! figure
%! hist(c,100);
%! hold on
%! % get figure y axis limits:
%! yl=ylim;
%! % calculate expectation (mean):
%! expe=mean(c);
%! % calculate standard deviation:
%! stdev=std(c);
%! % plot the rest:
%! plot([expe expe], [yl(1) yl(2)], 'g--', 'linewidth',3);
%! plot([expe-stdev expe-stdev], [yl(1) yl(2)], '-y', 'linewidth',3);
%! plot([sqL sqL], [yl(1) yl(2)], '-r', 'linewidth',3);
%! plot([sqR sqR], [yl(1) yl(2)], '-r', 'linewidth',3);
%! plot([expe+stdev expe+stdev], [yl(1) yl(2)], '-y', 'linewidth',3);
%! legend('histogram','mean','standard deviation','shortest cov. interv.');
%! xlabel('output quantity');
%! ylabel('count');
%! title('gamma probability density function, A=2, B=2');
%! hold off
%! % 
%! % RESULT: see on probability density function figure - yellow standard
%! % deviation interval is symmetric around expectation (mean), but red
%! % shortest coverage interval is assymetrical and shorter!
%! % RESULT: compare shortest length of coverage interval (sloci)
%! % with twice the standard deviation (stddouble):
%! sloci
%! stddouble

% vim modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=1000
