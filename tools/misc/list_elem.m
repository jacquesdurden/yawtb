function out = list_elem(rec,k,def)
% \manchap
%
% Return the $k$-th element of rec if it exists.
%
% \mansecSyntax
% out = list\_elem(rec,k,def)
%
% \mansecDescription
% Return the $k$-th element of rec if exists. If not, default value
% def is returned. 
%
% \mansubsecInputData
% \begin{description}
% \item[rec] [LIST] the input list;
% \item[k] [INTEGER] the element index;
% \item[def] [MISC] default value.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] the $k$-th element.
% \end{description} 
%
% \mansecExample
%
% \mansecReference
%
% \mansecSeeAlso
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/list_elem.m,v 1.4 2001-10-21 21:04:15 coron Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Input test managing
if (nargin < 2) 
  error('Argument Mismatch - Check Command Line'); 
end

if ~exist('def')
  def = [];
end

if ~iscell(rec) 
  rec   = {rec};
end 

if (~isnumeric(k))|(rem(k,1)~= 0)|(k<=0) 
  error('''k'' must be a strictly positive integer'); 
end
  
%% Core
if (k <= length(rec))
  out = rec{k};
else
  out = def;
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
