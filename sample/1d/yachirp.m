function [out] = yachirp(n)
% \manchap
%
% Compute a typical chirp cosine
%
% \mansecSyntax
%
% [out] = yachirp([n])
%
% \mansecDescription
% This function computes another typical chirp cosine on n points
% (the default is 256)
%
% \mansubsecInputData
% \begin{description}
% \item[n] [INTEGER]: the number of points. 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] The output chirp.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> ch = yachirp(256)
% >> plot(ch)
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
% $Header: /home/cvs/yawtb/sample/1d/yachirp.m,v 1.4 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~exist('n')
  n = 256;
end

if (~isnumeric(n)) | (rem(n,1))
  error('chirp([n]): ''n'' must be an integer!');
end

t   = 1024*(1:n)/n;
out = sin(2*pi*t/30./(1+t/1000)); 


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
