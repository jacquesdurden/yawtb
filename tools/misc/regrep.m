function out = regrep(pattern,replace,string)
% \manchap
%
% Perform a substring replacement on string using regular expression.
%
% \mansecSyntax
%
% out = regrep(pattern,replace,string)
%
% \mansecDescription
%
% This program performs the replacement of the substring 'pattern'
% into 'string' with 'replace'. The writting of the pattern follows
% the regular expression syntax. Remark: regrep uses the perl
% executable. 
%
% \mansubsecInputData
% \begin{description}
% \item[pattern] [STRING]: the pattern to search into string;
%
% \item[replace] [STRING]: the replacing word;
%
% \item[string] [STRING]: the string processed.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRING]: the resulting string.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> regrep('([a-z])e','a','hello')
% \end{code}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/regrep.m,v 1.2 2002-01-11 09:04:04 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if isunix
  string = strrep(string,'\','\\');
  string = strrep(string,'"','\"');
  string = strrep(string,'$','\$');
  [err, out] = unix(['perl -e ''' ...
		     '$tmp="' string '";' ...
		     '$tmp =~ s/' pattern '/' replace '/g;' ...
		     'print $tmp;''']);
elseif (strncmp(computer,'PC',2))
  %% TODO
  out = string;
else
  error('Unknown platform');
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
