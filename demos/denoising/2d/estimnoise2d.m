function sigma = estimnoise2d(tmat, varargin)
% \manchap
%
% Estimate the std. dev. of a white noise in an image.
% 
% \mansecSyntax
%
% sigma = estimnoise(tmat [, 'cutoff'])
%
% \mansecDescription
%
% Estimate the standard devation of a white noise in an image using
% a median filter and the Mexican Hat.
%
% \mansubsecInputData
% \begin{description}
% \item[tmat] [MATRIX]: the FFT of the noisy image.
%
% \item[cutoff] [REAL]: the cutoff in frequency below which the
% filter is zero.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[sigma] [REAL]: estimation of the standard deviation of the noise.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% Loading a simple disk image
% >> X = thedisk(128, 'smooth');
% >> figure; yashow(X,'cmap','rgray');
% >> %% Creating the noisy image (sigma = 0.5)
% >> [nrow,ncol]=size(X); 
% >> nX = X + 0.5 *randn(nrow,ncol);
% >> figure; yashow(nX,'cmap','rgray');
% >> %% Estimating sigma
% >> sigma = estimnoise2d(fft2(nX))
% \end{code}
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
% $Header: /home/cvs/yawtb/demos/denoising/2d/estimnoise2d.m,v 1.3 2003-09-18 13:53:02 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

[nrow, ncol] = size(tmat);
[kx,ky] = yapuls2(ncol, nrow);

cutoff = getopts(varargin, 'cutoff', 3*pi/4);
psi = abs(kx + i*ky) > cutoff;
norm_psi = (sum(psi(:)) / (nrow*ncol))^.5;

wav = abs(real(ifft2( tmat .* psi)));

sigma = median(wav(:)) / (0.6745 * norm_psi);


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
