function [out,err] = sphcg(wav, n, varargin)
% \manchap
%
% Spherical Conjugate Gradient Reconstruction
%
% \mansecSyntax
%
% [out, err] = sphcg(wav, n [,'ref', ref], [,'approx', g])
%
% \mansecDescription
%
% Iterativeley rebuild a spherical signal from the wavelet
% coefficients of a spherical frame.
%
% \mansubsecInputData
% \begin{description}
% \item[wav] [STRUCT]: the frame coefficients obtained by ffwtsph.
% 
% \item[n] [INT]: number of iteration to perform in the algorithm.
%
% \item[ref] [REAL MATRIX]: the original spherical data if
% available. It is used to compute the rebuilding error at each
% iteration.
%
% \item[g] [REAL MATRIX]: approximated rebuilding of the spherical
% data obtained with iffwtsph if available.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL MATRIX]: approximated rebuilding the spherical
% data after $n$ iteration of the conjugated gradient algorithm.
%
% \item[err] [REAL VECTOR]: convergence error at each iteration.
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world2; mat=mat*1;
% >> yashow(mat,'spheric','fig',1);
% >> wav=ffwtsph(mat,'dog'); 
% >> g=iffwtsph(wav);
% >> yashow(g,'spheric','fig',2,'mode','real');
% >> nmat=sphcg(wav,5,'ref',mat,'approx',g); %% It's time to take two pills of Temesta ;-)
% >> yashow(nmat,'spheric','fig',3);
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
% $Header: /home/cvs/yawtb/frames/sphere/sphcg.m,v 1.4 2007-01-15 08:56:03 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

tic;

ref = getopts(varargin, 'ref', []);

g = getopts(varargin,'approx',[]);

if isempty(g)
  g = iffwtsph(wav);
end

out = 0;

r   = g;
p   = g;
pm1 = 0;

global weight;
weight = 4*pi*sphweight(2*wav.B, 2*wav.B, 'nopoles');

if (~isempty(ref))
  norm_ref = sum(weight(:) .* abs(ref(:)).^2).^.5;
end

oyap = yapbar([], n);
for k = 1:n,
  old_out = out;
  
  if (k == 1) 
    Lpm1 = 0;
  else
    Lpm1 = iffwtsph(ffwtsph(pm1, wav.wavname, wav.extra{:}));
  end
  
  Lp = iffwtsph(ffwtsph(p, wav.wavname, wav.extra{:}));

  p_Lp = ps(p,Lp);
  pm1_Lpm1 = ps(pm1,Lpm1);
  
  lambda = ps(r,p)/p_Lp;
  
  out = out + lambda*p;
  r   = r - lambda*Lp;
  
  if (k == 1)
    pp1 = Lp - (ps(Lp,Lp)/p_Lp)*p;
  else
    pp1 = Lp - (ps(Lp,Lp)/p_Lp)*p - (ps(Lp,Lpm1)/pm1_Lpm1)*pm1;
  end
  
  pm1 = p;
  p = pp1;
  
  if (isempty(ref))
    converg_dist = sum(abs(out(:) - old_out(:)).^2.*weight(:)).^.5;
    fprintf('Step %i: abs. distance: %e\n', k, converg_dist);
  else
    converg_dist = sum(abs(out(:) - ref(:)).^2.*weight(:)).^.5;
    fprintf('Step %i: rel. distance: %e\n', k, converg_dist ./ norm_ref);
  end
  err_tmp(k) = converg_dist;
  oyap = yapbar(oyap, '++');
end
oyap = yapbar(oyap, 'close');

if (nargout > 1)
  err = err_tmp;
end

fprintf('Elapsed time: %.1fs\n',toc);

function val = ps(mat1, mat2)
%% Spherical scalar product with Cleanshaw-Curtis weight
global weight;
val = sum( mat1(:) .* conj(mat2(:)) .* weight(:));

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
