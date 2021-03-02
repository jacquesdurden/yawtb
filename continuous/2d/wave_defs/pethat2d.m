function [out] = pethat2d(kx,ky)
% \manchap
%
% Compute the 2D Pet Hat wavelet in frequency plane
%
% \mansecSyntax
% [out] = pethat2d(kx,ky)
%
% \mansecDescription
% This function computes the Aurell's 2D Pet Hat wavelet in frequency plane.
% That is, the wavelet given by
% \begin{verbatim}
%                    _
%                   |   - cos^2(pi/2 * log2( |K| / 2^0.5 ) )
% PSIHAT (kx,ky) = <                if 1/2^0.5 <= |K| < 2*2^0.5
%                   |   0           elsewhere
%                   `-
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI;
% \begin{verbatim}
%       K = (kx,ky);
% \end{verbatim}
%
% Notice that we have scaled this wavelet from this original
% formulation to share the same maximum than the Mexican Hat (in
% $|K|=2^{0.5}$)
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
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
% >> wav = pethat2d(kx,ky,6,1);
% >> imagesc(wav);
% \end{code}
%
% \mansecReference
%
% P. Frick and Al., "Scaling and Correlation Analysis of Galactic
% Images", arXiv:astro-ph/0109017 v1, 3 Sep 2001
%
% E. Aurell and Al, 1994, Physica D, 72, 95
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
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/pethat2d.m,v 1.4 2003-07-10 12:10:31 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Managing the inputs

%% Computing the wavelet in frequency domain
k   = abs(kx + i*ky);
k((k < 2^(-0.5)) | (k >= 8^0.5)) = 2^(-0.5);
out = - cos( log2(k/2^0.5) * pi/2 ).^2;


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
