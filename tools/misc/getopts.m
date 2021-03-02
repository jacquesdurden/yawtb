function [val, NewOptionList] = getopts(OptionList,OptionName,OptionDefaultValue,HasNoValue)
% \manchap
% 
% Return the value of the 'OptionName' variable inside list 'OptionList'.
%
% \mansecSyntax
% [val, NewOptionList] = getops( OptionList, 'OptionName' ... 
% 			        [, OptionDefaultValue [,HasNoValue] ])
%
% \mansecDescription
% 
% Return the value of the 'OptionName' variable inside list
% 'OptionList' and return a list NewOptionList without this option.
%
% If this variable is not present, val is empty unless a
% OptionDefaultValue is given.
%
% If HasNoValue is set to 1, val is set to 1 if OptionName is find,
% and 0 if not.
%
% \mansubsecInputData
% \begin{description}
% \item[OptionList] [LIST] The list of options and value. Its syntax
% follows the pattern: {'OPT1', VAL1, 'OPT2', VAL2, ...};
%
% \item[OptionName] [STRING] The option to seek inside OptionList;
%
% \item[OptionDefaultValue] [MISC] The default value to give at val
% if none is detected.
%
% \item[HasNoValue] [BOOL] Flag set to 1 if OptionName has no
% value (flag case).
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[val] [MISC] the output value.
%
% \item[NewOptionList] [LIST] the new list of options without the
% option 'OptionName'.
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [val,list] = getopts({'sigma', 1, 'rho', 2.3},'rho',7)
% >> val = getopts({'sigma', 1, 'radian'},'radian',[],1)
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
% $Header: /home/cvs/yawtb/tools/misc/getopts.m,v 1.7 2003-08-12 10:40:44 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~iscell(OptionList)
  OptionList = {OptionList};
end

if (size(OptionList,1) > 1)
  OptionList = OptionList';
  OptionList = {OptionList{:}};
end

if (nargin < 2 | nargout > 2)
  error('Argument Mismatch - Check Command Line');
end

if ~exist('HasNoValue')
  HasNoValue = 0;
else
  HasNoValue = ( HasNoValue ~= 0);
end

%% Lowering all strings contained in OptionList
NumbOptions = length(OptionList);
for k = 1:NumbOptions,
  if isstr(OptionList{k})
    OptionList{k} = lower(OptionList{k});
  end
end

%% Processing
OptionName = lower(OptionName);

for k = 1:NumbOptions,
  if strcmp(OptionList{k}, OptionName)
    
    if ((k+1-HasNoValue) < NumbOptions)
      NewOptionList = { OptionList{1:(k-1)} ...
			OptionList{(k+2-HasNoValue):NumbOptions}};
    elseif (k > 1)
      NewOptionList = { OptionList{1:(k-1)} };
    else
      NewOptionList = {};
    end
    
    if HasNoValue
      val = 1;
    else
      if (k < NumbOptions)
	val = OptionList{k+1};
      else
	val = [];
      end
    end
    return;
  end
end

if HasNoValue
  val = 0;
else
  if exist('OptionDefaultValue')
    val = OptionDefaultValue;
  else
    val = [];
  end
end

NewOptionList = OptionList;

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
