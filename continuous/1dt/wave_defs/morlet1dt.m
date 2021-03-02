function [out] = morlet1dt(k,w,k_0,w_0)
% \manchap
%
% 1D+T Morlet Wavelet in wave-number/frequency domain
%
% \mansecSyntax
% out = morlet1dt(k,w,k\_0,w\_0)
%
% \mansecDescription
% This function returns \libvar{out} the 1D+T Morlet wavelet in the
% wave-number/frequency domain defined in that domain by:
% \begin{verbatim}
%   out = exp( - ( (k - k0).^2 + (w - w_0).^2 ) / 2).
% \end{verbatim}
%
% This wavelet depends on two parameters: \libvar{k\_0} and \libvar{w\_0}.
% It is not truly admissible but for \libvar{k\_0}$>$5.5 and
% \libvar{w\_0}$>$5.5, it is considered as numerically admissible.  This
% function is used by the \libfun{cwt1dt} routine which computes 1D+T
% continuous wavelet transform.
%
% \mansubsecInputData
% \begin{description}
%
% \item[k, w] [REAL MATRICES]: The wave-number/frequency domain. Use
% meshgrid to create them.
%
% \item[k\_0, w\_0] [REAL SCALARS]: The wavelet parameters. 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: The wavelet in wave-number/frequency domain. 
% \end{description} 
%
% \mansecExample
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/1dt/.* ^meshgrid$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1dt/wave_defs/morlet1dt.m,v 1.4 2002-07-03 08:36:20 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
wavparval = {'k_0',6,'w_0',6};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(k) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
out = exp( - ((k - k_0).^2 + (w + w_0).^2)/2 );% + ...
%      exp( - ((k + k_0).^2 + (w - w_0).^2)/2 );



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
