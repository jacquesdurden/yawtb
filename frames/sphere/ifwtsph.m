function out = ifwtsph(fwt, varargin)
% \manchap
%
% WITHOUT ITERATIVE METHODS SUCH AS THE CONJUGATED GRADIENT METHODS, 
% IFWTSPH OR IFFWTSPH DO NOT PROVIDE PERFECT RECONSTRUCTION 
% BUT JUST APPROXIMATION (see sphcg.m for more informations).
% Inverse Framed Wavelet Transform approximation on the sphere
%
% \mansecSyntax
%
% out = ifwtsph(fwt)
%
% \mansecDescription
%
% Compute an approximation of the rebuilding of the spherical data
% using the same wavelet for the reconstruction than for the
% analysis.
%
% \mansubsecInputData
% \begin{description}
% \item[fwt] [STRUCT]: the result of the framed wavelet tranform
% obtain with fwtsph.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the rebuilt spherical signal
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world
% >> yashow(mat, 'spheric', 'fig', 1);
% >> wav = fwtsph(mat, 'dog'); %% It's time to drink a cup of coffee!
% >> nmat = ifwtsph(wav);
% >> yashow(nmat, 'spheric', 'fig', 2);
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
% $Header: /home/cvs/yawtb/frames/sphere/ifwtsph.m,v 1.3 2007-01-15 09:18:01 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Warning: nth is such that log2(nth -1) is an integer 

%% Misc initializations
a = fwt.a;
nth = fwt.nth;
nph = fwt.nph;
th_step = fwt.th_step;
ph_step = fwt.ph_step;

th_vec = vect(0, pi, nth);
ph_vec = vect(-pi, pi, nph, 'open');

[ph, th]    = meshgrid(ph_vec,th_vec);

%% Spherical coordinates on sphere:
x      = sin(th).*cos(ph); 
y      = sin(th).*sin(ph);
z      = cos(th);

%% Convolutions
out = 0;

nj = length(fwt.jv) - 1;
oyap = yapbar([], nj*nth);

for j = 1:nj,
  %% Computing the frame weigth to use in the rebuilding
  da_a3 = abs(a(j+1)-a(j)) / a(j)^3;
  weight = pi * da_a3 * sphweight(size(fwt.data{j},1), ...
				  size(fwt.data{j},2));
  
  %% Upsampling of the frame coefficient
  coeff = zeros(nth, nph);
  coeff(1:th_step(j):end,1:ph_step(j):end) = fwt.data{j} .* weight;
  

  %% 1D FFT transform of the matrix mat. No, it is'nt an error
  fcoeff  = fft(coeff,[],2);
  
  for k = 1:nth,
    %% Determing the center of the wavelet
    xc = sin(th_vec(k));
    yc = 0;
    zc = cos(th_vec(k));
      
    %% Call of the wavelet function through 'feval'.
    mask = feval(fwt.wavname, x,y,z, xc,yc,zc, a(j),0, fwt.wavopts{:});
    
    %% 1D FFT of mask
    fmask = fft(mask,[],2);
    
    %% The kth row of the final result (the spherical wavelet
    %% transform) is equal to the row convolution
      
    tmpout(k,:)  = fftshift(sum(ifft(fcoeff .* fmask, [], 2)));
    
    oyap = yapbar(oyap, '++');
  end
  
  out = out + tmpout;
          
end
oyap = yapbar(oyap, 'close');


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
