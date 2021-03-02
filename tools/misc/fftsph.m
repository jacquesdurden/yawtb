function out = fftsph(mat, varargin)
% \manchap
%
% Spherical Harmonic Transform
%
% \mansecSyntax
%
% out = fftsph(mat, [,'L', L] [,'axisym'] [,'cache'])
%
% \mansecDescription
%
% Compute the Spherical Harmonic transform.
%
% \mansubsecInputData
% \begin{description}
% \item[mat] [MATRIX]: the function to transform on an equiangular
% latitude-longitude spherical grid of size (2M+1)xN. 
% The number of latitudes must be odd!
%
% \item[L] [INT]: the order where to stop the transform. Default
% value: M.
%
% \item['axisym'] [BOOL]: tells to fftsph if mat represent an
% axisymmetric function, that is a function symmetric around the
% poles.
%
% \item['cache'] [BOOL]: tells to fftsph to cache spherical
% harmonics in tempdir (normally /tmp/) for further uses. If
% previous caches are detected, fftsph load the previous result
% instead of computing once again the spherical harmonics. This
% caching becomes intersting only from M greater than 64 in the
% axisymmetric case.
%
% Remark: The call of fftsph([], 'clearcache') clear the cache.
% 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the resulting coefficients. The size of out
% is 1x(L+1) if mat is axisymmetric, and (L+1)x(2L+1) if not. In the
% last case, for each l<=L, coefficents are sorted in out(l,:) as
%     -l, -l+1, ..., l-1, l, 0, ..., 0
% with 2L+1 - (2l+1) zeros at the end.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% Creating the equiangular spherical grid
% >> [phi, theta] = meshgrid(vect(0,2*pi,16,'open'), vect(0,pi,9));
% >> %% Creating a spherical function, here its is just Y43
% >> mat = yaspharm(theta, phi, 4, 3);
% >> figure; yashow(mat, 'spheric', 'relief', 'mode', 'real');
% >> %% Computing the SH transform
% >> tmat = fftsph(mat);
% >> %% Finding important values (> 10*eps ~10^-15)
% >> abs(tmat) > 10*eps
% >> %% Not zero value in (5,8), i.e. l=4 and m=3 (8 - l - 1)
% >> tmat(5,8)
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% ifftsph, sphweight, yaspharm
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/fftsph.m,v 1.1 2003-08-18 10:55:34 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)


%% If mat is empty, clear the cache and return
if (isempty(mat))
  if getopts(varargin, 'clearcache', [], 1)
    eval(['!rm -f ' tempdir 'fftsph*']);
    return
  else
    yahelp fftsph usage
    error('mat must not be empty');
  end
end


[nbth, nbph] = size(mat);
if (rem(nbth,2) ~= 1)
  error(['fftsph: the height of the grid (number of theta) must be' ...
	 ' odd']);
end

%% The order of the transform
L = getopts(varargin , 'L', (nbth-1)/2); 

%% Caching SH options
cache = getopts(varargin, 'cache', [], 1);

%% The equiangular grid
[phi, theta] = meshgrid( ...
    vect(0, 2*pi, nbph, 'open'), vect(0, pi, nbth));

%% The clenshaw-Curtis weight
w  = 4*pi*sphweight(nbth,nbph);

%% If axisymmetric function, m=0 and out is a vector!
isaxi = getopts(varargin, 'axisym', [], 1);

if (isaxi)
  out = zeros(1,L+1);
else
  out = zeros(L+1,2*L+1);
end

%% The processing
for l = 0:L,
  
  if (isaxi)
    kvec = 0;
  else
    kvec = -l:l;
  end
  
  for k = kvec,
    if (cache)
      mask_fname = sprintf('%sfftsph_%i_%i_%i_%i.mat',tempdir,nbth,nbph,l,k);

      if (~exist(mask_fname, 'file'))
	mask = yaspharm(theta, phi, l, k);
	save(mask_fname,'mask');
      else
	load(mask_fname);
      end
    else
      mask = yaspharm(theta, phi, l, k);
    end
    
    coeff = w .* conj(mask) .* mat;
    
    if (isaxi)
      out(l+1) = sum(coeff(:));
    else
      out(l+1,k+l+1) = sum(coeff(:));
    end
  end
  
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
