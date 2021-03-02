function yademo(yafile)
% \manchap
%
% Execute the demo associates to a yawtb file
%
% \mansecSyntax
%
% yademo(yafile)
% yademo yafile
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[yafile] [STRING]: the name of this file.
% \end{description} 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/help/yademo.m,v 1.7 2002-11-28 17:34:35 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)


%% Initializations

codefun = yahelp(yafile,'example');

if isempty(codefun)
  disp('No documented example for this function');
end

%% Processing
codefun = strrep(codefun, 'EXAMPLE', ['% Sample(s) of code for ' upper(yafile)]);

pos_exec = [strfind(codefun, '>>') length(codefun)];
nb_exec = length(pos_exec) - 1;

begin_char = 1;

%% Possible bug: if the evaluated subcode contains variables 
%% with the same name than in the proper yademo code.
%% Hence the name 'the_k' for the main counter.
for the_k = 1:nb_exec,
  
  codeless = codefun(begin_char:(pos_exec(the_k)-1));
  if any(double(codeless) ~= 32)
    codeless = strrep(codeless,char(10), [char(10) '%']);
    disp(codeless(1:end-1));
  end  
  
  subcode = codefun(pos_exec(the_k):end);
  
  %% Finding possible ellipse ...
  pos_ell = strfind(subcode,'...');
  pos_ell = pos_ell(pos_ell < (pos_exec(the_k+1) - pos_exec(the_k) - 1));
  if isempty(pos_ell)
    last_ell = 0;
  else
    last_ell = pos_ell(end);
  end
  
  pos_ln = strfind(subcode,char(10));
  pos_ln = pos_ln(pos_ln > last_ell);
  first_ln = pos_ln(1 + ~~last_ell);
  
  subcode = subcode(1:(first_ln(1)-1));
  fprintf([subcode ' %%%% <press any key>']);
  pause;
  fprintf('\n');
  
  eval(subcode(3:end));

  begin_char = pos_exec(the_k) + first_ln(1) + 1;
end

codeless = codefun(begin_char:end);
if any(double(codeless) ~= 32)
  codeless = strrep(codeless,char(10), [char(10) '%']);
  disp(codeless(1:end-1));
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
