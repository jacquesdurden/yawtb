function out = cwt1dt(fsig, wavname, scales, velos, varargin)
% \manchap
%
% 1D+T continuous wavelet transform
%
% \mansecSyntax
% out = cwt1dt( fsig, wavname, scales, velos [,WaveletParameter] ...
%               [,'Time',TimeValue] ) 
%
% out = cwt1dt( fsig, wavname, scales, velos [,'WaveletOptionName', ...
%               WaveletOptionValue][,'Time',TimeValue] )
%
% \mansecDescription
%
% \libfun{cwt1dt} computes and returns the 1D + T continuous wavelet
% transform of a 1D+T signal.  The wavelet may be chosen among the one
% defined in subdirectory 'wave\_defs' (see the README to write your own
% wavelet)
%
% \mansubsecInputData
%
% \begin{description}
% \item[fsig] [CPLX MATRIX]: the 2D Fourier transform of the 1D+T
% signal \libvar{sig} computed with fft2.  
%
% Be Careful: The time index of \libvar{sig} varies along the first
% dimension (columnwise/vertically), and spatial index is along the second
% dimension (rowise/horizontally). 
%
% \item[wavname] [STRING]: the name of the wavelet
%
% \item[scales, velos] [VECTOR]: the scales and the velocities of the
%    transform
%
% \item[WaveletParameter] [MISC]: one wavelet parameter. Its type
% depends on the wavelet. Refer to the corresponding M-file
% (inside 'wave\_defs') for a description of the available parameters;
%
% \item[WaveletOptionName, WaveletOptionValue] [STRING, MISC]:
% Another way of writing wavelet parameters.  The wavelet parameter
% name (a string) is followed by its value. See the corresponding
% wavelet M-file (inside wave\_defs) for a description of the
% parameter, or just type the name of the wavelet with '[]' as argument
% on the Matlab command line.
%
% \item[TimeValue] [INTEGER]: The wavelet transform is only computed for
% this Time i.e. frame number 
%
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item{out} [STRUCT]: the output of the transform. A structured
%   data with the following fields:
%   \begin{itemize}
%   \item \libvar{out.data} [3D or 4D MATRIX]: wavelet coefficients
%   \item \libvar{out.type} [STRING] : transform type ('cwt1dt')
%   \item \libvar{out.wav} [STRING] : name of the wavelet
%   \item \libvar{out.para} [MATRIX] : extra parameters given to 
%      \libfun{cwt1dt}
%   \item \libvar{out.sc} [REAL VECTOR] : scales of the wavelet transform
%   \item \libvar{out.vel} [REAL VECTOR] : velocity
%   \item \libvar{out.ftime} [VECTOR] : this field exists only if the
%     optional argument 'Time' is specified.  Then it is equal to the
%     \libvar{TimeValue}$^{th}$ frame of the signal in the time domain.
%   \end{itemize}
% \end{description}
%
% \mansecExample
% \begin{code}
% %% load the 3 moving Gaussians sample.
% >> mat = movgauss; 
%
% %% Computes the CWT1DT of this signal.
% >> wav = cwt1dt(fft2(mat),'morlet',4,vect(-2,2,128),'Time',10);
%
% %% Display at time 10 the velocity-position representation of the CWT.
% >> yashow(wav);
% \end{code}
%
%
% \mansecReference
% [1]: "Spatio-Temporal Wavelet Transform for Motion Tracking", 
% J.-P. Leduc, F. Mujica, R. Murenzi, and M. J. T. Smith, 
% presented in ICASP'97, Munich, Germany, Apr. 1997
%
% \mansecSeeAlso
%
% ^continuous/1dt/.*  /yashow$ movgauss
%
% \mansecLicense
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"}
%
% $Header: /home/cvs/yawtb/continuous/1dt/cwt1dt.m,v 1.20 2002-11-21 10:21:16 ljacques Exp $
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
%% Note that the real name can be wavename or [wavname '1dt'] to
%% avoid eventuel confusion with 1D wavelets. This case is checked
%% first, before the existence of 'wavname' alone.
wavname = lower(wavname);

if (exist([wavname '1dt']) >= 2) 
  wavname = [ wavname '1dt'];
  
elseif (exist([wavname '2d']) >= 2) %% Of course, 2D Wavelet can be
                                    %% used also for 1DT. This only
                                    %% done when the 1dt suffix
                                    %% doesn't exist.
  wavname = [ wavname '2d'];
  disp(['Wavelet ''', wavname, ''' will be used.']);
  
elseif (exist(wavname) < 2)
  error(['The wavelet ''', wavname, ''', ''', wavname, ...
	 '1dt'', or ''', wavname, '2d'' doesn''t exist!']);
end

%% In the case of the use of a two dimensional wavelet,
%% wave-number/frequency domain must be rotated by 45° (assuming 2d
%% wavelet en X or Y axis)
twodim = ~isempty(yastrfind(wavname,'2d'));

if ~exist('varargin')
  varargin = {};
end

%% Keeping varargin into output for reproductibility
out.extra = varargin;

%% Input handling
if (~all(isnumeric(scales))) | (~all(isnumeric(velos))) 
  error('scale(s) and velocity(ies) must be numeric');
end

if (isempty(fsig)) fsig = 0; end

%% Determining the wavelet parameters
wavopts    = yawopts(varargin,wavname);

%% Determining if we look a fixed time
[fixtime,varargin] = getopts(varargin,'time',[]);

%% Creation of the wave-number/frequency domain 
[Hgth,Wdth] = size(fsig);
[k,w]       = meshgrid( yapuls(Wdth), yapuls(Hgth) );

nsc         = length(scales);
nvel        = length(velos);

if ~isempty(fixtime)
  out.data    = zeros(1,Wdth,nsc,nvel);
else
  out.data    = zeros(Hgth,Wdth,nsc,nvel);
end

oyap = yapbar([], nsc*nvel);

for sc = 1:nsc,
  for vel = 1:nvel,
    oyap = yapbar(oyap, '++');
    
    csc   = scales(sc);
    cvel  = velos(vel);
    if (cvel == 0)
      cvel = NaN;
    end
    ncvel = abs(cvel)^0.5;
    
    nk = csc * k * ncvel; 
    nw = csc * w / ncvel * sign(cvel);
    
    if (twodim) %% With 2D wavelet, a 45° rotation is needed 
		%% to place wavelet on a "velocity" 1 pixel/frame
		%% assuming it originally placed on X or Y axis.
      nk = (nk - nw)/2^0.5;
      nw = nk + 2^0.5*nw;
    end

    %% Call of the wavelet function through 'eval'.
    mask = eval([ wavname '(nk,nw, wavopts{:})']);

    if ~isempty(fixtime)
      tmp = csc * ifft2(fsig .* conj(mask));
      out.data(1,:,sc,vel) = tmp(fixtime,:);
    else
      out.data(:,:,sc,vel) = csc * ifft2(fsig .* conj(mask));
    end
  end
end
oyap = yapbar(oyap, 'close');

out.type  = mfilename;
out.wav   = wavname;
out.para  = [ wavopts{:} ]; 
out.sc    = scales;
out.vel   = velos;

if (fixtime)
  tmp = real(ifft2(fsig));
  out.ftime = tmp(fixtime,:);
end

%% out.extra is already recorded (see top)

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
