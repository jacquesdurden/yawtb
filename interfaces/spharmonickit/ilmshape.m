function [out] = ilmshape(in)
% \manchap
%
% Reshape the output of skfst in a l-m-readable matrix
%
% \mansecSyntax
%
% [coeffs] = ilmshape(lmcoeffs)
%
% \mansecDescription
%
% Reshape the (2B-1)*B matrix output of lmshape ins the B*B matrix
% format used by the fast forward and inverse spherical transform
% \libfun{skfst} and \libfun{skifst}.
%
% \mansubsecInputData
% \begin{description}
% \item[lmcoeffs] [COMPLEX MATRIX]: matrix of size (2*B-1)*B
% in which the coefficient C(m,l) are organized as follow
%   C(0,0) C(0,1) C(0,2)  ...                 ... C(0,B-1)
%   0      C(1,1) C(1,2)  ...                 ... C(1,B-1)
%   ...           ...                         ... C(.,B-1)    
%   0      ...                  0   C(B-2,B-2)    C(B-2,B-1)
%   0 	   ...                      0             C(B-1,B-1)
%   0   		            0             C(-(B-1),B-1)
%   0		                0   C(-(B-2),B-2) C(-(B-2),B-1)
%   ...           ...                         ... C(-.,B-1) 	
%   0     0       C(-2,2) ...                 ... C(-2,B-1)
%   0	  C(-1,1) C(-1,2) ...                 ... C(-1,B-1)
% which is more readable when visualize through yashow(lmcoeff) for
% instance.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[coeffs] [COMPLEX MATRIX]: The spherical harmonic
% coefficients format used by \libfun{skfst} and \libfun{skifst}. Those
% are defined in a matrix of size B*B (with B define above). This
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
% This only requires an array of size (B*B) but is very difficult
% to read. 
% So, \libfun{ilmshape} remove just the zeros padding the lmcoeffs
% representation. 
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% Determines the spatial shape of C(l,m)=(l<10)
% >> l = 0:127;
% >> fmat = [l<10; zeros(2*128-2,128)]; size(fmat)
% >> mat = skifst(ilmshape(double(fmat)));
% >> figure; yashow(mat,'spheric','fig',1,'relief','mode','real','cmap','jet'); colorbar
% \end{code}
%
% \mansecSeeAlso
% skfst skifst fzt convsph ilmshape
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/interfaces/spharmonickit/ilmshape.m,v 1.4 2007-10-09 07:40:13 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

L = size(in,2);

if (size(in,1) ~= (2*L -1))
  yahelp ilmshape usage
  error('''lmcoeffs'' are not of size (2*B-1)*B.');
end

in_up = (in(1:L,:)).';
in_do = in((L+1):end,:).';

[pos_i, pos_j] = meshgrid(1:L);
pos_up = find(pos_i<=pos_j);
vin_up = in_up(pos_up);

[pos_i, pos_j] = meshgrid(1:L,1:(L-1));
pos_do = find((pos_i>(L-pos_j)).');
vin_do = in_do(pos_do);

out = reshape([vin_up; vin_do],L,L).';

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
