function out = cwt1d(fsig, wavname, scales, varargin)
% \manchap
%
% 1D continuous wavelet transform
%
% \mansecSyntax
%
% out = cwt1d(fsig, wavname, scales [,WaveletParameter]...
%             [,'Norm',NormValue] [,'export'])
%
% out = cwt1d(fsig, wavname, scales [,'WaveletOptionName',
%             WaveletOptionValue]... [,'Norm',NormValue] 
%             ['sampling', sampling] [,'export'])
%
% \mansecDescription 
%
% \libfun{cwt1d} computes and returns the 1D continuous wavelet transform of
% a signal.  The wavelet may be chosen among the ones defined in the
% subdirectory 'wave\_defs' (see the 'README' file to write your own
% wavelet).
%
% \mansubsecInputData
%
% \begin{description}
% \item[fsig] [CPLX VECTOR]: the Fourier transform of the input signal;
%
% \item[wavname] [STRING]: the name of the wavelet; 
%
% \item[scales] [REAL VECTOR]: the scales of the transform;
%
% \item[WaveletParameter] [MISC]: one wavelet parameter. Its type
% depends on the wavelet.  Refer to the corresponding M-file
% (inside 'wave\_defs') for a description of the available parameters;
%
% \item[WaveletOptionName, WaveletOptionValue] [STRING, MISC]:
% Another way of writing wavelet parameters. The wavelet parameter
% name (a string) is followed by its value. See the corresponding
% wavelet M-file (inside 'wave\_defs') for a description of the
% parameter, or just type the name of the wavelet with '[]' as
% argument on the Matlab command line;
%
% \item[NormValue] ['l1'|'l2']: normalization of the wavelet transform,
% namely $L^1$ or $L^2$. The default is $L^2$.
%
% \item[sampling] [REAL]: the sampling frequency of the original
% signal, e.g. 50 Hz.
%
% \item['export'] [BOOL]: if mentioned, this options force cwt1d to
% return only the wavelet coefficients directly in out. These are
% normally present in out.data
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX|STRUCT]: If 'export' option is not set, the
% output of the transform. It is a structure
%   with the following fields:
%   \begin{itemize}
%       \item \libvar{out.data} [MATRIX] : wavelet coefficients
%       \item \libvar{out.type} [STRING] : transform type ('cwt1d')
%       \item \libvar{out.wav} [STRING] : name of the wavelet
%       \item \libvar{out.para} [MATRIX] : extra parameters given to cwt1d
%       \item \libvar{out.sc}  [VECTOR]: scales of the wavelet transform
%       \item \libvar{out.fsig} [VECTOR]: Fourier transform of the 
%          input signal
%   \end{itemize}
% If 'export' is set, \libvar{out} is a matrix corresponding a \libvar{out.data}.
% \end{description}
%
% \mansecExample
%
% \begin{code}
% >> t    = 1:1024;
% >> sig  = sin(2*pi*t/30./(1+t/1000)); 
% >> fsig = fft(sig);
% >> s = 20:140;
% >> wsig = cwt1d(fsig, 'morlet', s);
% >> yashow(wsig);
% \end{code}
% returns the 1D Morlet wavelet transform of a chirp signal for scales
% between 20 and 140.  The implicit values are the Morlet wavelet parameters:
% \libvar{k0}=6; \libvar{sigma}=1.  For other values, type something
% like
% \begin{code}
% >> wsig  = cwt1d(fsig, 'morlet', s, 7, 2);
% \end{code}
% or,
% \begin{code}
% >> wsig  = cwt1d(fsig, 'morlet', s, 'k_0', 7 , 'sigma', 2);
% \end{code}
% It changes the values of \libvar{k0} and \libvar{sigma} respectively to 7
% and 2.  Note that the first example is order dependant and not the second.
%
% Finally, we change to a $L^1$ normalization of the cwt with the
% following command:
% \begin{code}
% >> wsig  = cwt1d(fsig, 'morlet', s, 'k_0', 7 , 'sigma', 2, ...
%                  'norm','l1');
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/1d/cwt.* ^continuous/1d/wave_defs/.* /cgt1d$ /yashow$
%
% \mansecLicense
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"}
%
% $Header: /home/cvs/yawtb/continuous/1d/cwt1d.m,v 1.39 2004-05-17 13:28:57 ljacques Exp $
%
% Copyright (C) 2002, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% Managing of the input
if (nargin < 3 | nargout > 1)
  error('Argument Mismatch - Check Command Line');
end

if isnumeric(wavname)
  error('''wavname'' must be a string');
end

%% The wavelet matlab function must exist (in lower case) in the
%% wave_defs subdir.
%% Note tha the real name can be wavename or [wavname '1d'] to
%% avoid eventuel confusion with 2D wavelets. This case is checked
%% first, before the existence of wavname alone.
wavname = lower(wavname);

if (exist([wavname '1d']) == 2) 
  wavname = [ wavname '1d'];
elseif (exist(wavname) ~= 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 '1d'' doesn''t exist!']);
end

if ~exist('varargin')
  varargin = {};
end

%% Keeping the recording of varargin into output for
%% reproducibility
out.extra = varargin;

if (~all(isnumeric(scales)))
  error('scales must be numeric');
end

if (isempty(fsig)) fsig = 0; end

%% Choice of the normalization ('getopts' is part of yawtb: see
%% utils directory)
[NormChoice,varargin] = getopts(varargin,'norm','l2');
switch lower(NormChoice)
 case 'l1'
  norm = 0;
 case 'l2'
  norm = 0.5;
 otherwise
  yahelp cwt1d usage
  error('Unrecognized norm');
end

%% Creation of the frequency line 
nfreq = length(fsig);
sfreq = scales(:) * yapuls(nfreq);

%% Determining the wavelet parameters
%% With names contained in varargin
wavopts    = yawopts(varargin,wavname);

%% Call of the wavelet function through 'eval'
mask       = feval(wavname, sfreq, wavopts{:});
out.data   = diag(sign(scales) .* abs(scales).^norm) ...
    * ifft( meshgrid(fsig,scales) .*  conj(mask),[],2);

if (getopts(varargin,'export',[],1))
  out = out.data;
else
  out.type   = mfilename;
  out.wav    = wavname;
  out.para   = [ wavopts{:} ];
  out.sc     = scales;  
  out.fsig   = fsig;
  out.sampling = getopts(varargin,'sampling',1);
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
