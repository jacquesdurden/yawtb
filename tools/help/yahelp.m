function out = yahelp(yafile, section)
% \manchap
%
% Display the help associated to a yawtb file.
%
% \mansecSyntax
%
% yahelp yafile
% yahelp(yafile [,section] )
%
% \mansecDescription
%
% YAHELP display a userfriendly help of any yawtb function.
%
% \mansubsecInputData
% \begin{description}
%
% \item[yafile] [STRING]: the name of this file.
%
% \item[section] [SET OF STRING]: tells to yahelp which part of the
% help must be displayed. Type yahelp([]) to obtain a complete list
% of the available sections.
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> yahelp yashow
% >> yahelp yashow syntax
% \end{code}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/help/yahelp.m,v 1.8 2003-06-16 07:35:22 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Input manipulations

if ~exist('yafile')
  yafile = 'yahelp';
end

if ~exist('section')
  section = '';
else
  section = upper(section);
end

%% Elements to replace
actions = {	...
%%  PATTERN                  REPLACEMENT 
    ['\manchap' char([10 32 10])], upper(yafile), ...
    '\manchap',              upper(yafile), ...
    '\mansecSyntax',         'SYNTAX', ...
    '\mansecDescription',    'DESCRIPTION', ...
    '\mansubsecInputData',   'INPUTS', ...
    '\mansubsecOutputData',  'OUTPUTS', ...
    '\mansecExample',        'EXAMPLE', ...
    '\mansecReference',      'REFERENCE', ...
    ['\mansecSeeAlso' char([10 32 10])], 'SEE ALSO', ...
    '\mansecSeeAlso',        'SEE ALSO', ...
    '\mansecLicense',        'LICENSE:', ...
    '\begin{description}',   '', ...
    '\end{description}',     '', ...
    '\item[',                '* [', ...
    '\begin{itemize}',       '', ...
    '\end{itemize}',         '', ...
    '\item',                 '- ', ...
    '\begin{code}',          '', ...
    '\end{code}',            '', ...
    '\url{"',                '"', ... 
    '\libfun{',              '''', ...
    '\libvar{',              '''', ...
    '\',                     '', ...
    '$',                     ''  };

%% Possible marks. Order is important.
marks = { 'USAGE', 'SYNTAX', 'DESCRIPTION', ...
	     'INPUTS', 'OUTPUTS', 'CODE', 'EXAMPLE', ...
	     'REFERENCE', 'SEE ALSO', 'LICENSE' };

if rem(length(actions),1)
  error('Check your actions of replacement');
end;


%% Recording standard help
helpfun = help(yafile);

%% Adding some pattern replacements for other section than 'CODE'.
%% In this latter for instance, '{' make sense.
if ((~strcmp('CODE',section)) & (~strcmp('EXAMPLE',section)))
  actions = { actions{:}, ...
	      '{"',                    '"', ...
	      '{',                     '''', ...
	      '"}',                    '"', ...
	      '}',                     '''' };
end
  
%% Processing
for k=1:2:length(actions)
  helpfun = strrep(helpfun, actions{k}, actions{k+1});
end

%% Possible marks
if isempty(section)
  %% Removing License specification
  helpfun(strfind(helpfun,'LICENSE'):end) = '';
else
  if ~any(strcmp(marks,section))
    error('This section is not valid');
  end
  
  %% Possible synonyms
  switch section
   case 'USAGE' 
    section = 'SYNTAX';
   case 'CODE'
    section = 'EXAMPLE';
  end
  
  first = strfind(helpfun, section);
  
  if isempty(first)
    if (nargout == 1)
      out = '';
    end
    return;
  end
  
  section_id = find(strcmp(marks,section));
  section_id = section_id(1);
  nb_sections = length(marks);
  
  last = [];
  k = 1;
  while isempty(last) & ((section_id + k) < nb_sections)
    next_section = marks{section_id+k};
    last  = strfind(helpfun, next_section);
    k = k + 1;
  end
  
  if isempty(last)
    helpfun = helpfun(first:end);
  else
    helpfun = helpfun(first:last-1);
  end
end

if (nargout == 1)
  out = helpfun;
else
  disp(helpfun);
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
