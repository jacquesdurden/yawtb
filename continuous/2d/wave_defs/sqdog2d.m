function [out] = sqdog2d(kx,ky,alpha)
% \manchap
%
% Compute the square of 2D Scaling difference of Gaussian Wavelet
%
% \mansecSyntax
% [out] = sqdog2d(kx,ky,alpha)
%
% \mansecDescription
% This function computes the square of 2D Scaling difference of Gaussian
% Wavelet in frequency plane.
% This wavelet given by
% \begin{verbatim}
%   PSI(x,y)       = sdog2d(x,y,alpha).^2;
%   PSIHAT (kx,ky) = (1/2) * exp( - K.^2/4 ) ...
%            + 1/(2*alpha^2) * exp ( - alpha^2 * K.^2 / 4) ...
%            - 2/(alpha^2 + 1) * exp ( - alpha^2 * K.^2 / ...
%                                       (2*(alpha^2 + 1)) )
% \end{verbatim}
%
% where: PSIHAT is the Fourier transform of PSI and K = (kx,ky). 
% This wavelet depends of the alpha parmeter.
% This function is used by the cwt2d routine which compute
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use meshgrid
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
% >> wav = sdog2d(kx,ky,6,1);
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
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/sqdog2d.m,v 1.6 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value

%% List of wavelet parameters name and default value
wavparval = {'alpha', 1.25};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
k2  = kx.^2 + ky.^2;
al2 = alpha^2;
out = 0.5 * exp( - k2/4 ) ...
      + 1/(2*al2) * exp ( - al2 * k2 / 4) ...
      - 2/(al2 + 1) * exp ( - al2 * k2 / ...
			    (2*(al2 + 1)) );
out = out / (2*pi);


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
