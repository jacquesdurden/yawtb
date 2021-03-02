function w = sphweight(Nth, Nph, varargin)
% \manchap
%
% Clenshaw-Curtis weights for spherical quadrature on grid (Odd x Even)
% 
% \mansecSyntax
%
% w = sphweight(Nth, Nph [,'nopoles'])
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[Nth] [INT]: the height of the grid
% \item[Nph] [INT]: the width of the grid. 
% \item['nopoles'] [BOOL]: use the square grid with no poles
% described in [2]
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[w] [REAL MATRIX]: the Clenshaw-Curtis weights or the
% quadrature weight of the grid obtained with the \libvar{nopoles}
% flag (see above) of size (Nth x Nph).
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> 
% \end{code}
%
% \mansecReference
%
% [1] J. P. Imhof, "On the Method for Numerical Integration of
% Clenshaw and Curtis", Numerische Mathematik 5, 138-141 (1963)
%
% [2] J.R. Driscol and D. M. Healy. Computing fourier transforms 
% and convolutions on the 2-sphere. Advances in Applied
% Mathematics, 15 :202-250, 1994.
%
% \mansecSeeAlso
%
% fftshp, ifftsph, yaspharm
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/sphweight.m,v 1.8 2003-11-17 14:40:56 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

nopoles = getopts(varargin, 'nopoles', [], 1);

if (nopoles)
  if ((Nth<1) | (rem(Nth,2) ~= 0) | (Nth~= Nph))
    yahelp('sphweight','usage');
    error(['sphweight: Nth=Nph must be even for the spherical grid' ...
	   ' without poles.']);
  end
else
  if ((Nth<1) | (rem(Nth,2) ~= 1))
    yahelp('sphweight','usage');
    error('sphweight: Nth must be odd for the grid with poles.');
  end
end

if (nopoles)
  B = Nth/2;
  
  kv = 0:(B-1);
  pv =  0:(2*B-1);
  
  [k,p] = meshgrid(pv, kv);
  
  th = (2*p+1)*pi/(4*B);
  thv = (2*pv+1)*pi/(4*B);
  w = (2*pi/B^2)*sin(thv).*((1./(2*kv+1))*sin((2*k+1).*th));
  w = repmat(w, Nph, 1).';
else
  n = (Nth-1)/2;
  u = 0:(Nth-2);
  fu = (1./(1-4*u.^2)) .* (1 - 0.5*((u==0)|(u==n))) .* (u <= n);
  w = (2/Nph)*real(ifft(fu));
  w = [w w(1)];
  w([1 end]) = 0.5*w([1 end]);
  w = repmat(w, Nph, 1).';
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
