function img = iwpck2d(yawpck)
% \manchap
%
% Compute the reconstruction of the wavelet packets transform
%
% \mansecSyntax
% [img] = iwpck2d(yawpck)
%
% \mansecDescription
% 
% This function computes the reconstruction of the wavelet packets
% transform from the output of the 'wpck2d' function which
% calculates the wavelet packet decomposition.
%
% \mansubsecInputData
% \begin{description}
% \item[yawpck] [STRUCT]: The output of 'wpck2d'  
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[img] [COMPLEX MATRIX]: the rebuilded image.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> mat = theL(128);
% >> fmat = fft2(mat);
% >> sc = linspace(0.3,10,12);
% >> ypck = wpck2d(fmat,'pmexican',sc);
% >> figure; imagesc(real(ypck.approx));
% >> figure; imagesc(real(ypck.details(:,:,1)));
% >> figure; imagesc(real(iwpck2d(ypck)));
% \end{code}
% Compute the wavelet packet decomposition of a 'L' picture (see
% 'theL'), show the approximation at the last scale and the first
% details and finally display the rebuilded image.
%
% \mansecReference
%
% \mansecSeeAlso
%
% wpck2d pmexican2d theL
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/discrete/packet/2d/iwpck2d.m,v 1.1 2002-06-17 11:06:20 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% Managing the inputs
if ~isfield(yawpck,'wpck')
  error('The input is not a yawtb object coming from wpck2d');
end


%% Initialization

[nrow,ncol] = size(yawpck.approx);
[kx,ky]     = meshgrid( yapuls(ncol), yapuls(nrow) );

wpckname    = yawpck.wpck;
scales      = yawpck.sc;

nsc         = length(scales);
img         = zeros(nrow,ncol);

pwavopts    = yawopts(yawpck.extra,wpckname);
strpwavopts = '';
for k=1:length(pwavopts)
  strpwavopts = [ strpwavopts ',pwavopts{' num2str(k) '}' ];
end

nkx  = scales(nsc)*kx;
nky  = scales(nsc)*ky;
mask = eval([wpckname '(nkx,nky,''dscaling'',[]' strpwavopts ')']);

if length(mask) > 1
  img  = ifft2(fft2(yawpck.approx) .* mask);
else
  img  = yawpck.approx;
end

%% The linear case is very simple
testmask = ...
    eval([wpckname '(nkx,nky,''dwavelet'',2' strpwavopts ')']);

if length(testmask) == 1
  img = img + sum(yawpck.details,3);
  return
end

%% The non linear case
for index=2:nsc,
  nkx  = scales(index)*kx;
  nky  = scales(index)*ky;
  mask = eval([wpckname '(nkx,nky,''wavelet'','...
	       'scales(index-1)/scales(index)' strpwavopts ')']);
  img  = img + ifft2(fft2(yawpck.details(:,:,index-1)) .* mask);
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
