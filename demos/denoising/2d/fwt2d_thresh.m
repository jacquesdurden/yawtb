function wav = fwt2d_thresh(wav, thresh, varargin)
% \manchap
%
% \mansecSyntax
%
% [] = fwt2d\_thresh()
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
% $Header: /home/cvs/yawtb/demos/denoising/2d/fwt2d_thresh.m,v 1.1 2003-08-14 11:50:18 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

highthresh = getopts(varargin, 'highcorr', 3/2)*2*thresh;

oyap = yapbar([],(wav.J+1)*wav.K);

for n = 1:wav.K,
  wav.high{n} = yathresh(wav.high{n},highthresh,'absolute',varargin{:});
  oyap = yapbar(oyap, '++');
end

for s = 1:wav.J,
  for n = 1:wav.K,
    wav.wav{s,n} = yathresh(wav.wav{s,n},thresh/wav.sc(s),'absolute',varargin{:});
    oyap = yapbar(oyap, '++');
  end
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
