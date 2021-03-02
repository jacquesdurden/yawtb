function out = cwtsph(img, wavname, scales, angles, varargin)
% \manchap
%
% Compute the spherical wavelet transform
%
% \mansecSyntax
%
% out = wavspheric(img, wavname, scales [,WaveletParameter] )
%
% out = wavspheric(img, wavname, scales [,'WaveletOptionName', 
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
% \item[mat] [DOUBLE MATRIX] : the input matrix in spherical
% coordinates. 
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
% >> load world;
% >> wav = cwtsph(mat,'dog',0.05,0);
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
% $Header: /home/cvs/yawtb/continuous/sphere/cwtsph.m,v 1.17 2005-02-17 10:02:09 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% Handling the input
wavname = lower(wavname);

if (exist([wavname 'sph']) >= 2) 
  wavname = [ wavname 'sph'];
elseif (exist(wavname) < 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 'sph'' doesn''t exist!']);
end
  

if ~exist('varargin')
  varargin = {};
end

%% Keeping the recording of varargin into output for
%% reproducibility
out.extra = varargin;


if (~all(isnumeric(scales))) | (~all(isnumeric(angles))) 
  error('scale(s) and angle(s) must be numeric');
end

%% Determining the wavelet parameters
wavopts      = yawopts(varargin,wavname);

%% Misc initializations
[nth,nph] = size(img);
nsc       = length(scales);
nang      = length(angles);
%%phv       = vect(-pi, pi, nph, 'open');
%%thv       = vect(0, pi, nth);
%%[ph,th]   = meshgrid(phv,thv);

if (rem(nth, 2) == 1)
  [ph, th]  = sphgrid(nth - 1, nph, 'withpoles');
else
  [ph, th]  = sphgrid(nth, nph);
end

dph       = ph(1,2) - ph(1,1);
dth       = th(2,1) - th(1,1); 
thv       = th(:,1);
phv       = ph(1,:);

%% 1D FFT transform of the matrix mat. No, it is'nt an error
fimg         = fft(img,[],2);

%% Spherical coordinates on sphere:
X      = sin(th).*cos(ph); 
Y      = sin(th).*sin(ph);
Z      = cos(th);

%% Wheights for each point according Riemann sum
if (rem(nth, 2) == 1)
  weight = 4*pi* sphweight(nth, nph);
else
  weight = 4*pi* sphweight(nth, nph, 'nopoles');
end

%% True computation of the Spherical CWT

out.data  = zeros(nth,nph,nsc,nang);
tmpout    = zeros(nth,nph);
oyap      = yapbar([],nang*nsc*nth);
for sc = 1:nsc,
  for ang = 1:nang,
    %% Setting the current scale and angle
    csc  = scales(sc);
    cang = angles(ang);
    
    for k = 1:nth,
      %% Deleting/Writing the progress line
      oyap = yapbar(oyap,'++');
      %% Determing the center of the wavelet
      x           = sin(thv(k));
      y           = 0;
      z           = cos(thv(k));
    
      %% Call of the wavelet function through 'eval'.
      mask = feval(wavname, X,Y,Z, x,y,z, csc,cang, wavopts{:});
    
      %% 1D FFT of mask
      fmask = fft(mask,[],2);
      
      %% The kth row of the final result (the spherical wavelet
      %% transform) is equal to the row convolution
      
      tmpout(k,:)  = sum(ifft(fimg .* conj(fmask), [], 2).* weight);
    end
    
    out.data(:,:,sc,ang) = tmpout;
  end
end
oyap = yapbar(oyap,'close');

out.type  = mfilename;
out.wav   = wavname;
out.para  = wavopts(:);
out.sc    = scales;
out.ang   = angles;
out.extra = varargin;


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
