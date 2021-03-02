function [out] = rgray(n)
% \manchap
% This function return the reverse gray colormap 
%
% \mansecSyntax
%
% [out] = rgray([n])
%
% \mansecDescription
%
% This function returns the reverse gray colormap simply given by
% 1-gray.
% The number of gray level can optionnally be given through the n variable.
%
% \mansubsecInputData
% \begin{description}
% \item[n] [INTEGER]: the number of gray level (64 by default) 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the reverse gray colormap of nx3 size.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> yashow(rand(128,128),'cmap','rgray');
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
% yashow
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/cmap/rgray.m,v 1.1 2001-11-04 16:42:12 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~exist('n')
  out = 1 - gray;
else
  out = 1 - gray(n);
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
