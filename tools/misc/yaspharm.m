function Ylk = yaspharm(theta, phi, l, k)
% \manchap
%
% Generate a spherical harmonic on a regular spherical grid 
%
% \mansecSyntax
%
% Ylk = yaspharm(theta, phi, l, k)
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[theta] [REAL MATRIX]: the grid of co-latitude angles.
% \item[phi] [REAL MATRIX]: the grid of longitude angles.
% \item[l] [INT]: the degree of the spherical harmonic.
% \item[k] [INT]: the order of the spherical harmonic.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[Ylk] [CPLX MATRIX]: the spherical harmonic computed on the
% spherical grid.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [phi, theta] = meshgrid( vect(0,2*pi,256,'open'), vect(0,pi,128));
% >> Ylk = yaspharm(theta, phi, 6, 1);
% >> yashow(Ylk, 'spheric', 'relief', 'mode', 'real');
% >> yashow(Ylk, 'spheric', 'relief', 'mode', 'imag');
% >> yashow(Ylk, 'spheric', 'relief', 'mode', 'abs');
% \end{code}
%
% \mansecReference
%
% [1] "Spherical Harmonics" on mathworld.com, http://mathworld.wolfram.com/SphericalHarmonic.html
%
% \mansecSeeAlso
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yaspharm.m,v 1.5 2006-04-28 08:51:47 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (abs(k) > l)
  Ylk = 0;
  return;
end

Ylk = legendre(l,cos(theta));

if (l)
  Ylk = squeeze(Ylk(abs(k)+1,:,:)).*exp(i*k*phi);
else
  Ylk = Ylk.*exp(i*k*phi);
end

if (k == 0)
  Ylk = Ylk * ((2*l+1)/(4*pi))^.5;
else
  Ylk = Ylk * (1/prod((l-abs(k)+1):(l+abs(k))))^.5 * ((2*l+1)/(4*pi))^.5;
end
  
if (k<0)
  Ylk = (-1)^k * Ylk;
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
