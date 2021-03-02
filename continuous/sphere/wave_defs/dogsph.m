% \manchap
%
% Spherical Difference Of Gaussians (DOG) wavelet
%
% \mansecSyntax
%
% [out] = dogsph(X,Y,Z,x,y,z,sc,ang,alpha)
%
% \mansecDescription
%
% This function returns the DOG (Difference Of Gaussians) wavelet [1] which
% is given by:
% \begin{verbatim}
%    Psi_a(theta,phi) =   
%       lambda(theta,a)^0.5 * exp(- tan(theta/2)^2/a^2 )
%                  -  1/alf * lambda(theta,a*alf)^0.5 * exp(- tan(theta/2)^2/(a*alf)^2 )
% 
%                                 4 * a^2
% where lambda =     -----------------------------------
%                    ( (a^2-1)*cos(theta) +  (a^2+1) )^2.
% \end{verbatim}
% This function is implemented in C.
% 
%
% \mansubsecInputData
% \begin{description}
% \item[X, Y, Z] [MATRICES]: 3D coordinates of a regular
% spherical grid on an unit sphere ;
%
% \item[x,y,z] [SCALARS]: 3D coordinates of the wavelet
% center on the sphere
%
% \item[sc,ang] [SCALARS]: Scale and angle of the wavelet. For the zonal DOG
% wavelet, the angle has no influence 
%
% \item[alpha] [DOUBLE SCALAR]: Scale interval between the two
% Gaussians that define the wavelet.
% \end{description}
%
% \mansubsecOutputData
% 
% \begin{description}
% \item[out] [DOUBLE MATRIX]: Wavelet on a spherical grid.
% \end{description} 
%
% \mansecExample
% % \begin{code}
% % >>
% % \end{code}
%
% \mansecReference
%
% [1] : "Ondelettes directionnelles et ondelettes sur la
%        sphère", P. Vandergheynst, Thèse, Université Catholique
%        de Louvain, 1998  
%
% [2] : Jean-Pierre Antoine, L. Jacques and P. Vandergheynst, 
%       Wavelets on the sphere : Implementation and approximations.
%       submit to Applied and Computational Harmonic Analysis (2001)
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
% $Header: /home/cvs/yawtb/continuous/sphere/wave_defs/dogsph.m,v 1.5 2003-08-12 15:49:56 morvidon Exp $
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
