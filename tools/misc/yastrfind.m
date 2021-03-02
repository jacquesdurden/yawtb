function pos = yastrfind(str, substr)
% \manchap
%
% Find one string within another
%
% \mansecSyntax
%
% pos = yastrfind(str, substr)
%
% \mansecDescription
%
% This function is only there for internal use in the YAWtb
% functions. It solves the problem between the existence of strfind
% or findstr matlab built-in functions. If your matlab doesn't
% recognize strfind, you have only to change the code of this file
% (check it, it's easy).
%
% \mansubsecInputData
% \begin{description}
% \item[str] [STRING]: string where to search 'substr'
% \item[substr] [STRING]: string to search in 'str'
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[pos] [INT VECTOR]: vector of positions of 'substr' in
% 'str' computing from the first character of 'substr'. 'pos' is
% empty if 'substr' is not found.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> yastrfind('Hello world or hello planet?','or')
% \end{code}

% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yastrfind.m,v 1.2 2002-12-03 09:27:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

pos = strfind(str, substr);

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
