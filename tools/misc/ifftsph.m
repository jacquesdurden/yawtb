function out = ifftsph(fmat, theta, phi, varargin)
% \manchap
%
% Inverse Spherical Harmonic Transform
%
% \mansecSyntax
%
% [out] = ifftsph(fmat, theta, phi)
%
% \mansecDescription
%
% Compute the inverse Spherical Harmonics transform.
%
% \mansubsecInputData
% \begin{description}
% \item[fmat] [MATRIX]: The SPherical Harmonics coeffcients, for
% instance the result of fftsph.
%
% \item[theta, phi] [MATRICES]: the equiangular grid in
% latitude-longitude coordinate where the function is defined. The
% size of this grid must be (2M+1)xN with an odd number of latitudes.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the rebuilt function.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% Creating the equiangular spherical grid
% >> [phi, theta] = meshgrid(vect(0,2*pi,32,'open'), vect(0,pi,17));
% >> %% Creating a function
% >> mat = yaspharm(theta, phi, 3,2) + yaspharm(theta, phi, 5,0);
% >> figure; yashow(mat, 'spheric', 'relief', 'mode', 'real');
% >> %% Computing the SH transform
% >> tmat = fftsph(mat);
% >> nmat = ifftsph(tmat, theta, phi);
% >> yapsnr(mat,nmat)
% >> figure; yashow(nmat, 'spheric', 'relief', 'mode', 'real');
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% fftsph, sphweight, yaspharm.
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/ifftsph.m,v 1.1 2003-08-18 10:55:34 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

cache = getopts(varargin, 'cache', [], 1);

isaxi = (size(fmat,1) == 1);
out = 0;

if (isaxi)
  L = size(fmat,2) - 1;
else
  L = size(fmat,1) - 1;
end

[nbth, nbph] = size(theta);

for l = 0:L,
  if (isaxi)
    kvec = l+1;
  else
    kvec = 1:(2*l+1);
  end
  
  for k = kvec,
    if (cache)
      mask_fname = sprintf('%sfftsph_%i_%i_%i_%i.mat', ...
			   tempdir, nbth, nbph, l, k - l -1);

      if (~exist(mask_fname, 'file'))
	mask = yaspharm(theta, phi, l, k - l - 1);
	save(mask_fname,'mask');
      else
	load(mask_fname);
      end
    else
      mask = yaspharm(theta, phi, l, k - l - 1);
    end
    
    if (isaxi)
      out = out + mask*fmat(l+1);
    else
      out = out + mask*fmat(l+1,k);
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
