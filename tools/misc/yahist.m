function [out,varargout] = yahist(varargin)
% \manchap
%
% Computes 1D and 2D histograms.
%
% \mansecSyntax
%
% [out[,l]] = yahist(V,N [,'min',m] [,'max',M]) 
% [out[,lx,ly]] = yahist(Vx,Vy,N [,'minx',mx] [,'miny', my] ...
%				 [,'maxx',Mx] [,'maxy', My] )
%
% \mansecDescription
%
% This function computes the 1D or 2D histograms of vectors or matrices data.
%
% \mansubsecInputData
% \begin{description}
% \item[V] [VECTOR|ARRAY]: a vector or an array of values (an
% image) to transform into an histogram; 
%
% \item[Vx,Vy] [VECTORS|ARRAYS]: in the case of 2D histogram, vx and vy
% are two vectors or arrays of same sizes which values describe
% respectively the x and the y coordinates of the 2D histogram;
%
% \item[N] [INTEGER|VECTOR]: N contains the number of desired levels
% into the output histogram. in the 2D case, N could be either a
% vector of length 2 containing the number of levels in x and y
% coordinates, or an integer assuming that these numbers of levels
% are equal.
%
% \item[m,M,mx,my,Mx,My] [REALS]: user defined range of value
% instead of those defined by minimum and maximum of data.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [VECTOR|MATRIX]: a 1D or a 2D histogram, that is a vector or a
% matrix;
%
% \item[l,lx,ly] [VECTORS]: the range of data in 1D, or in 2D for
% the x or y coordinates.
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load woman;
% >> [h,l] = yahist(X,20);
% >> plot(l,h);
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
% $Header: /home/cvs/yawtb/tools/misc/yahist.m,v 1.10 2003-10-22 10:00:16 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Handling the inputs

if (nargin < 1)
  error('Too few arguments. Check the command line.');
end

if (nargin == 1)
  data = varargin{1}(:)';
  N = round(sqrt(length(data)));
elseif (size(varargin{2},1)*size(varargin{2},2) == 1)
  data = varargin{1}(:)';
  N = varargin{2};
else
  if (length(varargin{1}(:)) ~= length(varargin{2}(:)))
    error('Vx & Vy must have the same number of elements.');
  end
  data = [ rowize(varargin{1}(:)); rowize(varargin{2}(:)) ];

  if (nargin >= 3)
    N = varargin{3};
  else
    N = round(sqrt(length(data(:))/2));
  end
end

%% We quantify data
nbdata = size(data,2);
dim    = size(data,1);
N(1)   = N(1);
N(2)   = (dim == 1) + (dim == 2)*N(end);

mdata = min(data,[],2);
Mdata = max(data,[],2);
gdata = (Mdata - mdata);

%% Determining an eventual user defined range
if (dim == 1)
  [umin, varargin] = getopts(varargin,'min',mdata);
  [umax, varargin] = getopts(varargin,'max',Mdata);
  gdata    = umax - umin;
  halfstep = gdata / (2*N(1));
else
  [umin(1), varargin] = getopts(varargin,'minx',mdata(1));
  [umax(1), varargin] = getopts(varargin,'maxx',Mdata(1));
  [umin(2), varargin] = getopts(varargin,'miny',mdata(2));
  [umax(2), varargin] = getopts(varargin,'maxy',Mdata(2));
  gdata    = umax - umin;
  halfstep = gdata ./ (2*N);
end


qdata{1} = ones(1,N(1));
qdata{2} = ones(1,N(2));
test     = 1;
for k = 1:dim,
  v{k}     = vect(umin(k),umax(k),N(k),'rlopen');
  qdata{k} = 1 + ...
      round((data(k,:) - umin(k) - halfstep(k)) ./ gdata(k) * (N(k)-eps*10) );
  
  test = test & (qdata{k} >= 1) & (qdata{k} <= N(k));
end
qdata{1} = qdata{1}(test);
if (dim == 2)
  qdata{2} = qdata{2}(test);
end

out = full(sparse(qdata{2},qdata{1},ones(1,length(qdata{1})),N(2),N(1)));
varargout = v;

  
%% Subfunctions

function out = rowize(in)
nbrow = size(in,1);
nbcol = size(in,2);

if (nbrow > nbcol)
  out = in.';
else
  out = in;
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
