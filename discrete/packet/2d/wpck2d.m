function out = wpck2d(fimg,wpckname,scales,varargin)
% \manchap
%
% Compute the packet wavelet transform (details and approximation)
%
% \mansecSyntax
% out = wpck2d(fimg,wpckname
%                [,'PckParameterName',PckParameterValue]...)
%
% \mansecDescription
% This function computes the (isotropic) wavelet packets of an
% image given through its Fourier transform fimg. The approximation
% is calculated from the last scale of 'scales' (recorded inside
% out.approx) and all details define a volume 'out.details' within
% each z slide corresponds to a fixed scale.
%
% \mansubsecInputData
% \begin{description}
%
% \item[fimg] [COMPLEX MATRIX]: The FFT of the original image.
%
% \item[wpckname] [STRING]: the name of the wavelet/scaling packet
% to use (see pck\_defs subdir for available packets).
%
% \item[scales] [POSITIVE REAL VECTOR]: the vector of scales.
%
% \item[PckParameterValue] [MISC]: the value of a precised packet
% parameter. See the code of the corresponding wavelet packet for
% explanations
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRUCT] a yawtb object such that:
%    \begin{itemize}
%    \item out.approx [COMPLEX MATRIX]: contains the approximation at the
%          last scale of the image.
%    \item out.details [COMPLEX VOLUME]: contains the details at each
%           scale (zslides correspond to fixed scale.
%    \item out.scales [POSITIVE REAL VECTOR]: the scales.
%    \item out.extra [LIST]: the extra parameter given to wpckname.
%    \item out.wpckname [STRING]: the name of the packet.
%    \item out.type [STRING]: the name of the mfile, that is wpck2d.
%    \end{itemize}
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> mat = theL;
% >> tmat = fft2(mat);
% >> scales = vect(0.5,10,12);
% >> pwav = wpck2d(tmat,'pmexican',scales);
% >> figure; imagesc(real(pwav.approx)); // TODO yashow(pwav)!!!
% >> figure; imagesc(real(pwav.details(:,:,1)));
% >> figure; imagesc(real(pwav.details(:,:,3)));
% \end{code}
%
% \mansecReference
% [1] Bruno Torrésani. Analyse Continue par Ondelettes, ???
% 
% \mansecSeeAlso
%
% iwpck2d theL pmexican2d 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/discrete/packet/2d/wpck2d.m,v 1.2 2002-07-25 12:31:40 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Initialization

[nrow,ncol] = size(fimg);
[kx,ky]     = meshgrid( yapuls(ncol), yapuls(nrow) );

nsc         = length(scales);
nang        = length(angles);

out.approx  = zeros(nrow,ncol);
out.details = zeros(nrow,ncol,nsc,nang);


%% Keeping the recording of varargin into output for
%% reproducibility
out.extra = varargin;

%% Finding the wpckname
wpckname = lower(wpckname);
if (exist([wpckname '2d']) == 2) 
  wpckname = [ wpckname '2d'];
elseif (exist(wpckname) ~= 2)
  error(['The wavelet packet ''' wpckname ''' or ''' wpckname ...
	 '2d'' doesn''t exist!']);
end

%% Determining the wavelet parameters
pwavopts    = yawopts(varargin,wpckname);
strpwavopts = '';
for k=1:length(pwavopts)
  strpwavopts = [ strpwavopts ',pwavopts{' num2str(k) '}' ];
end

%% True computing

%% The approximation at scale 'scales(nsc)'
nkx        = scales(end)*kx;
nky        = scales(end)*ky;

mask       = eval([wpckname '(nkx,nky,''scaling'',[]' strpwavopts ')']);
out.approx = ifft2(fimg .* conj(mask));

%% The detailsindex
for sc = 2:nsc,
  for ang = 1:nang;
    
    csc  = scales(sc);
    cang = angles(ang);
   
    [nkx, nky] = yadiro(kx, ky, csc, cang, 'freq');

    mask = eval([wpckname '(nkx,nky,''wavelet'','...
		 'scales(sc-1)/scales(sc)' strpwavopts ')']);
    out.details(:,:,sc-1) = ifft2(fimg .* conj(mask));
  end
end

out.type  = mfilename;
out.wpck  = wpckname;
out.sc    = scales;

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
