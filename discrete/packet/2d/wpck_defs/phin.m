function [out] = phin(k,n)
% \manchap
%
% The scaling function associated to the pseudo-diff operator
%
% \mansecSyntax
% [out] = phin(k,n)
%
% \mansecDescription
%
% this function computes the scaling function
% associated to the pseudo-diff operator k$^n$, n$\geq$ 2
% using the recursion formula:
% \begin{verbatim}
%   phi_n(k) = 0.5*k^(n-2) + 0.5*(n-2)*phi_(n-2)(k)
% \end{verbatim}
%
% \mansubsecInputData
% \begin{description}
%
% \item[k] [REAL MATRIX]: The radial frequency
%
% \item[n] [INTEGER]: The order of the function (see formula above)
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: the resulting function
% \end{description} 
%
% \mansecExample
%
% \mansecReference
%
% \mansecSeeAlso
% 
% pseudiff, wpck2d
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/discrete/packet/2d/wpck_defs/phin.m,v 1.1 2002-06-17 11:06:20 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% scale s.t. f(pi/4) ~= 0 for n= 4
k=k/2;

%% Computing the output through an internal (recursive) function
%% phinb (see below)
out = phinb(k,n);

%% normalization such that phin(0) = 1

if ~rem(n,2)
   norm = 0.5;
   for i=1:(n-2)/2
       norm = norm*(n - 2*i)/2;
   end
else
   norm = sqrt(pi)/4;
   for i=1:(n-3)/2
       norm = norm*(2*i + 1)/2;
   end
end

out = out/norm;

%% The internal function
function res = phinb(k,n);

if (n == 2)
   res = 0.5*exp(-k.*k);
elseif (n==3)
   res = 0.5*k.*exp(-k.*k) + 0.25*sqrt(pi)*erfc(k);
else
   res = 0.5*(k.^(n-2)).*exp(-k.*k) + 0.5*(n-2)*phinb(k,n-2);
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
