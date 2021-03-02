% \manchap
%
% Fast spherical convolution
%
% \mansecSyntax
%
% out = convsph(data, filter)
%
% \mansecDescription
%
% This mex file computes a fast spherical convolution of spherical
% data \libvar{data} with the zonal filter \libvar{filter} using
% the classical spherical convolution theorem 
%
%     $\hat{c}(l,m)=\frac{4\pi}{2l+1}\hat{f}(l,m)\hat{h}(l,0)$
%
% with $\hat{c}$ the spherical transform of $c=f\star h$, $\hat{f}$
% and $\hat{h}$ the spherical transform respectively of $f$ (the
% data) and $h$ (the zonal filter).
%
% To perform this spherical convolution, \libfun{convsph} program
% uses the C functions of the (GPL) SpharmonicKit [1] based on the
% work of Driscoll, Healy and Rockmore [2] about fast spherical
% transforms.
%
% \mansubsecInputData
% \begin{description}
% \item[data] [REAL MATRIX]: The spherical data described on a
% equi-angular (2B*2B) spherical grid 
%              $(\theta_i,\phi_j)$ 
% with $\phi_j=j\frac{2\pi}{2B}$ ($j=0..2B-1$) and
% $\theta_i=(2i+1)\frac{\pi}{2B}$ ($i=0..2B-1$).
%
% Notice that $B$ must be a power of 2. 
%
% \item[filter] [REAL MATRIX]: the zonal filter, that is invariant
% under rotations around the North pole, defined on the same 2B*2B
% spherical equi-angular grid.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: the convolution defined on the same
% spherical equi-angular grid
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world2; figure; yashow(mat, 'spheric');
% >> [phi,theta] = sphgrid(size(mat,1));
% >> filter = exp(-(tan(theta/2)/0.05).^2);
% >> out = convsph(double(mat), filter);
% >> figure; yashow(out, 'spheric', 'mode','real'); colorbar;
% \end{code}
%
% \mansecReference
%
% [1] SpharmonicKit: http://www.cs.dartmouth.edu/~geelong/sphere/. 
% Developed by Sean Moore, Dennis Healy, Dan Rockmore, Peter
% Kostelec.
%
% [2] D. Healy Jr., D. Rockmore, P. Kostelec and S. Moore, 
% "FFTs for the 2-Sphere - Improvements and Variations", 
% Journal of Fourier Analysis and Applications, 9:4 (2003), 
% pp. 341 - 385. 
%
% \mansecSeeAlso
%
% fst fzt ifst lmshape ilmshape 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/interfaces/spharmonickit/convsph.m,v 1.1 2003-11-07 11:06:41 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)




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
