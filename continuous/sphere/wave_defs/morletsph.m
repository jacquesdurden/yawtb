% \manchap
%
% Spherical Morlet wavelet.
%
% \mansecSyntax
%
% [out] = morletsph(X,Y,Z,x,y,z,sc,ang,k0)
%
% \mansecDescription
%
% This function computes the Spherical Morlet wavelet [3] given by:
% \begin{verbatim}
%    Psi_a(theta,phi) =
%       lambda(theta,a)^0.5 * exp(i*k0*2*tan(theta/2)/a*cos(phi-ang))
%                           * exp(-2*tan(theta/2)^2/a^2)
%                           * 0.5 * (1 + tan(theta/2)^2/a^2)
%
%                                 4 * a^2
% where lambda =     -----------------------------------
%                    ( (a^2-1)*cos(theta) +  (a^2+1) )^2.
% \end{verbatim}
%
% Warning : this wavelet should be complex-valued, but only the real
%           part is computed here.
%
% This function is implemented in C.
%
% \mansubsecInputData
% \begin{description}
%
% \item[X,Y,Z] [DOUBLE MATRICES]: the 3D coordinates of a regular
% spherical grid on a unit sphere.
%
% \item[x,y,z] [DOUBLE SCALARS]: the 3D coordinates of the wavelet
% center on the sphere.
%
% \item[sc,ang] [DOUBLE SCALARS]: the scale and the angle of the
% wavelet.
%
% \item[k0] [DOUBLE SCALAR]: norm of the wave vector of the wavelet
% in the euclidean limit (accounts for the number of oscillations)
%
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [DOUBLE MATRIX]: the wavelet on a spherical grid.
% \end{description}
%
% \mansecExample
%
% \mansecReferences
% [1] : "Ondelettes directionnelles et ondelettes sur la
%       sphère", P. Vandergheynst, Thèse, Université catholique
%       de Louvain, 1998
%
% [2] : Jean-Pierre Antoine, L. Jacques and P. Vandergheynst,
%       Wavelets on the sphere : Implementation and approximations.
%       submitted to Applied and Computational Harmonic Analysis (2001)
%
% [3] : "Ondelettes et Détection de Sources Gamma dans l'Univers",
%       L. Demanet, Mémoire, Université catholique de Louvain, Juin 2001.
%
% \mansecSeeAlso
%
% ^continuous/sphere/.* /yashow$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/sphere/wave_defs/morletsph.m,v 1.5 2003-04-08 14:33:23 ljacques Exp $
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
