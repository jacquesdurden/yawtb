function mask = fwt2d_dhigh_filter(obj, ind_ang, varargin)
% \manchap
%
% \mansecSyntax
%
% [] = fwt2d\_dhigh\_filter()
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[] []: 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[] []:
% \end{description} 
%
% \mansecExample
% \begin{code}
% >>
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
% $Header: /home/cvs/yawtb/frames/2d/fwt2d_dhigh_filter.m,v 1.2 2003-12-19 22:59:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

[nkx, nky] = yadiro(obj.kx, obj.ky, 1, obj.ang(ind_ang), 'freq');
mask = feval(obj.frame.dhigh.name, ...
	     nkx, nky, obj.Ks(ind_ang), ...
	     obj.frame.dhigh.opts{:});

if (~obj.frame.dualdef)
  mask = mask ./ obj.allwav;
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
