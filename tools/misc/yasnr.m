function snr = yasnr(psig, nsig)
% \manchap
%
% Signal to Noise Ratio of signals or images
%
% \mansecSyntax
%
% snr = yasnr(psig, nsig)
%
% \mansecDescription
% This function computes the Signal to Noise Ratio (SNR) between a
% pure and a noisy signal/image. The formula used is
%
%    $SNR = 20 log10 ( std_psig / std_nsig )$
%
% where $std_v$ is the standart deviation of v given by
%
%   $std_v^2 = 1/N sum_n (v[n] - mean_v)^2$\\
%   $mean_v  = 1/N sum_n v[n]$\\
%
% if v is a vector and by
%
%   $std_ps^2 = 1/N^2 sum_n sum_m (psig[n,m] - mean_ps)^2$\\
%   $mean_v   = 1/N^2 sum_n sum_m v[n,m]$\\
%
% if v is a matrix.
%
% \mansubsecInputData
% \begin{description}
% \item[psig] [REAL VECTOR|REAL MATRIX]: real vector or real matrix
% giving the base signal, generally the signal without noise
% \item[nsig] [REAL VECTOR|REAL MATRIX]: real vector or real matrix
% giving the noisy signal.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[snr] [REAL SCALAR]: The Signal to Noise ratio.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> pmat = theL(256); yashow(pmat,'square');
% >> nmat = pmat + randn(size(pmat))/5; yashow(nmat,'square');
% >> yasnr(pmat, nmat)
% \end{code}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yasnr.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

snr = 20*log10(std2(psig) / std2(psig - nsig));

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
