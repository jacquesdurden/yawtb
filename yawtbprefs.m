% \manchap
%
% Set all the preferences of YAWtb
%
% \mansecSyntax
%
% yawtbsetprefs()
%
% \mansecDescription
%
% Determined all the user preferences of the YAWtb behaviour
%
% \mansecSeeAlso
%
% setappdata getappdata
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/yawtbprefs.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% === YASHOW ===

%% === CWT1D ===

%% === CWT2D ===

%% === CWT3D ===

%% === CWTSPH ===

%% === FWT2D ===

%% == DFWT2D ===

%% === YAPBAR ===

%% Determined the display mode of the yapbar
%% Possible values are 'graphic' or 'text'
yawtbPrefs.yapbarMode = 'graphic';

%% Determined if all the yawtb progress bar must be displayed
%% Possible values are 'off' or 'on'
yawtbPrefs.yapbarVisible = 'on';


%% === PREFERENCES RECORDING ===

%% Recording the preferences
setappdata(0,'yawtb',yawtbPrefs);

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
