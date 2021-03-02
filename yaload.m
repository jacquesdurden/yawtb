function yaload(exec_mode)
% \manchap
%
% Load the YAWtb path into memory 
%
% \mansecSyntax
%
% yaload(['debug'])
%
% \mansecDescription
%
% This function place all the YAWtb path into memory
%
% \mansubsecInputData
%
% \begin{description}
% \item['debug'] [BOOLEAN]: set on the debug mode and display the
% information about all the path addings.
% \end{description}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/yaload.m,v 1.10 2006-08-02 07:29:08 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Debug mode
global debug;

if exist('exec_mode')
  debug = strcmp(lower(exec_mode),'debug');
else
  debug = 0;
end

%% Check first if the root directory is the yawtb one.
if (check_yadir(pwd))
  disp('Installing the YAWtb path:  ');
  parse_yadir(pwd);
  disp('... done.');
end


function yacheck = check_yadir(dirname)
% Check if dirname is the YAWtb's root dir
result = dir(dirname);

yacheck = 0;
for k = 1:length(result)
  cname  = result(k).name;
  if (strcmp(cname,'null.is_yawtb_root'))
    yacheck = 1;
  end
end 

if ~yacheck
  disp('You are not in the YAWtb''s root directory');
end


function parse_yadir(dirname)
% Parse all the subdir and research null.is_in_mpath
global debug;

result = dir(dirname);

for k = 1:length(result)
  
  cname  = result(k).name;
  cisdir = result(k).isdir;
  
  if ( (cisdir) & (~strcmp(cname,'.')) & (~strcmp(cname, '..')) )
    parse_yadir([ dirname filesep cname ]);
    
  elseif (strcmp(cname,'null.is_in_mpath'))
    if (debug)
      disp(['Adding ''' dirname ''' to PATH']);
    end
    addpath(dirname);
  end
  
end 

%% Loading the YAWtb preferences
yawtbprefs

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
