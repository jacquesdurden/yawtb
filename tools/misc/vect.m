function out = vect(deb,fin,N,typ,closeness)
% \manchap
%
% Compute vector of several shape (linear,exponential, ...)
%
% \mansecSyntax
% [out] = vect(deb, fin, N [, typ] [, closeness])
%
% \mansecDescription
% This function compute several kind of N points vectors of
% beginning 'deb' and end 'end'. It resumes the
% action of 'linspace' and 'logspace' and add some extra options.
%  
% \mansubsecInputData
% \begin{description}
% \item[deb, fin] [REALS] extremities of the vector
% \item[N] [INTEGER] number of points inside the vector
% \item[typ] [STRING] the type of the vector.  It can be: 
%   \begin{description}
%   \item['log'] logarithmic spaced;
%   \item['sqr'] squared spaced;
%   \end{description}
%
% \item[closeness] [STRING]: The type of interval to
% implement. Allowed type are:
%   \begin{description}
%   \item['close'] linear spaced with step = (fin-deb)/(N-1)
%   \item['open'|'ropen'] linear spaced with step = (fin-deb)/N. Useful for
%     cases where 'fin' is identified to 'deb' (e.g. frequencies with
%     pi and -pi). It modelizes the right open interval [deb,fin[
%   \item['lopen'] same than 'open' but modelizes the left-open interval
%   ]deb,fin].
%   \item['rlopen'|'lropen'] modelizes the open interval ]deb,fin[.
%  \end{description}
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL VECTOR] output vector.
% \end{description} 
%
% \mansecExample
%
% \mansecReference
%
% \mansecSeeAlso
%
% linspace logspace
%    
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/vect.m,v 1.9 2003-09-30 14:01:34 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

if ~exist('typ')
  typ = 'linear';
end

%% Allowing the overide of typ by closeness
if any(strcmp(typ,{'close','open','lopen','ropen','rlopen', ...
		   'lropen'}))
  closeness = typ;
  typ       = 'linear';
end

if ~exist('closeness')
  closeness = 'close';
end
  

if (fin == deb)|(N==1) 
  out = deb;
  return;
end

extr   = [deb fin];
%%extr   = sort(extr);

switch closeness
 case {'open','ropen'}
  out = vect(deb,fin,N+1,typ);
  out = out(1:end-1);
  return;
  
 case {'lopen'}
  out = vect(deb,fin,N+1,typ);
  out = out(2:end);
  return;
  
 case {'rlopen','lropen'}
  out = vect(deb,fin,N+1,typ);
  out = out(2:end) - (fin - deb)/(2*N);
  return;
  
 case 'close'
  switch typ
   case 'linear'
    out = extr(1) : (extr(2)-extr(1))/(N-1) : extr(2);
    
   case 'log'
    if (extr(1) <= 0)
      disp('The first limit must be strictly positive');
      return;
    end
    out = exp(vect(log(extr(1)),log(extr(2)),N));
    
   case 'sqr'
    out = (vect(sqrt(extr(1)),sqrt(extr(2)),N)).^2;
       
   otherwise
    disp ( 'USAGE: out=vect(deb,fin,N[,typ][,closeness])');
    error(['Unknown closeness or vector type ''' typ '''.']);
    
  end
  
 otherwise
  disp ( 'USAGE: out=vect(deb,fin,N[,typ][,closeness])');
  error(['Unknown closeness ''' closeness '''.']);
  
end

% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
