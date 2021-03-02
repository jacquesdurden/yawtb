function [out] = gauss1d(k)
% \manchap
%
% Compute the Gaussian in frequency
%
% \mansecSyntax
% [out] = gauss1d(k)
%
% \mansecDescription
% This function computes the Gaussian G in frequency.
% That is, the function given by
% \begin{verbatim}
%   GHAT (k) = exp( - (sigma*k).^2 / 2 )
% \end{verbatim}
% where GHAT is the Fourier transform of G;
%
% \mansubsecInputData
% \begin{description}
% \item[k] [REAL VECTOR]: The frequency vector.  
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: The Gaussian in frequency. 
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> k = fftshift(yapuls(128));
% >> wav = gauss1d(k,2,1);
% >> plot(k,-wav)
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwt1d meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1d/wave_defs/gauss1d.m,v 1.5 2004-01-02 09:37:25 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(k) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
out = exp( - k.^2 / 2 );


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
