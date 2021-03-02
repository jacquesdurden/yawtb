function [out] = endstop2(kx,ky,k_0,sigma)
% \manchap
%
% Compute the double 2D EndStop Wavelet in frequency plane
%
% \mansecSyntax
% [out] = endstop2(kx,ky,k\_0,sigma)
%
% \mansecDescription
% This function computes the double 2D EndStop wavelet in frequency plane.
% This wavelet is given by
% \begin{verbatim}
%   PSIHAT (kx,ky) = 
%      -4*pi/sigma^2 * (2*ky.^2 - sigma^2) * exp( - ( kx.^2 + ky.^2 ) / sigma^2)
%         * exp( - ( (kx-k_0).^2 + ky.^2 ) / 2)
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI.
% It results from the frequency multiplication [1] of a Morlet
% wavelet (k\_0,0) with an y double derivative of Gaussian.
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
% \item[order, sigma] [REAL SCALARS]: The wavelet parameters. 
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
% >> wav = endstop1(kx,ky,6,1);
% >> imagesc(wav);
% \end{code}
%
% \mansecReference
% [1] Sushil Kumar BHATTACHARJEE, "A Computational Approach to
% Image Retrieval", PhD Thesis, EPFL, Lausanne, 1999.
%
% \mansecSeeAlso
%
% cwt2d endstop1 meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/endstop2.m,v 1.8 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% List of wavelet parameters name and default value

%% List of wavelet parameters name and default value
wavparval = {'k_0',6,'sigma',1};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
%% The following formula doesn't like the formula of the help
%% because of the computing optimization.
sigma2 = sigma^2;
ky2    = ky.^2;

%% Here is the formula of Sushil but I think there is an error
%% cause this wavelet doesn't lead to the same result (in
%% particular for 'theL' sample)
out = -4*pi/sigma2 * ( 2*ky2 - sigma2 ) .* ...
      exp( - ( kx.^2 + ky2 ) / sigma2 ) .* ...
      exp( - ( (kx-k_0).^2 + ky2 ) / 2 );

%% For me the good expression is:
%% out = -4*pi/sigma2 * ky2 .* ...
%%      exp( - sigma2 * ( kx.^2 + ky2 ) / 2 ) .* ...
%%      exp( - sigma2 * ( (kx-k_0).^2 + ky2 ) / 2 );
%% which truly the product of a Morlet with a SDoG of same size

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
