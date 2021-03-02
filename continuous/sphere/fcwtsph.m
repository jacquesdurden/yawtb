function out = fcwtsph(fimg, wavname, scales, angles, varargin)
% \manchap
%
% Compute the fast spherical wavelet transform
%
% \mansecSyntax
%
% out = fcwtsph(fimg, wavname, scales [,WaveletParameter] )
%
% out = fcwtsph(fimg, wavname, scales [,'WaveletOptionName', 
%             WaveletOptionValue] )
%
% \mansecDescription
%
% This function performs a spherical wavelet transform on a
% sphere in spherical coordinates. The algorithm is based on the
% use of FFT according phi coordinates (phi and theta are of
% course defined on a cartezian grid). The computation time is of
% order $N^3\log(N)$ if mat is an $N\times{}N$ matrix. Wavelets are taken
% inside the sub directory 'wave\_defs' (see the README to know how
% to write your own wavelet). 
%
% \mansubsecInputData
% \begin{description}
% \item[fimg] [DOUBLE MATRIX] : the fast spherical transform of the
% data (cfr fst)
%
% \item[wavname] [STRING]: the name of the wavelet to use (see
% yawtb/continuous/sphere/wave\_defs for existing wavelet); 
%
% \item[scales] [DOUBLE VECTOR] : the interval of scales where you
% want to compute a spherical CWT.
%
% \item[angles] [DOUBLE VECTOR] : the interval of angles where you
% want to compute a spherical CWT.
%
% \item[WaveletParameter] [MISC]: a wavelet parameter. His type
% depend of the wavelet used. See the corresponding wavelet mfile
% (inside wave\_defs) for the correct parameters.
%
% \item[WaveletOptionName,WaveletOptionValue] [STRING, MISC]:
% Another way of writting wavelet parameters. The wavelet parameter
% name (a string) is followed by its value. See the corresponding
% wavelet mfile (inside wave\_defs) for the parameter to enter.
%
% \end{description} 
%
% \mansubsecOutputData
%
% \begin{description}
% \item[out] [YAWTB OBJECT]: contains the different results of cwtsph
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world2; mat = double(mat); 
% >> fmat = fst(mat);
% >> wav = fcwtsph(fmat,'dog',0.05,0);
% >> yashow(wav);
% \end{code}
%
% \mansecReference
% [1] : "Ondelettes directionnelles et ondelettes sur la
%        sphère", P. Vandergheynst, Thèse, Université Catholique
%        de Louvain, 1998  
%
% \mansecSeeAlso
%
% cwtsph\_yashow 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/sphere/fcwtsph.m,v 1.10 2007-09-20 12:54:08 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

% Check the good availability of important software
if (exist('s2fst') == 3)
  fst_func = @s2fst;
  ifst_func = @s2ifst;
elseif (exist('fst') == 3)
  fst_func = @fst;
  ifst_func = @ifst;
else
  disp(['You need to compile S2kit or SpharmonicKit interface' ...
	' first']);
  disp(['Read README files in yawtb/interfaces/s2kit or in' ...
	' yawtb/interfaces/spharmonickit']);  
  return
end

%% Handling the input
wavname = lower(wavname);

if (exist([wavname 'sph']) >= 2) 
  wavname = [ wavname 'sph'];
elseif (exist(wavname) < 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 'sph'' doesn''t exist!']);
end
  
wavfunc = str2func(wavname);

if ~exist('varargin')
  varargin = {};
end

export = getopts(varargin, 'export', [], 1);

%% Keeping the recording of varargin into output for
%% reproducibility

if (~export)
  out.extra = varargin;
end


if (~all(isnumeric(scales))) | (~all(isnumeric(angles))) 
  error('scale(s) and angle(s) must be numeric');
end

%% Determining the wavelet parameters
wavopts      = yawopts(varargin,wavname);

%% Misc initializations
L = size(fimg,1);
L2 = 2*L;

if (L ~= size(fimg,2))
  yahelp fcwtsph usage
  error('The input matrix must be square');
end


nsc       = length(scales);
nang      = length(angles);

fgridsize = getopts(varargin, 'fgrid', L2);
if ( (fgridsize < L2) | ...
     (rem(fgridsize, 1) ~= 0) )
  error(['The size of the grid supporting filter must be at least' ...
	 ' equal to this of the original data.']);
end

[ph,th]   = sphgrid(fgridsize);

%% Spherical coordinates on sphere:
X      = sin(th).*cos(ph); 
Y      = sin(th).*sin(ph);
Z      = cos(th);

%% Parameter for the spherical frequency domain
l = 0:(L-1);

%% True computation of the Spherical CWT

if (~export)
  out.data  = zeros(L2,L2,nsc,nang);
else
  out = zeros(L2,L2,nsc,nang);
end

if (nsc*nang > 1)
  oyap      = yapbar([],nang*nsc);
end

for sc = 1:nsc,
  for ang = 1:nang,
    %% Setting the current scale and angle
    csc  = scales(sc);
    cang = angles(ang);
    
    %% Call of the wavelet function through 'eval'.
    filter = wavfunc(X,Y,Z, 0,0,1, csc,cang, wavopts{:});
    
    %% Fast Zonal Transform of filter
    ffilter = fst_func(filter);
    
    %% Make the filter correct for convolution
    mask = ilmshape(repmat(ffilter(1,1:L)*(4*pi)^.5./(2*l+1).^.5,L2-1,1));
    
    %% The kth row of the final result (the spherical wavelet
    %% transform) is equal to the row convolution
    
    if (~export)
      out.data(:,:,sc,ang) = ifst_func(fimg .* mask);
      out.ffilter{sc,ang} = ffilter(1,:);
    else
      out(:,:,sc,ang) = ifst_func(fimg .* mask);
    end

    %% Deleting/Writing the progress line
    if (sc*nang > 1)
      oyap = yapbar(oyap,'++');
    end
    
  end
end

if (sc*nang > 1)
  oyap = yapbar(oyap,'close');
end

if (~export)
  out.type  = 'cwtsph';
  out.wav   = wavname;
  out.para  = wavopts(:);
  out.sc    = scales;
  out.ang   = angles;
  out.extra = varargin;
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
