function out = pmexican2d(kx,ky,mode,alpha)
% \manchap
% 
% Return the 2D mexican wavelet or scaling function packets
%
% \mansecSyntax
% out = pmexican2d(kx,ky,mode[,alpha])
%
% \mansecDescription
% Return the 2D mexican wavelet or scaling function packets
%
% \mansubsecInputData
% \begin{description}
%
% \item[kx,ky] [REAL MATRIX] the frequency plane
%
% \item[mode]
% ['infinit'|'scaling'|'wavelet'|'dscaling'|'dwavelet']:
% specify the function to return through out. So, you can have the
% integrated scaling function ('scaling'), the wavelet packet
% ('wavelet'), the duals of these (respectively 'dscaling' and
% 'dwavelet') useful for the reconstruction, and finally the
% infinitesimal wavelet ('infinit'), that is the 2D mexican hat.
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
%
% \mansecSeeAlso
%
% wpck2d mexican2d gaussian2d
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/discrete/packet/2d/wpck_defs/pmexican2d.m,v 1.1 2002-06-17 11:06:20 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
wavparval = {};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Managing the inputs

%% Computing
switch lower(mode)
  %% The infinitesimal wavelet
 case 'infinit',
  out = mexican2d(kx,ky,2,1);
  
  %% The packed scaling functiion
 case 'scaling',
  out = gaussian2d(kx,ky,1);
  
  %% The packed wavelet
 case 'wavelet',
  out = gaussian2d(alpha*kx,alpha*ky,1) - ...
	gaussian2d(kx,ky,1);
  
  %% The dual packed scaling function (used for reconstruction)
 case 'dscaling'
  out = 1;
  
  %% The dual packed wavelet (used for reconstruction)
 case 'dwavelet'
  out = 1;
  
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
