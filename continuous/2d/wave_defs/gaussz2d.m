function [out] = gaussz2d(kx,ky,order,sigma,sigmax,sigmay)
% \manchap
%
% Compute the 2D z order derivative of Gaussian
%
% \mansecSyntax
% [out] = gaussz2d(kx,ky,order,sigma[,sigmax][,sigmay])
%
% \mansecDescription
% This function computes the 2D x order derivative of Gaussian.
% That is, the wavelet given by
%
% \begin{verbatim}
% PSIHAT (kx,ky) = i*(kx + i*ky).^order .* exp( - (A*K).^2 / 2 )
%
% where PSIHAT is the Fourier transform of PSI;
%       K = (kx,ky);
%       A = diag(sigmax,sigmay).
% \end{verbatim}
%
% Notice that for real images, inside a CWT computed with the gaussz2d wavelet:
%    - order = 1: gives the gradient of the smoothed analyzed image in
%    complex representation
%    - order = 2: gives the maximum curvature of this smoothed
%    image vector in complex coordinates.
%
% This wavelet depends of three parameters: order, sigmax, sigmay. 
% This function is used by the cwt2d routine which compute
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx,ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[order, sigma, sigmax, sigmay] [REAL SCALARS]: The wavelet
% parameters. By default, sigmax = sigmay = sigma (isotropic case).
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
% >> wav = gaussz2d(kx,ky,6,1);
% >> imagesc(wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
% cwt2d meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/gaussz2d.m,v 1.3 2001-10-28 16:06:05 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {'order',1,'sigma',1,'sigmax','*sigma','sigmay','*sigma'};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Managing the inputs

if ~exist('sigmax')
  sigmax = sigma;
end

if ~exist('sigmay')
  sigmay = sigma;
end

%% Computing the wavelet in frequency domain
out = (i*(kx + i*ky)) .^ order ...
      .* exp( - ((sigmax*kx).^2 + (sigmay*ky).^2) / 2 );


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
