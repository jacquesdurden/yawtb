function mse = yamse(psig, nsig)
% \manchap
%
% Mean square error between signals or images
%
% \mansecSyntax
%
% mse = yamse(psig, nsig)
%
% \mansecDescription
% This function computes the Mean Square Error (MSE) between a
% pure and a noisy signal/image. The formula used is
%
%    $MSE = (1/N) \sum_{i=1}^{N} |psig(i) - nsig(i)|^2$
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
% \item[mse] [REAL SCALAR]: The Mean Square Error
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> pmat = theL(256); yashow(pmat,'square');
% >> nmat = pmat + randn(size(pmat))/5; yashow(nmat,'square');
% >> yamse(pmat, nmat)
% \end{code}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yamse.m,v 1.3 2003-12-22 14:40:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

mse = sum(abs(double(psig(:)) - double(nsig(:))).^2) / length(psig(:));

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
