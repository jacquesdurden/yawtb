function out = gabor2d_wav(kx,ky, nang, k0, sigma, autospread)
% \manchap
%
% The wavelet of the Gabor frame.
%
% \mansecSyntax
%
% out = gabor2d\_app(kx, ky, nang, sigma, autospread)
%
% \mansecDescription
%
% Compute the wavelet of the Gabor frame, that is a Gabor function
% given by
% \begin{verbatim}
% PSIHAT(kx,ky) = exp( - 0.5 * [ ((kx - k0)/wx)^2 + (ky/wy)^2 ] ),
% \end{verbatim}
% where k0 = 3*pi/4, \libvar{wx} and 'wy' are respectively
% the horizontal and the vertical spread. 
% 'wx' is always equal to 1/\libvar{sigma}. 
% In the case where autospread is set to 1, 'wy' is computed to
% obtain a complete angular covering according to the number of
% sectors \libvar{nang}. If \libvar{autospread} is set to 0
% (default), then 'wy' equals 'wx', that is 1/\libvar{sigma}.
%
% \mansubsecInputData
% \begin{description}
% \item[kx] [MATRIX]: the horizontal frequencies; 
%
% \item[ky] [MATRIX]: the vertical frequencies; 
%
% \item[nang] [INTEGER]: the number of angular sectors on which the
% frame decomposition is computed.
%
% \item[sigma] [REAL]: the horizontal spread of the gabor function
% in position.
%
% \item[autospread] [BOOLEAN]: 1 if 'wy' must be set to obtain a
% complete angular covering with 'nang' rotated wavelets, 0 if not.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the computed function on the frequency plane.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >>
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/2d/frame_defs/gabor2d_wav.m,v 1.11 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (isempty(kx))
  %% The value of sigma is determined to ensure a pseudo
  %% admissibility, namely sigma > 5.6
  out = {'k0', 3*pi/4, 'sigma', 1};
  return;
end

wx = sigma;
wy = sigma*2;

out = exp( - 0.5 * ( ((kx - k0)*wx).^2 + (ky*wy).^2 ) ); 

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
