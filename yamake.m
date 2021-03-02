function yamake(exec_mode)
% \manchap
% 
% Create all the mex files needed by yawtb 
%
% \mansecSyntax
%
% yamake(['debug']) 
%
% \mansecDescription
%
% This function creates all the mex files needed by yawtb. 
% It parses all the yawtb subdirs and compiles C files like described
% into a file called ".to\_compile" related to each subdir.
% 
% \mansubsecInputData
% \begin{description}
% \item['debug'] [BOOLEAN]: set on the debug mode and display the
% information about all the compilations.
% \end{description}
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/yamake.m,v 1.22 2006-08-02 07:29:08 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Debug mode
global debug;

%% Mex options
global yawtb_include;
global matlab_version;

if exist('exec_mode')
  debug = strcmp(lower(exec_mode),'debug');
else
  debug = 0;
end

global olddir
olddir = pwd;

global lastsuccess;
lastsuccess = 1;

if (check_yadir(pwd))
  
  %% Setting the yawtb include mex option
  %% This is compatible with Windows (& perhaps MAcOS)
  %% with the filesep variable
  yawtb_include = ['-I"' pwd filesep 'include"'];
  
  %% Setting the version of matlab
  %% It is more simple to write 
  %%   matlab_version = disp(['-DMATLAB ' version_number(1)]);
  %% but the following code can be more easily changed for extra checkings.
  version_number = version;
  switch version_number(1)
   case '4',
    error('Sorry, Matlab v4 is not supported by the YAWtb!');
   case '5',
    matlab_version='-DMATLAB5';
   case {'6','7'},
    if (strcmp(version_number(1:3),'6.0'))
      matlab_version='-DMATLAB6 -DMTLBR12';
    else
      matlab_version='-DMATLAB6 -DMTLBR13';
    end
   otherwise
    error('Sorry, unrecognized Matlab version!');
  end
  
  
  disp('Compiling all the YAWtb mex files:');
  parse_yadir(pwd);
  if (~lastsuccess)&(~debug)
    disp('... abort.');
  else
    disp('... done.');
  end
    
end

cd(olddir);

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
global yawtb_include;
global matlab_version;
global olddir;
global lastsuccess;

result = dir(dirname);

for k = 1:length(result)
  
  cname  = result(k).name;
  cisdir = result(k).isdir;
  
  if ( (cisdir) & (~strcmp(cname,'.')) & (~strcmp(cname, '..')) )
    parse_yadir([ dirname filesep cname ]);
    
  elseif (strcmp(cname,'.to_compile'))
    
    file_id = fopen([ dirname filesep cname ]);
    
    cd(dirname);	
    
    linenb = 0;
    while 1
      linenb = linenb + 1;
      
      cline = fgetl(file_id);
      if ~ischar(cline) break, end
      
      if ~strcmp(cline(1:3),'mex') 
	if debug
	  disp(['Line ' num2str(linenb) ' of .to_compile in ' ... 
		dirname ' is not valid.']);
	  disp('Compilation is stopped.');
	end
	break
      end
      
      cline = [ cline ' ' yawtb_include ' ' matlab_version ];
      if (debug)
	disp(['in ' dirname ':']);
	
	%% Trying to compile
	lasterr(''); %% Resetting lasterr
	try
	  eval(cline);
	end
	
	%% Handling eventuel errors
	if (strcmp(lasterr,''))
	  disp([ '-> ' cline ' [OK]']);
	else
	  disp([ '-> ' cline ' [FAILED]']);
	  lastsuccess = 0;
	end
	
      else
	lasterr(''); %% Resetting lasterr
	try
	  eval(cline);
	catch
	  disp(['Error in compiling: ' cline]);
	  cd(olddir);
	  lastsuccess = 0;
	  return;
	end
      end
      
      
    end
    fclose(file_id); 
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
