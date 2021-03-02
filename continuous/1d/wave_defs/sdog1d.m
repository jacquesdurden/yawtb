function [out] = sdog1d(k,alpha)
% \manchap
%
% 1D Scaling Difference Of Gaussian wavelet in the frequency domain
%
% \mansecSyntax
% [out] = sdog1d(k,alpha)
%
% \mansecDescription
% 
% This function returns \libvar{out} the 1D Scaling Difference Of Gaussian
% wavelet in the frequency domain defined in that domain by:
% \begin{verbatim}
%   out = exp( - k.^2 ) - exp ( - alpha^2 * k.^2)
% \end{verbatim}
%
% \mansubsecInputData
% \begin{description}
%
% \item[k] [REAL MATRIX]: The frequency. You can use the \YAWTB
% function \libfun{vect} to create it (see example below).
%
% \item[alpha] [REAL SCALAR]: The wavelet parameter.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: The wavelet in frequency.
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> step = 2*pi/128;
% >> k = -pi : step : (pi-step);
% >> wav = sdog1d(freqs,6);
% >> plot(k,wav);
% \end{code}
%
% Note that the two first lines are implemented by the \YAWTB
% \libfun{vect} function:
% \begin{code}
% >> k = vect(-pi,pi,128,'open');
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/1d/cwt.* ^continuous/1d/wave_defs/.* /vect$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1d/wave_defs/sdog1d.m,v 1.9 2002-07-02 19:54:55 coron Exp $
%
% Copyright (C) 2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value

%% List of wavelet parameters name and default value
wavparval = {'alpha', 1.25};

%% Return only wavparval if an empty input is given as k
if ( (nargin == 1) & isempty(k) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
k2 = k.^2;
out = exp( - k2/2 ) - exp( - alpha^2 * k2/2 );


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
