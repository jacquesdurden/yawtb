function yasave(varargin)
% \manchap
%
% save and ask for informations to include in data
%
% \mansecSyntax
%
% yasave FILENAME data1 data2
%
% \mansecDescription
%
% This function saves data exactly as the builtin save matlab
% function does, but in addition, prompts for a little explanation
% introduce in the data by the variable yasave\_info.
%
% \mansubsecInputData
% \begin{description}
% \item[FILENAME] [STRING]: the name of you file as for matlab save function
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> yasave something\_to\_delete
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
% $Header: /home/cvs/yawtb/tools/misc/yasave.m,v 1.4 2003-09-01 12:11:15 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

data = cell(1,2*length(varargin));
[data{1:2:end}] = deal(varargin{1:end});
[data{2:2:end}] = deal(' ');
save_command = ['save ' data{:} ' yasave_info'];

evalin('base', ['yasave_info=inputeof(''Introduce here some information' ...
		' about your data (finish by typing EOF<enter>):\n'');']);
fprintf('Recording... ');
evalin('base', save_command);
evalin('base', 'clear yasave_info;');
fprintf('done.\n');


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
