function obj = fwt2d(varargin)
% \manchap
%
% 2D framed wavelet transform
%
% \mansecSyntax
%
% obj = fwt2d( tI, framename, J, K, ...
%              [, 'scbase', scbase] [, 'scfirst', scfirst] ...
%              [, 'sc', sc ], [, 'ang', ang ] [, 'multisel'] ...
%              [, 'FrameOptionName', FrameOptionValue] ...
%              [, 'export', export ] )
%
% \mansecDescription
%
% \libfun{fwt2d} computes and returns the 2D framed wavelet
% transform, or frame decomposition, of an image, 
% that is the coefficients:
% \begin{verbatim}
% App      =  I * PHI[a\_J]
% Wav[j,k] =  I * PSI[a\_j, \theta\_k]
% \end{verbatim}
% where * is the convolution operator,
%       $j = 1..J$, $k = 1..K$, 
%       $a_j = a_0*p^(j-1)$ for a first scale $a_0$ and a base $p$, 
%       $\theta_k = k*2*pi/K$.
%
% The frame scheme, that is the set of of functions $PHI$, $PSI$
% and $CHI$, may be chosen among the
% ones defined in the subdirectory 'frame\_defs'. Notice that in
% this directory, to one kind of frame correspond always three
% functions: 
% \begin{itemize}
% \item '<framename>\_app' for the low frequency approximation
% \item '<framename>\_wav' for the wavelet definition
% the decomposition.
% \end{itemize}
% 
% \mansubsecInputData
% \begin{description}
% \item[tI] [CPLX ARRAY]: the Fourier transform of the image to
% analyze;
%
% \item[framename] [STRING]: the name of the frame to use;
%
% \item[J] [INTEGER]: the number of scales on which the frame is
% based;
%
% \item[K] [INTEGER|VECTOR]: in case of a directional frame, the
% number of sectors to use. If this number is different for each
% scale, it is allowed to enter a vector of length \libvar{J}
% representing the number of sectors for each scale from the first
% to the last one;
%
% \item[scbase] [REAL]: the base 'p' in the power law rule that
% governs the scales, i.e. $a_j = a_0 * p^(j-1)$;
%
% \item[scfirst] [REAL]: the first scale $a_0$ in the scale rule
% above. By default, this $a_0$ is set to 1/2 giving a complete
% covering of the frequency plane if the wavelet is contained in
% the ring -pi/2 <= abs(k) < pi;
%
% \item[sc] [VECTOR]: vector of scale indices between 1 and 'J'
% in which the decomposition must be restricted;
%
% \item[ang] [VECTOR]: vector of angle indices between 1 and 'K'
% in which the decomposition must be restricted;
%
% \item['multisel'] [BOOL]: multiselectivity support. K must be a
% power of 2. 
% 
% \item[export] [STRING]: could be 'app', 'wav', 'allwav', or 'rem'
% and involves respectively the computation of only the
% approximation, the wavelet coefficients or the high frequency
% remainder.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRUCT]: the output of the transform. It is a
% structure with the following fields:
% \begin{itemize}
% \item \libvar{out.type} [STRING]: transform type ('fwt2d')
% \item \libvar{out.app} [MATRIX]: the approximation
% coefficients;
% \item \libvar{out.wav} [CELL]: 2D list of 2D matrices where the
% wavelet coefficients are stored.
% \item \libvar{out.rem} [MATRIX]: matrix storing the
% high frequency remains coefficients
% \end{itemize}
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> %% Create the woman example
% >> load woman; tX = fft2(X);
% >> figure; yashow(X,'square','cmap','gray');
% >> %% Decompose mat on the Angular Spline frame of 3 scales and 6 angles
% >> fc = fwt2d(tX,'aspline',2,9);
% >> %% Displaying the approximation
% >> figure; yashow(fc.app, 'square');
% >> %% Displaying the wavelet coefficient for sc=1 and ang=2
% >> yashow(fc.wav{1,2}, 'square');
% >> %% Displaying the summation of all the frequency masks
% >> yashow(fftshift(fc.allwav), 'square');
% >> %% Rebuilding the matrix without the approximation
% >> fc.app = zeros(size(X));
% >> nX=ifwt2d(fc);
% >> %% Showing the result
% >> yashow(nX, 'square', 'cmap', 'gray');
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% aspline2d
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/2d/fwt2d.m,v 1.15 2003-12-19 22:59:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)


%% Initializations
obj = fwt2d_init(varargin{:});

%% Initializing the progress bar
oyap = yapbar([], obj.J*obj.sJ*obj.K + 2 + obj.K);

%% Computing the mask used in the reconstruction
obj = fwt2d_allwav(obj);
oyap = yapbar(oyap, '++');

%% Computing the approximation coefficients
obj = fwt2d_app(obj);
oyap = yapbar(oyap, '++');

%% Computing the high frequency residual coefficients
for th = 1:obj.K,
  obj = fwt2d_high(obj, th);
  oyap = yapbar(oyap, '++');
end

%% Reduce to the "Best Frame" in case of multiselectivity
if (obj.ismultisel)
  obj = fwt2d_high_msred(obj, varargin{:});
end

%% Computing the wavelet coefficients
for s = 1:obj.nsc,
  for th = 1:obj.K,
    obj = fwt2d_wav(obj, s, th);
    oyap = yapbar(oyap, '++');
  end
  
  %% Reduce to the "Best Frame" in case of multiselectivity
  if (obj.ismultisel)
    obj = fwt2d_wav_msred(obj, s, varargin{:});
  end
end

%% Closing the progress bar
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
