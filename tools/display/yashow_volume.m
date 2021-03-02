function yashow_volume(vol, varargin)
% \manchap
%
% Display a volume
%
% \mansecSyntax
%
% yashow\_volume( vol [,'x', x] [,'y', y] [,'z', z] ...
%                [,'square'] [,'equal'] ...
%                [,'levels', levels] [,'color', color] [,'alpha', alpha])
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[] []: 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[] []:
% \end{description} 
%
% \mansecExample
% \begin{code}
% >>
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
% $Header: /home/cvs/yawtb/tools/display/yashow_volume.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)


[ox,varargin] = getopts(varargin,'x',1:size(vol,2));
[oy,varargin] = getopts(varargin,'y',1:size(vol,1));
[oz,varargin] = getopts(varargin,'z',1:size(vol,3));

%% Number of levels to display
[levels,varargin] = getopts(varargin,'levels',1);

%% The color of the surfaces
[color,varargin] = getopts(varargin,'color','blue');

%% Miscellaneous initializations
[nrow,ncol,ndepth] = size(vol);
mvol   = min(min(min(vol)));
Mvol   = max(max(max(vol)));

if (levels > 1)
  defalpha  = 0.1;
  values = vect(mvol,Mvol,levels,'rlopen');
else
  values    = (mvol + Mvol)/2;  
  defalpha  = 1;
end

%% Overloading values if levels are set manually
[manual_values, varargin] = getopts(varargin, 'values', []);
if (~isempty(manual_values)) 
  if ((min(manual_values) < 0) | (max(manual_values) > 1))
    error('Error: values must be inside the [0,1] interval.');
  else
    values = mvol + manual_values * (Mvol - mvol);
    levels = length(values);
    defalpha  = 0.1;
  end
end

%% The alpha level 
[trans,varargin] = getopts(varargin,'alpha',defalpha);

%% Allowing various alpha & color
if (levels > 1)
  if (length(trans) == 1)
    trans(1:levels) = trans;
  elseif (length(trans) ~= levels)
    error(['The alpha vector must have the same length than the' ...
	   ' number of isosurfaces wanted']);
  end
  
  if (~iscell(color))
    [tmp{1:levels}] = deal(color);
    color = tmp;
  elseif (length(color) ~= levels)
    error(['The color cell must have the same length than the' ...
	   ' number of isosurfaces wanted']);
  end
else
  color = { color };
end

%% The display process
for k = 1:levels,
  thepatch = patch(isosurface(ox, oy, oz, vol, values(k)));
  set(thepatch, 'FaceColor', color{k}, 'EdgeColor', 'none');
  view(3)
  camlight
  lighting phong
  alpha(thepatch, trans(k));
  hold on;
end

hold off;
%daspect([1 1 1])
%axis([ oy(1) oy(end) ox(1) ox(end) oz(1) oz(end)]);
set(gca,'xlim',[ox(1) ox(end)]);
set(gca,'ylim',[oy(1) oy(end)]);
set(gca,'zlim',[oz(1) oz(end)]);

%% Determiniing if it is a squared representation
[square,varargin] = getopts(varargin,'square',[],1);

if (square)
  axis square;
end

%% Determiniing if it is a squared representation
[equal,varargin] = getopts(varargin,'equal',[],1);

if (equal)
  daspect([1 1 1]);
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
