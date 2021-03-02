function out = aspline2d_app(kx,ky, voice, order)
% \manchap
%
% \mansecSyntax
%
% [] = aspline2d\_app()
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
% $Header: /home/cvs/yawtb/frames/2d/frame_defs/aspline2d_app.m,v 1.5 2004-11-05 08:19:40 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (isempty(kx))
  out = {'voice', 1, 'order', 3};
  return;
end

mod_k = abs(kx + i*ky);
dil = 2^(order/(2*voice))/pi;
sqr2 = 2^.5;
log2_mod_k = voice*log2(dil*mod_k + eps);

out = zeros(size(mod_k));
[tmp1,tmp2] = meshgrid(log2_mod_k(:), 1:order);
out(:) = sum(yaspline(tmp1 + tmp2, order),1);
out = max( log2_mod_k < (-order/2 - 0.5), out);


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
