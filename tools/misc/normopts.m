function [out] = normopts(list)
% \manchap
%
% Reject to the end of list the options charaterized by a string.
%
% \mansecSyntax
% [out] = normopts(list)
%
% \mansecDescription
%
% Reject to the end of list 'list' the options
% charaterized by a string. So {1,2, 'Opt', OptVal, 4,3} will be 
% turn into {1,2,4,3, 'Opt', OptVal}.
%
% \mansubsecInputData
% \begin{description}
% \item[list] [LIST] the input options list. 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [LIST] the output list.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> out = normopts({'sigma',6, 1,pi})\\
% out =
%      [1] [3.1416] 'sigma' [6]
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% getopts
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/normopts.m,v 1.4 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~iscell(list)
  out = list;
  return;
end

Lg = length(list);

for k = 1:Lg,
  if ~isnumeric(list{k})
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
