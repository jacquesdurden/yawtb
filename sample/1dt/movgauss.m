function [out] = movgauss(nt,nx)
% \manchap
% 
% Create a three moving Gaussians on the line.
%
% \mansecSyntax
% [out] = movgauss([nt] [,nx])
%
% \mansecDescription
%
% This function creates three moving Gaussians on the line with
% speeds equal to 1, 0.5, -1 pixel/frame.
%
% \mansubsecInputData
% \begin{description}
% \item[nt, nx] [INTEGERS]: the number of times and positions
% (default $64\times128$).
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [DOUBLE MATRIX]: a nt$\times$nx matrix containing the three
% moving Gaussians.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> mat = movgauss;
% %% CWT Velocity-position representation on frame 10
% >> wav=cwt1dt(fft2(mat),'morlet',6,vect(-2,2,128),'time',10);
% >> yashow(wav);
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
% $Header: /home/cvs/yawtb/sample/1dt/movgauss.m,v 1.4 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Handling the inputs
if ~exist('nt')
  nt = 64;
end

if ~exist('nx')
  nx = 128;
end

%% Generating the sample
[X,T] = meshgrid(0:(nx-1),0:(nt-1));
nx_1  = nx-1;
nt_1  = nt-1;

% Initial position
x1    = nx_1/4;
x2    = nx_1/2;
x3    = 3*nx_1/4;

% Velocities
v1    = 1;
v2    = 0.5;
v3    = -1;

% Gaussians' Sizes (If you want to modify them...)
s1    = 1;
s2    = 1; 
s3    = 1; 

% Seperated Gaussians
g1 = exp(-(X - (x1 + v1*T)).^2/(2*s1^2));
g2 = exp(-(X - (x2 + v2*T)).^2/(2*s2^2));
g3 = exp(-(X - (x3 + v3*T)).^2/(2*s3^2));

% Mixing of the gs.
out = max(g1,g2);
out = max(out,g3);


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
