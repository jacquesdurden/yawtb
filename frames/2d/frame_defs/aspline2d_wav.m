function out = aspline2d_wav(kx,ky, nang, voice, order)
% \manchap
%
% 2D Angular Spline Wavelet
%
% \mansecSyntax
%
% [] = aspline\_app()
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
% $Header: /home/cvs/yawtb/frames/2d/frame_defs/aspline2d_wav.m,v 1.4 2004-11-05 08:19:40 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (isempty(kx))
  out = {'voice', 1, 'order', 2};
  return;
end

mod_k = abs(kx + i*ky);
arg_k = angle(kx + i*ky);
sqr2  = 2^.5;
arp   = 2*pi/nang;
dil   = 2^((order+1)/(2*voice))/pi;

out = yaspline(voice*log2(dil*mod_k + eps), order);
out = out .* ( ...
    yaspline( (arg_k - 4*pi)/arp, order) + ...
    yaspline( (arg_k - 2*pi)/arp, order) + ...
    yaspline( (arg_k       )/arp, order) + ...
    yaspline( (arg_k + 2*pi)/arp, order) + ...
    yaspline( (arg_k + 4*pi)/arp, order) );
    

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
