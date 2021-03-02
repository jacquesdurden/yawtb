function [out,nu] = linearchirp(n,nu_0,nu_1,phi)
% \manchap
%
% Return a complex linear chirp and its theoretical instantaneous 
% frequency
%
% \mansecSyntax
% [out,nu] = linearchirp([n[,nu\_0[,nu\_1[,phi]]]])
%
% \mansecDescription
% This function computes and returns a complex linear chirp of n points
% whose instantaneous frequency starts at nu\_0 ends at nu\_1 with
% phi as the phase at the origin.
%
% The default values are: n = 256, nu\_0 = 0, nu\_1 = 0.4, phi = 0
%
% \mansubsecInputData
% \begin{description}
% \item[n] [INTEGER]: the number of points.
%
% \item[nu\_0] [REAL abs(nu\_0)<0.5]: Instantaneous frequency of the 
% first point.
%
% \item[nu\_1] [REAL abs(nu\_1)<0.5]: Instantaneous frequency of the
% last point.
%
% \item[phi] [REAL]: Phase of the signal at the origin.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] :The complex linear chirp.
%
% \item[nu] :The instantaneous frequency of the linear chirp.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [signal,nu] = linearchirp(256, 0, 0.1 )
% >> plot(real(signal))
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
% $Header: /home/cvs/yawtb/sample/1d/linearchirp.m,v 1.4 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed
% with this library) (See the notice at the end of the file.)

%%% Check the input argument
if exist('n') ~= 1,
  n = 256;
end

if ~isnumeric(n) | rem(n,1) | prod(size(n))~= 1,
  error('The first parameter ''n'' must be an integer!');
end

if exist('nu_0') ~= 1,
  nu_0 = 0;
end

if exist('nu_1') ~= 1,
  nu_1 = 0.4;
end

if (~isnumeric(nu_0) | prod(size(nu_0)) ~= 1 ...
  | ~isnumeric(nu_1) | prod(size(nu_1)) ~= 1)
  error([ 'The second and third parameters ''nu_0'' and ''nu_1'' must be' ...
	  ' real scalars.' ]);
end

if ( abs(nu_0) > 0.5 | abs(nu_1) > 0.5 ),
  error('abs(nu_0) and abs(nu_1) must be lower or equal than 0.5');
end

if exist('phi') ~= 1,
  phi = 0;
end

if (~isnumeric(phi) | prod(size(phi)) ~= 1 )
  error([ 'phi must be real scalars.' ]);
end

%%% Computation
T     = (0:n-1).';
alpha = (nu_1-nu_0)/n;

%%% Set the instantaneous frequency
nu = nu_0 + alpha*T;
phase = 2*pi*(nu_0*T + 0.5*alpha*T.^2)+phi;
out = exp( i*phase );

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
