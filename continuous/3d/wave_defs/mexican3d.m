function [out] = mexican3d(kx,ky,kz,order,sigma)
% \manchap
%
% Compute the 3D Mexican Wavelet in frequency plane
%
% \mansecSyntax
% [out] = mexican3d(kx,ky,kz,order,sigma)
%
% \mansecDescription
% This function computes the 3D Mexican wavelet in frequency plane.
% That is, the wavelet given by
% \begin{verbatim}
%   PSIHAT (kx,ky,kz) = |K|.^order .* exp( - (sigma*K).^2 / 2 )
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI;
% \begin{verbatim}
%       K = (kx,ky,kz);
% \end{verbatim}
%
% This wavelet depends of two parameters: order, sigma.
% This function is used by the cwt3d routine which compute
% continuous wavelet transform in 3D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky, kz] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[order, sigma] [REAL SCALARS]: The wavelet
% parameters. 
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: The wavelet in the 3D frequency plane. 
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> [kx,ky,kz] = meshgrid( vect(-pi,pi,64) );
% >> wav = mexican3d(kx,ky,kz,2,1);
% >> imagesc(wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwt3d meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/3d/wave_defs/mexican3d.m,v 1.2 2008-09-09 07:24:58 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {'order',2,'sigma',1};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Managing the inputs

%% Computing the wavelet in frequency domain
K2  = (kx.^2 + ky.^2 + kz.^2);
out = (2*pi)^(1.5) * K2.^(order/2) .* exp( - sigma^2 * K2 / 2 );


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
