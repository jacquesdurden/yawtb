function out = cube(n,ncube)
% \manchap
%
% Generate a 3D sample cube.
%
% \mansecSyntax
%
% [out] = cube(n [,ncube])
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[n] [INTEGER]: The size of the cubic domain where the cube
% is defined.
%
% \item[ncube] [INTEGER]: the size of the cube set to n/2 by default.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [ARRAY]: the volume describing the cube (1 inside \& 0 outside)
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> cub = cube(64);
% >> yashow(cub);
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
% $Header: /home/cvs/yawtb/sample/3d/cube.m,v 1.2 2002-01-22 12:00:48 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Initializations
if ~exist('ncube')
  ncube = n/2;
end

%% Computing the cube in a volume of n x n x n
out  = zeros(n,n,n);
ind  = max(1,round((n - ncube)/2)) : min(n,round((n + ncube)/2));
out(ind,ind,ind) = 1;


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
