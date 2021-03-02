% \manchap
%
% S2kit fast inverse spherical harmonic transform
%
% \mansecSyntax
%
% data = ifst(coeffs)
%
% \mansecDescription
%
% This mex file computes a fast inverse spherical harmonic
% transform of the spherical coefficients \libvar{coeffs} defined
% on a grid B*B where B is the frequency bandwidth of the data.
% Be carreful to either use the output of \libfun{s2fst} for these
% coefficients, or to form them by using \libfun{ilmshape}.
%
% To perform this spherical convolution, \libfun{s2ifst} program
% uses the C functions of the (GPL) S2kit [1] based on the
% work of Driscoll, Healy and Rockmore [2] about fast spherical
% transforms.
%
% \mansubsecInputData
% \begin{description}
% \item[coeff] [COMPLEX MATRIX]: The spherical harmonic
% coefficients. Those are defined in a matrix of size B*B (with B
% the spherical bandwidth such that the parameter l<=B). This
% matrix is formed by the concataining of the coefficents C(m,l)
% ($|m|\leq l$) in the following order:
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
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[data] [REAL MATRIX]: The spherical data described on a
% equi-angular (2B*2B) spherical grid 
%              $(\theta_i,\phi_j)$ 
% with $\phi_j=j\frac{2\pi}{2B}$ ($j=0..2B-1$) and
% $\theta_i=(2i+1)\frac{\pi}{2B}$ ($i=0..2B-1$).
%
% Notice that, contrary to \libfun{ifst} $B$ HASN'T to be a power of 2. 
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world2; yashow(mat, 'spheric', 'fig', 10); colorbar; %% 256x256 array
% >> nmat = s2ifst(s2fst(double(mat)));
% >> yashow(nmat, 'spheric', 'fig', 11); colorbar;
% >> %% Gibs-like oscillating are due to the frequency cutoff at bandwith 128
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
% s2fst lmshape ilmshape 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/interfaces/s2kit/s2ifst.m,v 1.1 2004-09-22 15:33:43 ljacques Exp $
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
