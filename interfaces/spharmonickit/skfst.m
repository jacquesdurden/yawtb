% \manchap
%
% Fast spherical harmonic transform (Spharmonic Kit Implementation)  
%
% \mansecSyntax
%
% coeffs = shfst(data)
%
% \mansecDescription
%
% This mex file computes a fast spherical harmonic transform of the
% spherical data \libvar{data} defined on a spherical grid 2B*2B
% where B is the frequency bandwidth of the data.
%
% To perform this spherical transform, \libfun{shfst} program
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
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[coeff] [COMPLEX MATRIX]: The spherical harmonic
% coefficients. Those are defined in a matrix of size B*B (with B
% define above). This matrix is formed by the concataining of the
% coefficents C(m,l) ($|m|\leq l$) in the following order:
%   C(0,0) C(0,1) C(0,2)  ...                 ... C(0,B-1)
%          C(1,1) C(1,2)  ...                 ... C(1,B-1)
%          etc.
%                                   C(B-2,B-2)    C(B-2,B-1)
%		                                  C(B-1,B-1)
%			                          C(-(B-1),B-1)
%		                    C(-(B-2),B-2) C(-(B-2),B-1)
%	  etc.
%	          C(-2,2) ...                 ... C(-2,B-1)
%	  C(-1,1) C(-1,2) ...                 ... C(-1,B-1)
%    
%   This only requires an array of size (B*B).  Use lmshape to turn
%   this representation in a more human readable form. ilmshape may
%   next come back to the original representation. 
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [phi,theta] = sphgrid(2*128);
% >> mat = exp(-tan(theta/2).^2) .* ( phi == phi(1,10));
% >> fmat = shfst(mat);
% >> figure; yashow(fmat);
% >> figure; yashow(lmshape(fmat));
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
% fzt shifst convsph lmshape ilmshape 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/interfaces/spharmonickit/skfst.m,v 1.1 2007-10-09 07:40:13 jacques Exp $
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
