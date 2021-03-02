function [out] = es2cauchy2d(kx,ky,apert,sigma,l,m)
% \manchap
%
% Compute an second endstop wavelet from the 2D Cauchy Wavelet in frequency plane
%
% \mansecSyntax
% [out] = es2cauchy2d(kx,ky,apert,sigma,l,m)
%
% \mansecDescription
% This function computes the 2D Cauchy wavelet in frequency plane.
% That is, the wavelet given by:
% \begin{verbatim}
%                   _
%                  |(E(apert-pi/2) . K)^l 
%                  |           * (E(-apert+pi/2) . K)^m 
%                  |           * exp( - 0.5 * sigma * |K-K_0|^2 )  
% PSIHAT(kx,ky) = <                      INSIDE C(-apert,apert)
%                  |  
%                  |0                    OUTSIDE C
%                  `-       
% where: E(alpha) = (cos(alpha), sin(alpha))
%        K        = (kx, ky)                  
%        K_0      = (l+m)^0.5 * (sigma - 1)/sigma * (1,0)
%        C(-apert,apert) = the cone supported by E(apert)
%                          and E(-apert)
% \end{verbatim}
%
% The wavelet parameters are thus:
% \begin{itemize}
% \item apert : the half aperture of the cone;
% \item sigma : the frequency spread of the wavelet;
% \item l,m   : its vanishing moments.
% \end{itemize}
%
% This function is used by the cwt2d routine which compute
% continuous wavelet transform in 2D.
%
% \mansubsecInputData
%
% \begin{description}
% \item[kx, ky] [REAL MATRICES]: The frequency plane. Use 
%   meshgrid to create it. 
% \item[apert] [REAL SCALAR]: The aperture of the cone 
%   (in gradiant)
% \item [sigma] [REAL SCALAR]: The frequency spread of the wavelet
% \item [l,m] [INTEGERS]: The vanishing moments
% \end{description} 
%
% \mansubsecOutputData
%
% \begin{description}
% \item [out] [REAL MATRIX]: The wavelet in frequency plane. 
% \end{description} 
%
% \mansecExample
%
% \begin{code}
% >> step = 2*pi/128;
% >> [kx,ky] = meshgrid( -pi : step : (pi-step) );
% >> wav = cauchy2d(kx,ky,pi/6,1,4,4);
% >> imagesc(wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/2d/.*2d$ ^meshgrid$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/wave_defs/es2cauchy2d.m,v 1.1 2003-03-13 12:40:00 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% List of wavelet parameters name and default value
wavparval = {'apert',pi/6,'sigma',1,'l',4,'m',4};

%% Return only wavparval if an empty input is given as kx
if ( (nargin == 1) & isempty(kx) )
  out = wavparval;
  return
end

%% Computing the wavelet in frequency domain
dot1  =  sin(apert)*kx + cos(apert)*ky;
dot2  = -sin(apert)*kx + cos(apert)*ky;
coeff = (dot1.^l).*(dot2.^m);
  
k0    = (l+m)^0.5 * (sigma - 1)/sigma;
rad2  = 0.5 * sigma * ( (kx-k0).^2 + ky.^2 );
  
pond  = tan(apert)*kx  > abs(ky);
out   = -ky.^2 .* pond .* coeff .* exp(- rad2 );

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
