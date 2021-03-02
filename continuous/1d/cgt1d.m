function out = cgt1d(fsig, freqs, varargin)
% \manchap
%
% 1D continuous Gabor transform 
%
% \mansecSyntax
%
% out = cgt1d(fsig, freqs [,'Sigma', sigma]
%               [, 'SampFreq', sampfreq]...
%		[, 'Window', winname ...
% 			[,WindowParameter] ] )
%
% out = cgt1d(fsig, freqs [,'Sigma', sigma] ...
%               [, 'SampFreq', sampfreq]...
%		[, 'Window', winname ...
% 			['WindowOptionName', WindowOptionValue] ] )
%
% \mansecDescription
%
% \libfun{cgt1d} computes the Continuous Gabor Transform (or
% Windowed Fourier Transform) of a signal.
% The window used is the Gaussian window but this can be modified
% with the option 'Window' followed by the name of the desired window.
% This one must correspond to a mfile defined in the subdirectory 
% 'win\_defs'.
%
% \mansubsecInputData
% \begin{description}
% \item[fsig] [CPLX VECTOR]: the Fourier transform of the input
% signal;
% 
% \item[freqs] [REAL VECTOR]: the frequencies of the transform;
% 
% \item[sampfreq] [REAL]: the sampling frequency of the signal in Hz;
%
% \item[sigma] [REAL]: the size of the window;
%
% \item[winame] [STRING]: the name of the window to use if the
% gaussian is not wanted.
%
% \item[WindowParameter] [MISC]: one window parameter. Its type
% depends on the window.  Refer to the corresponding M-file
% (inside 'win\_defs') for a description of the available
% parameters;
%
% \item[WindowOptionName, WindowOptionValue] [STRING, MISC]:
% Another way of writing window parameters. The window parameter
% name (a string) is followed by its value. 
% See the corresponding window M-file (inside 'win\_defs') 
% for a description of the parameter or just type the name of the
% window with [] as argument on the Matlab command line;
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRUCT]: the output of the transform. It is a structure
%   with the following fields:
%   \begin{itemize}
%       \item \libvar{out.data} [MATRIX] : the Gabor coefficients
%       \item \libvar{out.type} (the type of the gabor transform)
%       \item \libvar{out.win} [STRING] : the window name
%       \item \libvar{out.para} [STRUCT] : the extra parameters given to cgt1d
%       \item \libvar{out.freqs} [VECTOR]: the frequencies
%       \item \libvar{out.fsig} [VECTOR]: the Fourier transform of the 
%          input signal
%   \end{itemize}
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> load superpos
% >> fsig = fft(sig);
% >> freqs = 0.005: (0.12 - 0.005)/127: 0.12;
% >> wsig = cgt1d(fsig, freqs, 'sigma', 50);
% >> yashow(wsig);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/1d/cgt.* ^continuous/1d/win_defs/.* /cwt1d$ /yashow$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1d/cgt1d.m,v 1.7 2007-03-21 01:09:14 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Managing of the input
if (nargin < 2 | nargout > 1)
  error('Argument Mismatch - Check Command Line');
end

%% Determining the window of the CGT

[winname,varargin] = getopts(varargin, 'window', 'gauss');
winname = lower(winname);

%% Checking if the window exist
if (exist([winname '1d']) == 2) 
  winname = [ winname '1d'];
elseif (exist(winname) ~= 2)
  error(['The window ''' winname ''' or ''' winname ...
	 '1d'' doesn''t exist!']);
end

%% Sampling frequency
sampfreq = getopts(varargin, 'SampFreq', 1);


%% Keeping the recording of varargin into output for
%% reproducibility
if ~exist('varargin')
  varargin = {};
end

out.extra = varargin;

%% Checking frequencies
if (~all(isnumeric(freqs)))
  error('frequencies must be numeric');
end

%% Variable initializations
nfreqs   = length(freqs);
nsamples = length(fsig);

%% Creating the Fourier frequency line
w = yapuls(nsamples)*sampfreq;
w_deloc = kron(w,ones(nfreqs,1)) - 2*pi*freqs(:)*ones(1,nsamples);

%% Determining the window parameters
%% with names contained in varargin
winopts = yawopts(varargin,winname);

%% Computing the mask, that is, all the possible position
%% of the window in frequency
mask = eval([ winname '(w_deloc,winopts{:})']);
out.data = ifft( kron(fsig,ones(nfreqs,1)) .* conj(mask), [], 2);

out.type   = mfilename;
out.win    = winname;
out.para   = [ winopts{:} ];
out.freqs  = freqs;  
out.fsig   = fsig;
out.sampfreq = sampfreq;

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
