function setyawtbprefs(property, value)
% \manchap
%
% Set a YAWtb preference
%
% \mansecSyntax
%
% setyawtbpref(property\_name, value)
%
% \mansecDescription
%
% Set the property named 'property\_name' in YAWtb preference to 'value'
% This property must exist.
%
% \mansubsecInputData
% \begin{description}
% \item[property\_name] [STRING]: The name of the property
% \item[value] [MISC]: The new value
% \end{description} 
%
% \mansecSeeAlso
%
% getyawtbprefs
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/setyawtbprefs.m,v 1.2 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

yawtbPrefs = getappdata(0, 'yawtb');
if isfield(yawtbPrefs,property)
  yawtbPrefs = setfield(yawtbPrefs, property, value);
  setappdata(0, 'yawtb', yawtbPrefs);
else
  error('Unknown YAWtb property.');
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
