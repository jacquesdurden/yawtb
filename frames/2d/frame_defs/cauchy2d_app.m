function out = cauchy2d_app(kx,ky, sigma, l)
% \manchap
%
% The approximation function of the Cauchy frame.
%
% \mansecSyntax
%
% out = cauchy2d\_app(kx, ky)
%
% \mansecDescription
%
% Compute the approximation function of the Cauchy frame, that is a
% Gaussian centered on the frequency origin and of spread equals to
% pi/2.
%
% \mansubsecInputData
% \begin{description}
% \item[kx] [MATRIX]: the horizontal frequencies; 
%
% \item[ky] [MATRIX]: the vertical frequencies; 
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the computed function on the frequency plane.
% \end{description} 
%
% \mansecSeeAlso
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/2d/frame_defs/cauchy2d_app.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (isempty(kx))
  out = {'sigma',1,'l',4};
  return;
end

width = pi/2;
out = exp( - (kx.^2 + ky.^2)/(2*width^2)); 

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
