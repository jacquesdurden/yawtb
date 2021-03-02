% \manchap
%
% SOFT fast SO(3) correlation of spherical functions
%
% \mansecSyntax
%
% so3_data = softcorr(data_sh_coeffs, filter_sh_coeffs)
%
% \mansecDescription
% 
% This function realizes a link between the SOFT [1] toolkit (SO(3)
% Fourier Transform) and matlab. In particular, it uses the fast
% SOFT's correlation of two spherical functions in SO(3). This
% correaltion is defined by
%
%         (h * f)(rho) = < R_rho h | f >
%
% where <|> is the spherical inner product of two functions in
% L^2(S^2), rho is an element of SO(3) given by its three Euler
% angles rho=(phi, theta, alpha), and the Fourier transform of f
% and h correspond respectively to \libvar{data_sh_coeffs} and
% \libvar{filter_sh_coeffs} in the call of \libfun{softcorr}.
%
% \mansubsecInputData
% \begin{description}
% \item[data_sh_coeffs] [CPLX MATRIX]: the Fourier transform
% (return by \libfun{fst} or \libfun{s2fst}) of the
% the spherical data (corresponding to f) to be filtered. 
%
% \item[filter_sh_coeffs] [CPLX MATRIX]: the FT of the spherical
% filter (corresponding to h)
% 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[so3_data] [CPLX ARRAY]: The resulting correlation defined
% on SO(3). This is a 3 dimensional array for which the third
% dimension correspond to each alpha orientation of the filter, the
% first and the second position to the position (theta, phi) of the
% filter on S^2.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% WARNING: This demo supposes at least 40 MB of RAM
% >> %% Defining the equi-angular spherical grid
% >> [phi, theta] = sphgrid(128);
% >> %% Defining a spherical sector
% >> f = (theta > pi/4) .* (theta < pi/2) .* (phi > pi) .* (phi < 3*pi/2);
% >> figure; yashow(f, 'spheric', 'cmap', 'winter');
% >> %% Defining a spherical Morlet (or Gabor) Wavelet
% >> X = sin(theta).*cos(phi); Y = sin(theta).*sin(phi); Z = cos(theta);
% >> a= 0.08; k0 = 6; wav = morletsph(X,Y,Z, 0,0,1, a, 0, k0);
% >> figure; yashow(wav, 'spheric', 'mode', 'real');
% >> %% Taking the Fourier transform of f and wav
% >> ff = fst(f); fwav = fst(wav);
% >> %% Computing the SO(3) correlation of f by wav
% >> corr = softcorr(ff, fwav);
% >> figure; yashow(corr(:,:,1), 'spheric'); %% alpha = 0 deg
% >> figure; yashow(corr(:,:,17), 'spheric', 'mode', 'real'); %% alpha = 45 deg
% >> figure; yashow(corr(:,:,33), 'spheric'); %% alpha = 90 deg
% >> figure; yashow(corr(:,:,49), 'spheric', 'mode', 'real'); %% alpha = 135 deg
% \end{code}
%
% \mansecReference
%
% [1] SOFT: http://www.cs.dartmouth.edu/~geelong/soft/
%
%
% \mansecSeeAlso
% 
% sphgrid, fst, s2fst, ifst, morletsph 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/interfaces/soft/softcorr.m,v 1.3 2004-12-17 10:21:18 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)




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
