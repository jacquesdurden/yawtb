function obj = fwt2d_app(obj,varargin)
% \manchap
%
% \mansecSyntax
%
% [] = fwt2d\_app()
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
% $Header: /home/cvs/yawtb/frames/2d/fwt2d_app.m,v 1.4 2003-12-19 22:59:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

mask = fwt2d_app_filter(obj);
if (getopts(varargin,'temp',[],1))
  obj.temp = ifft2( obj.tI.*conj(mask) );
else
  obj.app = ifft2( obj.tI.*conj(mask) );
end
obj.app_norm = (sum(abs(mask(:)).^2)*obj.dkxdky)^0.5/(2*pi); 

if (getopts(varargin,'export',[],1))
  obj = obj.app;
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
