function value = getyawtbprefs(property)
% \manchap
%
% Get the YAWtb preferences
%
% \mansecSyntax
%
% getyawtbpref
% properties = getyawtbpref
% value = getyawtbpref('property\_name')
%
% \mansecDescription
%
% Get the YAWtb preferences.
% This command display all the YAWtb properties
%       getyawtbprefs
% The following command return all the pereferences in  'properties'
%       properties = getyawtbpref 
% To select only one property enter
%       value = getyawtbpref('property\_name')
% Value is set to [] if the property doesn't exist.
% 
% \mansubsecInputData
% \begin{description}
% \item[property\_name] [STRING]: the name of the desired property.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[properties] [STRUCT]: a structure with all the properties
% for fields and their corresponding values.
% \item[value] [MISC]: the value of the property (empty if not existing)
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> getyawtbprefs
% >> getyawtbprefs('yapbarVisible')
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% setyawtbprefs
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/getyawtbprefs.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

yawtbPrefs = getappdata(0, 'yawtb');

if (nargin == 0)
  if nargout == 0
    disp(yawtbPrefs);
  else
    value = yawtbPrefs;
  end
elseif isfield(yawtbPrefs, property)
  value = getfield(yawtbPrefs, property);
else
  value = [];
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
