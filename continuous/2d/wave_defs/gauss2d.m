function [out] = gauss2d(kx,ky,sigma)
% \manchap
%
% Compute the bidimensionnal Gaussian
%
% \mansecSyntax
% [out] = gauss2d(kx,ky,sigma)
%
% \mansecDescription
% This function computes the bidimensionnal Gaussian.
% This is not truly a wavelet but this function can be usefull for
% approximation calculation.
%
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx,ky] [REAL MATRICES]: The frequency plane. Use meshgrid
% to create it. 
%
% \item[sigma] [REAL SCALARS]: The spread of the Gaussian.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: The Gaussian in frequency plane. 
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> step = 2*pi/128;
% >> [kx,ky] = meshgrid( -pi : step : (pi-step) );
% >> wav = gauss2d(kx,ky,6,1);
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
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/gauss2d.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% List of wavelet parameters name and default value

%% List of wavelet parameters name and default value
wavparval = {'sigma',1};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the Gaussian in frequency domain
out = exp( - sigma^2 * (kx.^2 + ky.^2)/2 );


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
