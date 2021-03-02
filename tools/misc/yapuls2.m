function [pulsx,pulsy] = yapuls2(npulsx,npulsy)
% \manchap
%
% Pulsation matrix
%
% \mansecSyntax
%
% [pulsx,pulsy] = yapuls2(npulsx [,npulsy])
% [pulsx,pulsy] = yapuls2(npuls)
%
% \mansecDescription
%
% \libfun{yapuls2} returns two pulsation matrices \libvar{pulsx}
% and \libvar{pulsy} of size \libvar{npulsx}*\libvar{npulsy} such
% that, each row of \libvar{pulsx} or each column of \libvar{pulsy}
% is the concatenation of two  subvectors whose elements are 
% respectively in  $[0,\pi)$ and  $[-\pi,0)$.  Useful function
% when computing 2D wavelets directly in the Fourier domain.
%
% \mansubsecInputData
%
% \begin{description}
% \item[npulsx] [REAL SCALAR]: length of the x-pulsation vector
% \item[npulsy] [REAL SCALAR]: length of the y-pulsation vector
% equals to \libvar{npulsx} by default.
% \item[npuls] [REAL VECTOR]: 2-length vector containing the
% values of npulsx and npulsy.
% \end{description} 
%
% \mansubsecOutputData
%
% \begin{description}
% \item[pulsx] [REAL MATRIX]: the x-pulsation matrix
% \item[pulsy] [REAL MATRIX]: the y-pulsation matrix
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> [pulsx,pulsy] = yapuls2(5)
% >> [pulsx,pulsy] = yapuls2([5 4])
% >> [pulsx,pulsy] = yapuls2(5,4)
% \end{code}
% prints and returns a 5x5-size, and two 5x4-size pulsation matrix.
%
% \mansecReference
%
% \mansecSeeAlso
%
% vect /cwt.+d$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yapuls2.m,v 1.2 2002-09-19 14:33:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~exist('npulsy')
  if (length(npulsx) == 1)
    npulsy = npulsx;
  elseif (length(npulsx) == 2)
    npulsy = npulsx(2);
    npulsx = npulsx(1);
  else
    yahelp(mfilename,'usage');
    error('npulsx must be a scalr or a 2-length vector');
  end
end

[pulsx,pulsy] = meshgrid(yapuls(npulsx),yapuls(npulsy));

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
