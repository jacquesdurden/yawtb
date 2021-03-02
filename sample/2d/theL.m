function out = theL(N, varargin)
% \manchap
%
% A 2D academic example: the letter L in a NxN matrix
%
% \mansecSyntax
% out = theL([N])
%
% \mansecDescription
% Return a binary square matrix of N$\times$N size with the letter L inside.
%
% \mansubsecInputData
% \begin{description}
% \item[N] [INTEGER] the width of the returned square matrix
% (default 64)
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [BINARY MATRIX] the resulting matrix.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> mat = theL;
% >> imagesc(theL);
% >> colormap(gray);
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
% $Header: /home/cvs/yawtb/sample/2d/theL.m,v 1.8 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~exist('N')
  N = 64;
end

if (N < 1) | (rem(N,1) ~= 0)
  error('N must be a positive integer. Check the command line');
end

out = zeros(N,N);

radius = getopts(varargin, 'radius', N/4);
N_2  = max(round(N/2),1);
exta = N_2 - radius;
extb = N_2 + radius;

out( exta : N_2,  exta : N_2 ) = max(out( exta : N_2,  exta : N_2 ),1);
out( N_2  : extb, exta : N_2 ) = max(out( N_2  : extb, exta : N_2 ),1);
out( exta : N_2,  N_2 : extb ) = max(out( exta : N_2,  N_2 : extb ),1);


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
