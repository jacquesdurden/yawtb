function [out] = yasthresh(mat,level,varargin)
% \manchap
%
% Softly threshold a matrix.
%
% \mansecSyntax
% [out] = yasthresh(mat,level [,'absolute'])
%
% \mansecDescription
% Return the matrix 'mat' softly thresholded by 'level' percent.
% 
% \mansubsecInputData
% \begin{description}
%
% \item[mat] [VECTOR|MATRIX]: the input vector or matrix.
%
% \item[level] [REAL]: If relative, the level of thresholding, that
% is 0$<$level$<$1, with 0 and 1 corresponding respectively to 0\%
% and 100\% of thresholding. If absolute, level is taken as a value.
%
% \item['absolute'] [BOOL]: determine if the level is relative or absolute.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [REAL VECTOR|REAL MATRIX]: the softly thresholded
% vector or matrix.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> mat = rand(100,100);
% >> nmat = yasthresh(mat,0.5);
% >> figure; imagesc(mat);
% >> figure; imagesc(nmat);
% \end{code}
%
% \mansecReference
%
% D. Donoho, "Denoising by soft-thresholding", IEEE
% Trans. Info. Theory, vol 43, pp. 613--627, 1995.
%
% \mansecSeeAlso
%
% yathresh
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/yasthresh.m,v 1.6 2003-06-24 14:44:42 ljacques Exp $
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
  error('''level'' must be numeric.');
end

isabs = getopts(varargin,'absolute',[],1);

if (~isabs)
  if (any(level(:)<0) | any(level(:)>1))
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

out  = zeros(size(mat));
if isreal(mat)
  out(:)  = (nmat(:) - T(:)) .* sign(mat(:)) .* (nmat(:) > T(:));
else
  out(:)  = (nmat(:) - T(:)) .* exp(i*angle(mat(:))) .* (nmat(:) > T(:));
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
