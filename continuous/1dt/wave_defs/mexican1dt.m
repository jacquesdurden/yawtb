function [out] = mexican1dt(k,w,order,sigma,sigmax,sigmat)
% \manchap
%
% 1D+T Mexican Wavelet in wave-number/frequency domain
%
% \mansecSyntax
% out = mexican1dt(k,w,order,sigma[,sigmax][,sigmat])
%
% \mansecDescription
% This function returns \libvar{out} the 1D+T Mexican wavelet in the
% wave-number/frequency domain defined in that domain by:
% \begin{verbatim}
%   out = |K|.^order .* exp( - (A*K).^2 / 2 )
% \end{verbatim}
% with
% \begin{verbatim}
%       K = (k,w);
%       A = diag(sigmax,sigmat).
% \end{verbatim}
%
% This wavelet depends on three parameters: \libvar{order}, \libvar{sigmax},
% \libvar{sigmat}. This function is used by the \libfun{cwt1dt} routine
% which computes 1D+T continuous wavelet transform.
%
% \mansubsecInputData
% \begin{description}
%
% \item[k, w] [REAL MATRICES]: The wave-number/frequency domain. Use meshgrid
% to create them. 
%
% \item[order, sigma, sigmax, sigmat] [REAL SCALARS]: The wavelet
% parameters. By default, \libvar{sigmax} = \libvar{sigmat} = \libvar{sigma}
% (isotropic case).
%
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
% $Header: /home/cvs/yawtb/continuous/1dt/wave_defs/mexican1dt.m,v 1.3 2002-07-03 08:35:58 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
%% Note that you can specify that sigmat take the value
%% of sigmax as default.

wavparval = {'order',2,'sigma',1,'sigmax','*sigma','sigmat','*sigma'};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(k) )
  out = wavparval;
  return
end

%% Managing the inputs

if ~exist('sigmax')
  sigmax = sigma;
end

if ~exist('sigmat')
  sigmat = sigma;
end

%% Computing the wavelet in frequency domain
out = (2*pi) * (k.^2 + w.^2).^(order/2) ...
      .* exp( - ((sigmax*k).^2 + (sigmat*w).^2) / 2 );


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
