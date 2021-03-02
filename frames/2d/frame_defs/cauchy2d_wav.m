function out = cauchy2d_wav(kx,ky, nang, sigma, l)
% \manchap
%
% The wavelet of the Cauchy frame.
%
% \mansecSyntax
%
% out = cauchy2d\_wav(kx, ky, nang, sigma, l, m)
%
% \mansecDescription
%
% Compute the wavelet of the Cauchy frame according the Cauchy
% wavalet given by cauchy2d().
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
% \item[sigma] [REAL]: the radial spread of the wavelet.
%
% \item[l] [INTEGER]: the moment of the wavelet on the edges of its
% cone.
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
% cauchy2d cauchy2d_app
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/2d/frame_defs/cauchy2d_wav.m,v 1.5 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (isempty(kx))
  out = {'sigma', 1/3, 'l', 4};
  return;
end

delta = 2*pi/nang;

if (delta > pi/2)
  error(['The cauchy wavelet is not defined for a cone of angular' ...
	 ' aperture greater than pi/2']);
end

l2 = 2*l;

%% For normalizing the maximum of the wavelet to 1
norm_wav = (sin(delta)^l2)*(l2^l)*exp(-l/sigma);

%% For centering the wavelet on pi/2
ratio = l2^0.5/(pi/2);

%% Computing the wavelet;
out = cauchy2d(kx*ratio, ky*ratio, delta, sigma, l, l) / norm_wav;


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
