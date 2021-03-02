function [opts,listopts] = yawopts(listopts,funcname)
% \manchap
% 
% Return the options to give to a yawtb mfile (internal use)
%
% \mansecSyntax
% opts = yawopt(listopts,funcname)
%
% \mansecDescription
%
% Return the options to give to a yawtb mfile (internal use) by
% comparing a list of parameters given in the list
% \libvar{listopts} with the default values returned by the
% 'funcname([])'.
%
% The syntax of \libvar{listopts} is 
%    {'name\_1', value\_1, 'name\_2', value\_2, ...}
% The syntax of the list returned by 'funcname([])' is the same with
% the following particularities:
% \begin{itemize}
% \item if a 'value\_j' is a string  '*name\_l', it mean that this
% value is by default equal to this of 'name\_l';
% \item if 'value\_j' is a string identical to 'name\_j', it means
% that 'name\_j' is a boolean flag which is absent by default.
% \end{itemize}
%
% \mansubsecInputData
% \begin{description}
% \item[listopts] [CELL]: the list os the user parameter;
% \item[funcname] [STRING]: the name of the function to test.
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[opts] [CELL]: the list of argument for funcname;
% \item[listopts] [CELL]: the input \libvar{listopts} without the
% parameter of the function funcname.
% \end{description} 
%
% \mansecSeeAlso
% getopts
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yawopts.m,v 1.11 2007-09-20 13:13:15 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Determining the funcname parameters
func = str2func(funcname);
func_par_list = func([]);
func_lg_par_list = length(func_par_list);

if rem(func_lg_par_list,2)
  error(['Incorect number of elements inside the parameter list of ' ...
	 funcname]);
end

if (func_lg_par_list == 0)
  opts = {};
  return;
end

parameter = func_par_list(1:2:func_lg_par_list); %% Parameters names
value  = func_par_list(2:2:func_lg_par_list); %% Parameters dflt val
  
%% In the case where we have ordered wavelet parameters value
%% list inside listopts ('list_elem' is part of yawtb)
if isnumeric(list_elem(listopts,1,'')) 
  for l = 1:(func_lg_par_list/2)
    %% opts{l} is equal to listopts{l} if it exists, or
    %% value{l} if not. 
    opts{l} = list_elem(listopts,l,value{l});
  end
  
  %% else if we have a named wavelet parameters list
  %% ('getopts' is a part of yawtb)
else 
  old_listopts = listopts;
  for l = 1:(func_lg_par_list/2)
    %% getopts parses listopts to seek the value in front of 
    %% the wavelet parameter name (see help part above).
    %% If not found, the default value accorded to wavopts(l)
    %% is simply value{l}.
    
    if (ischar(value{l})) 
      %% If value == parameter, this is a boolean
      if (strcmp(parameter{l},value{l}))
	[opts{l},listopts] = ... 
	    getopts(listopts,parameter{l},[],1);
	
	%% If value begins with *, it is link to other value
      elseif (value{l}(1) == '*')
	par_link = value{l}(2:length(value{l}));
	[opts{l},listopts] = ... 
	    getopts(listopts,parameter{l}, ...
			     getopts(old_listopts,par_link, ...
						  getopts(func_par_list,par_link,[])));
      else %% Value is simply a char
	[opts{l},listopts] = ... 
	    getopts(listopts,parameter{l},value{l});
      end
    else %% else, parameter{l} (dflt value{l}) is the correct value
      [opts{l},listopts] = ... 
	  getopts(listopts,parameter{l},value{l});
    end
  end
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
