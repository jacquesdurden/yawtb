function [out] = yathresh(mat,level,varargin)
% \manchap
%
% Hardly threshold a matrix.
%
% \mansecSyntax
% [out] = yathresh(mat,level,['absolute'])
%
% \mansecDescription
% Return the matrix 'mat' hard thresholded by 'level'. This level
% can be realtive (in percent of maximum) or absolute. 
% 
% \mansubsecInputData
% \begin{description}
%
% \item[mat] [MATRIX]: the input matrix;
%
% \item[level] [REAL]: the level of thresholding. If relative,
% \libvar{level} is 0$<$level$<$1, with 0 and 1 corresponding
% respectively to 0\% and 1\% of thresholding. If absolute,
% \libvar{level} is considered as a value.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MATRIX]: the thresholded matrix.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> mat = rand(100,100);
% >> nmat = yathresh(mat,0.5);
% >> figure; imagesc(mat);
% >> figure; imagesc(nmat);
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
% $Header: /home/cvs/yawtb/tools/misc/yathresh.m,v 1.4 2003-06-24 14:44:42 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Managing the inputs
if (nargin < 2)
  yahelp(mfilename,'usage');
  error('Wrong number of arguments. Check the command line.');
end

if (~isnumeric(level))
  yahelp(mfilename,'usage');
  error('level must be numeric.');
end

isabs = getopts(varargin,'absolute',[],1);

if (~isabs)
  if (any(level(:)<0)) | (any(level(:)>1))
    yahelp(mfilename,'usage');
    error('level is taken inside [0,1]');
  end
end

%% Computing the thresholded matrix
nmat = abs(mat);
if (isabs)
  T = level;
else
  T = level * max(nmat(:));
end

out = mat;
out(nmat < T) = 0;

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
