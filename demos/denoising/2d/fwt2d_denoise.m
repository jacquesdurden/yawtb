function out = fwt2d_denoise(varargin)
% \manchap
%
% Image denoising by 2D directional framed wavelet thresholding
%
% \mansecSyntax
%
% obj = fwt2d\_denoise( tI, framename, J, K, ...
%              [,'sigma', sigma] [, 'level', level] 
%              [, 'soft'] ...
%              [, 'hlevel', hlevel], ...
%              [, 'scbase', scbase] [, 'scfirst', scfirst] ...
%              [, 'sc', sc ], [, 'ang', ang ] ...
%              [, 'FrameOptionName', FrameOptionValue] )
%
% \mansecDescription
%
% Denoise an image using thresholding of the coefficient of a
% directional frame before the rebuilding. Hard (default) and soft
% thresholding are available.
% 
% \mansubsecInputData
% \begin{description}
% \item[tI] [CPLX ARRAY]: the Fourier transform of the image to
% analyze;
%
% \item[framename] [STRING]: the name of the frame to use. See the
% subdirectory in yawtb/discrete/2d/frame\_defs to see what are the
% frames availables;
%
% \item[J] [INTEGER]: the number of scales on which the frame is
% based;
%
% \item[K] [INTEGER]: in case of a directional frame, the
% number of sectors to use. 
%
% \item[sigma] [REAL]: the std. dev. of the noise in the noisy
% image. If unknown, an estimation of the noise is computed using \libfun{estimnoise2d}.
%
% \item[level] [REAL]: the level of thresholding to
% perform. Default value: $\sqrt(2*log(n))$ with $n$ the number if
% pixels in the image;
%
% \item['soft'] [BOOL]: perform a soft thresholding instead of the
% default hard thresholding.
%
% \item[hlevel] [REAL]: Threshold of the high frequency coefficient of the
% frame;
%
% \item[scbase] [REAL]: the base 'p' in the power law rule that
% governs the scales, i.e. $a_j = a_0 * p^(j-1)$;
%
% \item[scfirst] [REAL]: the first scale $a_0$ in the scale rule
% above. By default, this $a_0$ is set to 1/2 giving a complete
% covering of the frequency plane if the wavelet is contained in
% the ring -pi/2 <= abs(k) < pi;
%
% \item[sc] [VECTOR]: vector of scale indices between 1 and 'J'
% in which the decomposition must be restricted;
%
% \item[ang] [VECTOR]: vector of angle indices between 1 and 'K'
% in which the decomposition must be restricted;
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [CPLX MATRIX]: The denoised image.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% Denoising of Lena (256x256 256 gray levels)
% >> load lena256
% >> %% Adding noise (PSNR ~20 dB)
% >> nX = double(X) + 255/10*randn(256,256); yapsnr(X,nX)
% >> %% Denoising using the Wickerhauser frame, 4 scale level and 8 orientations
% >> rX = fwt2d_denoise(fft2(nX), 'cmw', 4, 8, 'sigma', 255/10);
% >> %% The gain
% >> yapsnr(X,rX)
% >> %% The results
% >> figure;yashow(X,'cmap','gray'); %% The pure image
% >> figure;yashow(nX,'cmap','gray'); %% The noisy image
% >> figure;yashow(rX,'cmap','gray'); %% The rebuilt image (from noisy)
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
% $Header: /home/cvs/yawtb/demos/denoising/2d/fwt2d_denoise.m,v 1.6 2004-11-05 09:06:32 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Initializations of the frame
obj = fwt2d_init(varargin{:});
[nrow, ncol] = size(obj.tI);

%% Initializing the progress bar
oyap = yapbar([], obj.nsc*obj.K + 2 + obj.K);

%% Computing the mask used in the reconstruction
obj = fwt2d_allwav(obj);
oyap = yapbar(oyap, '++');

%% Thresholding information
if (getopts(varargin,'soft',[],1))
  thresh_method = 'yasthresh';
else
  thresh_method = 'yathresh';
end

%% Standard deviation of noise (estimated if not given)
sigma  = getopts(varargin, 'sigma', []);

if (isempty(sigma))
  sigma = estimnoise2d(obj.tI);
  fprintf('Standard deviation of noise estimated to sigma=%f\n', sigma);
end

%% Level of thresholding (Donoho's VisuShrink if not given)
tlevel = getopts(varargin, 'level', []);

if (isempty(tlevel))
  %tlevel = sqrt(2*log(nrow*ncol))/2;
  tlevel = 2;
  %fprintf('Using the VisuShrink level equals to %f\n', tlevel);
end

%% Possible correction of high frequency thresholding
htlevel = getopts(varargin, 'hlevel', tlevel);


%% Computing and rebulding the approximation coefficients without thresholding
obj = fwt2d_app(obj, 'temp');
out = ifwt2d_app(obj, 'temp');
oyap = yapbar(oyap, '++');

%% Computing and rebuilding the residual coefficients
for th = 1:obj.K,
  obj = fwt2d_high(obj, th, 'temp');
  thresh = sigma * htlevel * obj.high_norm(th);
  %fprintf('High frequency threshold: %f\n',thresh);
  obj.temp = feval(thresh_method, obj.temp, thresh, 'absolute', varargin{:});
  out = out + ifwt2d_high(obj, th, 'temp');
  oyap = yapbar(oyap, '++');
end

%% Computing and rebuilding the wavelet coefficients
for s = 1:obj.nsc,
  for th = 1:obj.K,
    obj = fwt2d_wav(obj, s, th, 'temp');
    thresh = sigma * tlevel * obj.wav_norm(s,th);
    %fprintf('High frequency threshold: %f\n',thresh);
    obj.temp = feval(thresh_method, obj.temp, thresh, 'absolute', varargin{:});
    out = out + ifwt2d_wav(obj, s, th, 'temp');
    oyap = yapbar(oyap, '++');
  end
end

%% Closing the progress bar
oyap = yapbar(oyap, 'close');

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
