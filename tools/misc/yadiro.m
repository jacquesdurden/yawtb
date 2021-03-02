function [nX,nY] = yadiro(X,Y,sc,ang,varargin)
% \manchap
%
% Dilation and rotation on grids of positions
%
% \mansecSyntax
%
% [nX, nY] = yadiro(X,Y,sc,ang [,'freq'])
%
% \mansecDescription
%
% \libfun{yadiro} performs a dilation of 'sc' and a rotation of
% 'ang' on two grids 'X' and 'Y' build by meshgrid. 
% So,     
% 	$nX = sc^-1 * (  cos(ang)*X - sin(ang)*Y )$\\
%	$nY = sc^-1 * (  sin(ang)*X + cos(ang)*Y )$\\
%
% This functions is used in almost all the 2D transforms of the
% yawtb.
%
%
% \mansubsecInputData
% \begin{description}
% \item[X] [REAL MATRIX]: the matrix of 'x' (horizontal) positions;
%
% \item[Y] [REAL MATRIX]: the matrix of 'y' (vertical) positions;
% 
% \item[sc] [REAL SCALAR]: the scale of dilation (must be
% positive);
%
% \item[ang] [REAL SCALAR]: the angle of the rotation in radian;
%
% \item['freq'] [BOOLEAN]: inverse the dilation to correspond to
% its frequency action.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[nX] [REAL ARRAY]: the dilated and rotated horizontal
% positions;
%
% \item[nY] [REAL ARRAY]: the dilated and rotated vertical
% positions;
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [x,y] = meshgrid(vect(-1,1,3), vect(-1,1,3))
% >> [nx,ny] = yadiro(x,y,2,pi/2) 
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
% meshgrid
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yadiro.m,v 1.3 2003-10-30 13:27:30 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Checking input
if (nargin < 4)
  yahelp('yadiro','usage');
  error('''yadiro'' has at least 4 arguments');
end

if (sc <= 0)
  yahelp('yadiro','usage');
  error('''sc'' must be strictly positive');
end

%% Computations

if (getopts(varargin,'freq',[],1))
  factor = sc;
else
  factor = 1/sc;
end

if (ang == 0)
  nX = factor * X;
  nY = factor * Y;
else
  nX = factor * ( cos(ang).*X - sin(ang).*Y );
  nY = factor * ( sin(ang).*X + cos(ang).*Y );
end


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
