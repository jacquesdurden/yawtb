function [out] = endstop1(kx,ky,k_0,sigma,epsilon)
% \manchap
%
% Compute the single 2D EndStop Wavelet in frequency plane
%
% \mansecSyntax
% [out] = endstop1(kx,ky,k\_0,sigma)
%
% \mansecDescription
% This function computes the single 2D EndStop wavelet in frequency plane.
% This wavelet is by the derivation according to y of the Morlet
% wavelet of main frequency vector (k0,0).
% \begin{verbatim}
%   PSIHAT (kx,ky) = 
%      (i*ky) * exp( - sigma^2 * ( (kx-k_0).^2 + (ky/epsilon).^2 ) / 2)
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI.
%
% This wavelet depends of two parameters: k\_0 and sigma.
% This function is used by the cwt2d routine which computes
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx,ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[sigma] [REAL SCALAR]: The wavelet spread factor. 
%
% \item[epsilon] [REAL SCALAR]: The wavelet anisotropy factor. 
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: The wavelet in frequency plane. 
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> step = 2*pi/128;
% >> [kx,ky] = meshgrid( -pi : step : (pi-step) );
% >> wav = endstop1(3*kx,3*ky,6,1,1);
% >> yashow(wav);
% \end{code}
%
% \mansecReference
% [1] Sushil Kumar BHATTACHARJEE, "A Computational Approach to
% Image Retrieval", PhD Thesis, EPFL, Lausanne, 1999.
%
% \mansecSeeAlso
%
% cwt2d endstop2 meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/endstop1.m,v 1.9 2002-01-11 14:56:02 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value

%% List of wavelet parameters name and default value
wavparval = {'k_0',6,'sigma',1,'epsilon',1};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
%% The following formula doesn't like the formula of the help
%% because of the computing optimization.
out = (i*ky) .* ...
      exp( - sigma^2 * ((kx - k_0).^2 + (ky/epsilon).^2)/2 );



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
