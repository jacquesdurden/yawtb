function [out] = mexican1d(k,order,sigma)
% \manchap
%
% Compute the 1D Mexican Wavelet in frequency plane
%
% \mansecSyntax
% [out] = mexican1d(k,order,sigma);
%
% \mansecDescription
% This function computes the 1D Mexican wavelet in frequency plane.
% That is, the wavelet given by
% \begin{verbatim}
%   PSIHAT (k) = - |k|.^order .* exp( - sigma^2 * k.^2 / 2 )
% \end{verbatim}
% where PSIHAT is the Fourier transform of PSI.
%
% This wavelet depends of two parameters: order, sigma.
% This function is used by the cwt1d routine which compute
% continuous wavelet transform in 1D.
%
% \mansubsecInputData
% \begin{description}
%
% \item[k] [REAL VECTOR]: The frequency plane. Use \libfun{vect} or
% \libfun{yapuls} to create it. 
%
% \item[order, sigma] [REAL SCALARS]: The wavelet
% parameters. 
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL VECTOR]: The wavelet on the frequency line. 
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> k = vect(-pi,pi,128);
% >> wav = mexican1d(k,6,1);
% >> plot(k, wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwt1d yapuls
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1d/wave_defs/mexican1d.m,v 1.4 2004-03-03 08:00:32 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmay take the value
%% of sigmax as default.

wavparval = {'order', 2, 'sigma', 1};

%% Return only wavparval if an empty input is given as k
if ( (nargin == 1) & isempty(k) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
out = - (2*pi) * (k.^2).^(order/2) .* exp( - (sigma*k).^2 / 2 );


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
