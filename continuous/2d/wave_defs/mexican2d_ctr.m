function [out] = mexican2d_ctr(kx,ky,order,sigma,sigmax,sigmay)
% \manchap
%
% Compute the 2D Mexican Wavelet in frequency plane
%
% \mansecSyntax
% [out] = mexican2d(kx,ky,order,sigma[,sigmax][,sigmay])
%
% \mansecDescription
% This function computes the 2D Mexican wavelet in frequency plane.
% That is, the wavelet given by
% \begin{verbatim}
%   PSIHAT (kx,ky) = |K|.^order .* exp( - (A*K).^2 / 2 )
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI;
% \begin{verbatim}
%       K = (kx,ky);
%       A = diag(sigmax,sigmay).
% \end{verbatim}
%
% This wavelet depends of three parameters: order, sigmax, sigmay. 
% This function is used by the cwt2d routine which compute
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use meshgrid
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
% >> wav = mexican2d(kx,ky,6,1);
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
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/mexican2d_ctr.m,v 1.2 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.
%% WARNING: Must have the same parameters than mexican2d.m
wavparval = {'order',2,'sigma',1,'sigmax','*sigma','sigmay','*sigma'};

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
out = exp( - ((sigmax*kx).^2 + (sigmay*ky).^2) / 2 );


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
