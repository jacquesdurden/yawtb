function out = yabeta(t, m)
% \manchap
% 
% Profile function beta 
%
% \mansecSyntax
%
% out = yabeta(t, m)
%
% \mansecDescription
%
% Compute the profile function beta of order m (described in [1])
% such that:
%   $beta(t,m)^2 + beta(1-t,m)^2 = 1 for t in [-1, 1]$\\
%   $beta(t,m+1) = beta(sin(t*pi/2),m)$\\
%   $beta(t,0)   = sin((1 + t)*pi/4)$
%
% \mansubsecInputData
% \begin{description}
% \item[t] [REAL VECTOR]: the positions on which to compute the beta
% function;
% \item[m] [INT]: the order of the beta function 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL VECTOR]: the beta function computed on 
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> t = vect(-2,2,128);
% >> plot(t,yabeta(t,0),'b',t,yabeta(t,1),'r');set(gca,'ylim',[-.5,1.5]);
% >> hold on;plot(t,yabeta(t,2),'g',t,yabeta(t,3),'k');hold off
% \end{code}
%
% \mansecReference
% [1] S. Mallat. A Wavelet Tour of Signal Processing.
%
% \mansecSeeAlso
%
% yaspline
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yabeta.m,v 1.2 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if m > 0
  out = yabeta(sin(t*pi/2),m-1);
else
  out = sin((1+t)*pi/4);
end

out(t<-1) = 0;
out(t>1) = 1;

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
