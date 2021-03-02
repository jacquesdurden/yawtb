function [out] = esmex2d(kx,ky,sigma,epsilon)
% \manchap
%
% Compute the endstop 2D Mexican Wavelet in frequency plane
%
% \mansecSyntax
% [out] = esmex2d(kx,ky,sigma,epsilon)
%
% \mansecDescription
% This function computes the 2D Mexican wavelet in frequency plane.
% That is, the wavelet given by
% \begin{verbatim}
%   PSIHAT (kx,ky) = |K|^2 * exp( - (sigma*K)^2 / 2 )
%                    * A * exp(- A^2 / (2 epsilon^2) ); 
% \end{verbatim}
% where, 
% \begin{itemize}
% \item PSIHAT is the Fourier transform of PSI;
% \item $K = (kx,ky)$;
% \item $A = $arg$(K) = $atan$(ky/kx)$;
% \item epsilon is the inverse of the angular selectivity of PSI.
% \end{itemize}
%
% This wavelet depends on two parameters: sigma, epsilon. These are
% respectively the radial spread and the angular selectivity.
%
% This function is used by the cwt2d routine which computes
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[sigma, epsilon] [REAL SCALARS]: The wavelet
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
% >> wav = esmex2d(kx,ky,1,2);
% >> yashow(wav);
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
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/esmex2d.m,v 1.5 2001-12-18 16:05:39 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {'sigma',1,'epsilon',0.5};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain


th    = atan2(ky,kx)/epsilon; 


out = sin(th) .* (kx.^2 + ky.^2) .* ...
      exp( - sigma^2 * (kx.^2 + ky.^2) / 2 ) .* ...
      exp( - th.^2 / 2);


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
