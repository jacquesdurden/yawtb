function out = iffwtsph(wav, varargin)
% \manchap
%
% WITHOUT ITERATIVE METHODS SUCH AS THE CONJUGATED GRADIENT METHODS, 
% IFWTSPH OR IFFWTSPH DO NOT PROVIDE PERFECT RECONSTRUCTION 
% BUT JUST APPROXIMATION (see sphcg.m for more informations).
%
% \mansecSyntax
%
% [] = iffwtsph()
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[] []: 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[] []:
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
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/sphere/iffwtsph.m,v 1.3 2007-01-15 09:18:01 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

aj = wav.aj;
bj = wav.bj;
jv = wav.jv;

J = wav.J;

B = wav.B;
B2 = B*2;
l = 0:(B-1);

%load('sphgl.mat','gl');
%gl((end+1):B) = gl(end);
%gl = gl(1:B);
gl = 0.8;

nuj = abs(diff([aj (aj(end)/2) (aj(end)/4)]))./[aj aj(end)/2].^3;

lmmap = zeros(2*B-1,B);

for j = 1:length(jv),
  fdata = lmshape(fst(wav.data{j}));
  
  if (bj(j) ~= B)
    fdata = [ fdata(1:bj(j),:); ...
	      zeros(2*(B-bj(j)),bj(j)); ...
	      fdata((bj(j)+1):end,:) ];
    fdata = [ fdata, zeros(B2-1, B-bj(j))];
  end
  
  mask = repmat(wav.ffilter{j}*(4*pi)^.5./(gl.*(2*l+1).^.5),B2-1,1);  
  lmmap = lmmap +  nuj(j) * (mask .* fdata);
end

if (isfield(wav,'hdata'))
  fdata = lmshape(fst(wav.hdata));
  mask = repmat(wav.hffilter(1:B)*(4*pi)^.5./(gl.*(2*l+1).^.5),B2-1,1);  
  lmmap = lmmap +  nuj(end) * (mask .* fdata);
end

out = ifst(ilmshape(lmmap)) + wav.outband;

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
