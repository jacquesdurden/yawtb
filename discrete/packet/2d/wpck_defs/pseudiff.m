function out = pseudiff(kx,ky,mode,alpha,n)
% \manchap
%
% Return the 2D pseudo differential operator $k^n$ wavelet
%
% \mansecSyntax
% out = pseudiff(kx, ky, mode [, alpha])
%
% \mansecDescription
% Return the 2D pseudiff wavelet or scaling function packets
% based on the recursive filter
% \begin{verbatim}
%   phi_n(k) = 0.5*k^(n-2) + 0.5*(n-2)*phi_(n-2)(k)
% \end{verbatim}
% (implemented in phin.m)
% So, the wavelet packet is
% \begin{verbatim}
%   wpck = \sqrt(phi_n(k) - phi_n(alpha*k))
% \end{verbatim}
% and the scaling function
% \begin{verbatim}
%   wphi = \sqrt(phi_n(k))
% \end{verbatim}
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx, ky] [REAL MATRIX] the frequency plane
%
% \item[mode]
% ['infinit'|'scaling'|'wavelet'|'dscaling'|'dwavelet']:
% specify the function to return through out. So, you can have the
% integrated scaling function ('scaling'), the wavelet packet
% ('wavelet'), the duals of these (respectively 'dscaling' and
% 'dwavelet') useful for the reconstruction, and finally the
% infinitesimal wavelet ('infinit'), that is the 2D mexican hat.
%
% \item[alpha] [REAL]: the scale ratio defining the packet wavelet.
%
% \item[n] [INTEGER]: the order of the pseudiff wavelet packet.
%
% \end{description} 
% 
% \mansubsecOutputData
% \begin{description}
%
% \item[out] The frequency mask of the returned function.
%
% \end{description} 
%
% \mansecExample
%
% \mansecReference
% P. Vandergheynst, "Ondelettes directionnelles et Ondelettes sur la
% Sphère", PhD Thesis, Louvain-la-Neuve, 1998.
%
% \mansecSeeAlso
%
% wpck2d mexican2d gaussian2d phin
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/discrete/packet/2d/wpck_defs/pseudiff.m,v 1.1 2002-06-17 11:06:20 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
wavparval = {'n',2};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Managing the inputs

%% Initialization
k = sqrt(kx.^2 + ky.^2);

%% Computing
switch lower(mode)
  %% The infinitesimal wavelet
 case 'infinit',
  out = [];
  
  %% The packed scaling functiion
 case 'scaling',
  out = sqrt(phin(k,n));
  
  %% The packed wavelet
 case 'wavelet',
  
  out = sqrt(phin(k,n) - phin(alpha*k,n));
  
  %% The dual packed scaling function (used for reconstruction)
 case 'dscaling'
  out = sqrt(phin(k,n));;
  
  %% The dual packed wavelet (used for reconstruction)
 case 'dwavelet'
  out = sqrt(phin(k,n) - phin(alpha*k,n));;
  
 otherwise
  error(['The mode ''' mode ''' is unrecognized']);
  
end


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
