function out = box2d_wav(kx,ky, nang)
% \manchap
%
% Wavelet of the "Box" frame.
%
% \mansecSyntax
%
% out = box2d\_wav(kx, ky, nang)
%
% \mansecDescription
%
% Compute the wavelet of the "Box" frame, namely the angular sector
% which take 1 if
%     $pi/2 <= abs(K) <  pi,$
%     $-pi/nang   <  arg(K) <= pi/nang,$
% with $K = (kx,ky)$, and 0 elsewhere.
%
% \mansubsecInputData
% \begin{description}
% \item[kx] [MATRIX]: the horizontal frequencies; 
%
% \item[ky] [MATRIX]: the vertical frequencies; 
%
% \item[nang] [INTEGER]: the number of angular sectors on which the
% frame decomposition is computed.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the computed function on the frequency plane.
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
% $Header: /home/cvs/yawtb/frames/2d/frame_defs/box2d_wav.m,v 1.4 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (isempty(kx))
  out = {};
  return;
end

mod_k = abs(kx + i*ky);
arg_k = angle(kx + i*ky);

out = 1*((pi/2 <= mod_k) & (mod_k < pi) & (-pi/nang < arg_k) & (arg_k <= pi/nang));

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
