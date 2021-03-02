function [X,Y,Z] = sphgridcart(nth, nph, varargin)
% \manchap
%
% Spherical grid in cartezian coordinates
%
% \mansecSyntax
%
% [X,Y,Z] = sphgrid(nth [,nph] [,'withpoles'] )
%
% \mansecDescription
%
% Compute a equi-angular spherical grid. By default, points (X,Y,Z)
% correspond to spherical coordinates 
%      (theta\_i,phi\_j), i=0..nth-1, j=0..nph-1
% with theta\_i = (2*i+1)*pi/(2*nth)
%      phi\_j = j*2*pi/nph
% The size of this grid is nth*nph
%
% If 'withpoles' is set, the spherical grid is then defined by
%      (theta\_i,phi\_j), i=0..nth, j=0..nph-1
% with theta\_i = i*pi/nth
%      phi\_j = j*2*pi/nph 
% The size is this case equal to (nth+1)*nph.
%
% \mansubsecInputData
% \begin{description}
% \item[nth] [INT]: the number of angles theta
% \item[nph] [INT]: the number of angles phi
% \item['withpoles'] [BOOL]: activate the second grid forming
% method described above.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[X,Y,Z] [REAL MATRICES]: the cartezian coordinates. These
% three matrixe have size nth*nph (or (nth+1)*nph if 'withpoles'
% flag is set) 
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [X,Y,Z] = sphgridcart(256);
% >> u=rand(1,3);u=u/norm(u);
% >> wav=cos(4*(abs(X-u(1)).^2 + abs(Y-u(2)).^2 + abs(Z-u(3)).^2));
% >> yashow(wav,'spheric','relief');view(cross([0 0 1],u))
% \end{code}
%
% \mansecSeeAlso
% fst, ifst, cwtsph, fcwtsph
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/sphgridcart.m,v 1.2 2007-09-20 13:13:54 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (~exist('nph'))
  nph = nth;
elseif isstr(nph)
  varargin{1} = nph;
  nph = nth;
end

if (getopts(varargin,'withpoles', [], 1))
  [phi,theta] = meshgrid( vect(0, 2*pi, nph, 'open'), ...
			  vect(0, pi, nth+1) );
else
  [phi,theta] = meshgrid( vect(0, 2*pi, nph, 'open'), ...
			  vect(0, pi, nth, 'rlopen'));
end


X = sin(theta).*cos(phi);
Y = sin(theta).*sin(phi);
Z = cos(theta);

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
