function out = inputeof(msg)
% \manchap
%
% Work like input(msg,'s') but ends by a EOF
%
% \mansecSyntax
%
% out = inputeof(msg)
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[msg] [STRING]: your prompt message 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRING]: the text entered before the closing EOF
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> s=inputeof(['Enter something and terminate by typing ...
% EOF<enter> on a new line']);
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
% $Header: /home/cvs/yawtb/tools/misc/inputeof.m,v 1.2 2003-06-18 12:01:05 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

out = '';
line = input(msg, 's');
while ~strcmp(line,'EOF')
  if isempty(line)
    out = [out; repmat(' ',1,size(out,2))];
  else
    out = strvcat(out,line);
  end
  line = input('', 's');
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
