function out = ifwt2d(obj)
% \manchap
%
% 2D inverse framed wavelet transform
%
% \mansecSyntax
%
% out = fwt2d( yastruct, ['import', import] );
%
% \mansecDescription
%
% \libfun{fwt2d} computes the 2D inverse Framed Wavelet Transform
% on the basis of the fwt2d's result.
% 
% \mansubsecInputData
% \begin{description}
% \item[yastruct] [STRUCT]: the result of \libfun{fwt2d}
%
% \item[import] [STRING]: can be 'app', 'wav' or 'rem' and allow
% \libfun{ifwt2d} to rebuild only respectively the approximation,
% the wavelet coefficient or the high frequency remainder.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the reconstructed image.
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
% $Header: /home/cvs/yawtb/frames/2d/ifwt2d.m,v 1.11 2003-12-19 22:59:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Initialization
oyap = yapbar([],obj.nsc*obj.K + obj.K + 1);


%% Rebuilding the approximation
out = ifwt2d_app(obj);
oyap = yapbar(oyap, '++');

%% Rebuilding the high frequency residual
if (obj.ismultisel)
  Kl = log2(obj.Ks(end));
  
  for l = 0:Kl,
    tmpout = 0;
    for th = 2^l:(2^(l+1)-1),
      tmpout = tmpout + ifwt2d_high(obj, th);
      oyap = yapbar(oyap, '++');
    end
    goodpt = (obj.lmax_high == l);
    out(goodpt) = out(goodpt) + tmpout(goodpt);
  end
  
else
  for th = 1:obj.K  
    out = out + ifwt2d_high(obj, th);
    oyap = yapbar(oyap, '++');
  end
end

%% Rebuilding from wavelet coefficients
if (obj.ismultisel)
  for s = 1:obj.nsc
    for l = 0:Kl,
      tmpout = 0;
      for th = 2^l:(2^(l+1)-1),
	tmpout = tmpout + ifwt2d_wav(obj,s,th);
	oyap = yapbar(oyap, '++');
      end
      goodpt = (obj.lmax(:,:,s) == l);
      out(goodpt) = out(goodpt) + tmpout(goodpt);
    end
  end
else
  for s = 1:obj.nsc
    for th = 1:obj.K
      out = out + ifwt2d_wav(obj,s,th);
      oyap = yapbar(oyap, '++');
    end
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
