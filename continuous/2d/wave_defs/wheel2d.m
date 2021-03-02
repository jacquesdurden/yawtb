function [out] = wheel2d(kx,ky,sigma)
% \manchap
%
% Compute the 2D Wheel wavelet in frequency plane
%
% \mansecSyntax
% [out] = pethat2d(kx,ky)
%
% \mansecDescription
% This function is based on the Aurell's 2D Pet Hat wavelet in frequency plane.
% It is given by:
% \begin{verbatim}
%                    _
%                   |   cos^2(pi/2 * log( |K| ) / log(sigma) )
% PSIHAT (kx,ky) = <                if 1/sigma <= |K| < sigma
%                   |   0           elsewhere
%                   `-
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI;
% \begin{verbatim}
%       K = (kx,ky);
% \end{verbatim}
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[sigma] [REAL]: The spread of the wavelet in frequency
% (default, sigma=$2^{0.5}$) 
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
% >> wav = wheel2d(kx,ky);
% >> yashow(wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwt2d pethat2d meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/wheel2d.m,v 1.3 2002-06-04 19:05:22 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {'sigma', 2};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Managing the inputs
if (sigma == 1)
  error('sigma must be greater than 1')
end

%% Computing the wavelet in frequency domain
k   = abs(kx + i*ky);
k((k < (1/sigma)) | (k >= sigma)) = 1/sigma;
out = cos( log(k)/log(sigma) * pi/2 ).^2;


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
