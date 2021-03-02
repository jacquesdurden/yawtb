function yashow_timeseq(seq, varargin)
% \manchap
%
% Display a time sequence
%
% \mansecSyntax
%
% yashow\_timeseq (seq [,'pause'])
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
% $Header: /home/cvs/yawtb/tools/display/yashow_timeseq.m,v 1.3 2003-08-13 14:53:06 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

nt = size(seq,1);
nx = size(seq,2);

%% Looking if the user want a pause between each frame
[ispaused,varargin] = getopts(varargin, 'pause', [], 1);

%% min & max of possible values
m_mat = 1.1*min(min(seq));
M_mat = 1.1*max(max(seq));

%% The movie
for t = 1:nt,
  plot(seq(t,:));
  set(gca, 'ylim', [m_mat M_mat]);
  set(gca, 'xlim', [1 nx]);
  h = title([ 'Movie: frame #' num2str(t) '/' num2str(nt)]); 
  set(h,'fontsize',14);
  drawnow;
  
  if ispaused
    pause;
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
