function psnr = yapsnr(psig, nsig, varargin)
% \manchap
%
% Peak Signal to Noise Ratio of signals or images
%
% \mansecSyntax
%
% psnr = yapsnr(psig, nsig [, 'peak', peakval ])
%
% \mansecDescription
% This function computes the Peak Signal to Noise Ratio (PSNR) between a
% pure and a noisy signal/image. The formula used is
%
%    $PSNR = 10 log10 ( M_psig^2 / MSE )$
%
% where $M_psig$ is the maximum absolute value of psig, and MSE
% is the Root Mean Square Error given by the square root of 
%
%    $MSE =  Sum_n (psig(n) - nsig(n))^2 / N$\\
% for vectors, and by the square root of 
%
%    $MSE =  Sum_n Sum_m (psig(n,m) - nsig(n,m))^2 / (N*M)$\\
%
% for matrices.
%
% Notice that if 'psig' is of uint8 data type, $M_psig$ is
% automatically set to 255.
%
% \mansubsecInputData
% \begin{description}
% \item[psig] [REAL VECTOR|REAL MATRIX]: real vector or real matrix
% giving the base signal, generally the signal without noise
% \item[nsig] [REAL VECTOR|REAL MATRIX]: real vector or real matrix
% giving the noisy signal.
% \item[peakval] [REAL SCALAR]: peak value to use in the PSNR computation  
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[psnr] [REAL SCALAR]: The Peak Signal to Noise ratio.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> pmat = theL(256); yashow(pmat,'square');
% >> nmat = pmat + randn(size(pmat))/5; yashow(nmat,'square');
% >> yapsnr(pmat, nmat)
% \end{code}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yapsnr.m,v 1.5 2007-12-03 09:38:45 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

dpsig = double(psig(:));
dnsig = double(nsig(:));

if (strcmp(class(psig),'uint8')) 
  psnr = 10*log10( 255^2 / mse(dpsig, dnsig) );
else
  peakval = getopts(varargin, 'peak',  max(abs(dpsig)));
  psnr = 10*log10( peakval^2 / mse(dpsig, dnsig) );
end

%% Compute the mean square error between psig and sig
function res = mse(psig,nsig)
N = length(psig);
res = sum(abs(psig - nsig).^2) / N ;

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
