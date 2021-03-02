function obj = fwt2d_allwav(obj, varargin)
% \manchap
%
% \mansecSyntax
%
% [] = fwt2d\_allwav()
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
% $Header: /home/cvs/yawtb/frames/2d/fwt2d_allwav.m,v 1.2 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% The mask of the approximation

if (obj.frame.dualdef)
  obj.allwav = 1;
else
  mask = feval(obj.frame.app.name, ...
	       obj.kx*obj.sc(end), obj.ky*obj.sc(end), ...
	       obj.frame.app.opts{:});
  obj.allwav = obj.allwav + abs(mask).^2;
  
  %% The masks of the wavelets
  for s = 1:length(obj.asc)
    for th = 1:obj.K
      [nkx, nky] = yadiro(obj.kx, obj.ky, obj.asc(s), obj.ang(th), 'freq');
      mask = feval(obj.frame.wav.name, nkx, nky, obj.K, obj.frame.wav.opts{:});
      obj.allwav = obj.allwav + abs(mask).^2;
    end
  end
  
  obj.allwav(obj.allwav < 1e-14) = 1e-14;
end

if (getopts(varargin,'export',[],1))
  obj = obj.allwav;
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
