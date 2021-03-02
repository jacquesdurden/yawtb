function Ylk = yarspharm(theta, phi, l, k)
% \manchap
%
% Generate a real spherical harmonic on a regular spherical grid 
%
% \mansecSyntax
%
% Ylk = yarspharm(theta, phi, l, k)
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
% \item[Ylk] [REAL MATRIX]: the real spherical harmonic computed on the
% spherical grid.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [phi, theta] = meshgrid( vect(0,2*pi,256,'open'), vect(0,pi,128));
% >> Ylk = yarspharm(theta, phi, 6, 1);
% >> yashow(Ylk, 'spheric');
% >> yashow(Ylk, 'spheric', 'relief');
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
% $Header: /home/cvs/yawtb/tools/misc/yarspharm.m,v 1.1 2006-08-24 13:25:47 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (abs(k) > l)
  Ylk = 0;
  return;
end

Ylk = legendre(l,cos(theta));

if (k == 0)
  Nlk = ((2*l+1)/(4*pi))^.5;
else
  Nlk = (1/prod((l-abs(k)+1):(l+abs(k))))^.5 * ((2*l+1)/(4*pi))^.5;
end

if (k > 0)
  Ylk = squeeze(Ylk(abs(k)+1,:,:)).*cos(k*phi)*2^.5*Nlk;
elseif (k < 0)
  Ylk = squeeze(Ylk(abs(k)+1,:,:)).*sin(k*phi)*2^.5*Nlk;
else
  Ylk = squeeze(Ylk(abs(k)+1,:,:))*Nlk;
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
