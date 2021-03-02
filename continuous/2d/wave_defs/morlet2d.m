function [out] = morlet2d(kx,ky,k_0,sigma,epsilon)
% \manchap
%
% Compute the 2D Morlet Wavelet in frequency plane
%
% \mansecSyntax
% [out] = morlet2d(kx,ky,k\_0,sigma)
%
% \mansecDescription
% This function computes the 2D Morlet wavelet in frequency plane.
% That is, the wavelet given by
% \begin{verbatim}
%   PSIHAT (kx,ky) = exp( - sigma^2 * ( (kx - k0).^2 + (epsilon*ky).^2 ) / 2)
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI.
% This wavelet depends of two parameters: k0 and sigma.
% It is not truly admissible but for sigma*K\_0$>$5.5, it is
% considered numerically admissible.
% This function is used by the cwt2d routine which compute
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[k\_0, sigma, epsilon] [REAL SCALARS]: The wavelet parameters. 
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
% >> wav = morlet2d(kx,ky,6,1);
% >> imagesc(wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwt2d meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/morlet2d.m,v 1.9 2003-03-13 12:40:52 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
wavparval = {'k_0',6,'sigma',1,'epsilon',1};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
out = exp( - sigma^2 * ((kx - k_0).^2 + (epsilon*ky).^2)/2 );


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
