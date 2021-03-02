function out = samcwt2d(fimg,wavname,scales,angles,varargin)
% \manchap
%
% Compute the 2D CWT scale-angle measure
%
% \mansecSyntax
%
% sam = samcwt2d(fimg, wavname, scales, angles
%                 [, WaveletParameter ]
%                 [,'Norm', NormValue ] )
%
% sam = samcwt2d(fimg, wavname, scales, angles 
%                 [,'WaveletOptionName', WaveletOptionValue ]
%                 [,'Norm', NormValue ] )
%
% \mansecDescription
%
% This function compute the scale-angle measure of an image through its
% Fourier transform 'fimg', that is the integration over all the
% position of the CWT of mat according the wavelet 'wavname'.
%
% \mansubsecInputData
% \begin{description}
% \item[fimg] [COMPLEX MATRIX]: the Fourier transform of the image
%
% \item[wavname] [STRING]: the name of the wavelet. See
% \verb+yawtdir/continuous/2d/wave\_defs+ to see which wavelets are
% available.
%
% \item[scales, angles] [REAL VECTORS]: the scale and the angle vectors.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [YAWTB OBJECT]: the scale-angle measure.
% \end{description} 
%
% \mansecExample
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
% $Header: /home/cvs/yawtb/continuous/2d/samcwt2d.m,v 1.9 2002-04-23 10:11:34 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Managing of the input
if (nargin < 4 | nargout > 1)
  error('Argument Mismatch - Check Command Line');
end

if isnumeric(wavname)
  error('''wavname'' must be a string');
end

%% The wavelet matlab function must exist (in lower case) in the
%% wave_defs subdir.
%% Note tha the real name can be wavename or [wavname '2d'] to
%% avoid eventuel confusion with 1D wavelets. This case is checked
%% first, before the existence of 'wavname' alone.
wavname = lower(wavname);

if (exist([wavname '2d']) == 2) 
  wavname = [ wavname '2d'];
elseif (exist(wavname) ~= 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 '2d'' doesn''t exist!']);
end
  

if ~exist('varargin')
  varargin = {};
end

%% Keeping the recording of varargin into output for
%% reproducibility
out.extra = varargin;


if (~all(isnumeric(scales))) | (~all(isnumeric(angles))) 
  error('scales and angles must be numeric');
end

if (isempty(fimg)) fimg = 0; end

%% Choice of the normalization ('getopts' is part of yawtb: see the
%% 'utils' yawtb's subdirectory)
[NormChoice,varargin] = getopts(varargin,'norm','l2');
switch lower(NormChoice)
 case 'l2'
  norm = 1;
 case 'l1'
  norm = 0;
 otherwise %% Default: the L2 normalization.
  norm = 1;
end

%% Creation of the frequency plane ('vect' is part of yawtb: see
%% utils directory)
[Hgth,Wdth] = size(fimg);
[kx,ky]     = meshgrid( yapuls(Wdth), yapuls(Hgth) );
dmeas       = (kx(1,2) - kx(1,1)) * (ky(2,1) - ky(1,1));
nsc         = length(scales);
nang        = length(angles);
cang        = cos(angles);
sang        = sin(angles);
sam         = zeros(nsc,nang);

%% Determining the wavelet parameters
wavopts = yawopts(varargin,wavname);

%% Initializing the progress bar
oyap = yapbar([],nsc*nang);

%% Computing
wavcom  = [ wavname '(nkx,nky,wavopts{:})' ];

for sc = 1:nsc,
  for th = 1:nang,
    %% Incrementing the progress bar	
    oyap = yapbar(oyap,'++');
   
    %% Computing the sam coefficient
    
    if (angles(th))
      nkx = scales(sc) * ( cang(th)*kx - sang(th)*ky );
      nky = scales(sc) * ( sang(th)*kx + cang(th)*ky ); 
    else
      nkx = scales(sc) * kx; 
      nky = scales(sc) * ky;
    end
    
    mask = scales(sc)^norm * eval(wavcom);
    
    sam(sc,th) = sum(sum(abs(mask .* fimg).^2)) * dmeas;
  end
end

%% Closing the progress bar
oyap = yapbar(oyap,'close');

out.data  = sam;
out.type  = mfilename;
out.wav   = wavname;
out.para  = wavopts; 
out.sc    = scales;
out.ang   = angles;

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
