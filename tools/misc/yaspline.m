function out = yaspline(x, m)
% \manchap
% 
% Yet another cardinal B-spline computation
%
% \mansecSyntax
%
% out = yaspline(x, m)
%
% \mansecDescription
%
% Compute the cardinal B-spline of order \libvar{m} with the
% recurrence formula
%     $N(x,m) = x * N(x, m-1) + (m - x)*N(x-1, m-1)$
%
%     N(x,0) = 1 if x in [-1/2,1/2[
%              0 elsewhere
%
% Notice that yaspline recenters the resulting spline onto 0
% instead of (m+1)/2.
%
% \mansubsecInputData
% \begin{description}
% \item[x] [REAL VECTOR]: the vector of positions;
% \item[m] [INTEGER]: the order of the spline (default: 2).
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL VECTOR]: the resulting spline
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> plot( yaspline(vect(-5,5,128), 6) );
% \end{code}
%
% \mansecReference
% 
% Unser \& al.
%
% \mansecSeeAlso
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yaspline.m,v 1.4 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~exist('m')
  m = 2;
elseif (rem(m,1) ~= 0) | (m < 0)
  yahelp('yaspline','usage');
  error('''m'' must be a positive integer');
end

out = yaspline_recurs(x + (m+1)/2, m);

function outr = yaspline_recurs(x, m)
if (m > 0)
  outr = ( x .* yaspline_recurs(x, m - 1) + ...
	   (m + 1 - x) .* yaspline_recurs(x - 1, m - 1) ) ./ m;
else
  outr = ((0 < x) & (x <= 1));
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
