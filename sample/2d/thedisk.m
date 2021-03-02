function [out] = thedisk(n, varargin)
% \manchap
%
% Create a disk in a square image.
%
% \mansecSyntax
%
% [out] = thedisk([n] ['Center', center] [,'Radius', radius] [,'Smooth', smooth])
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
%
% \item[n] [INTEGER]: the size of the image (default 64); 
%
% \item[center] [REAL VECTOR]: specify the center of the disk in
% (x,y) coordinates knowing that 
% the complete image is the domain [-1,1]x[-1,1]. 'center' is set
% to the origin [0 0] by default.
%
% \item[radius] [REAL]: the radius of the disk relatively to the
% size of the output matrix (0: nothing, 1: the whole matrix).
%
% \item[smooth] [REAL] specify if the disk must be smooth on the edge.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [BINARY MATRIX]:
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> mat= the disk;
% >> yashwo(mat);
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
% $Header: /home/cvs/yawtb/sample/2d/thedisk.m,v 1.5 2002-05-27 14:19:18 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~exist('n')
  n = 64;
end

center = getopts(varargin, 'center', [0 0]);
radius = getopts(varargin, 'radius', 0.5);

if (radius < 0)
  yahelp(mfilename,'syntax');
  error('The radius must be positive');
end

[x,y] = meshgrid(vect(-1,1,n));
r     = abs( x + i*y - (center(1) + i*center(2))); 
step  = 2*3/(n-1); 
step2 = step/2;
smooth = getopts(varargin,'smooth',[],1);

if (smooth)
  if (radius < step2)
    error('Radius is too small to create a smooth disk');
  end
  
  out = r < (radius - step2);
  out = out + ( ( r >= (radius - step2) ) & ( r < (radius + step2) ) ) .* ...
	cos(pi*(r-(radius-step2))/(2*step)).^2;
else
  out = r < radius;
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
