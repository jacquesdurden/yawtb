function yashow(yastruct, varargin)
% \manchap
%
% Display the result of any transform defined in \YAWTB
%
% \mansecSyntax
% yashow(yastruct ['Fig',fig] [,'Mode',mode [,ModeParam]] [,'CMap',cmap] ...
%          [,'Square'] [,'Equal'] [,'HistEq'] [,'Normalize'] ...
%          [,'Contour' [,nlevel] ] ...
%          [,'Contour' [,vlevel] ] ...
%          [,'Surf' ] ...
%          [,'Spheric'[,'Relief'[,'Ratio',ratio]]] ...
%          [,'maxi'[,T]] [,'mini'[,T]] )
%
% \mansecDescription
% The aim of this function is to simplify the use of the \Matlab
% visualization tools for any \YAWTB result coming, for instance,
% from \libfun{cwt1d}, \libfun{cwt2d} and \libfun{cwtsph}.
%
% \mansubsecInputData
% \begin{description}
%
% \item[yastruct] [STRUCT]: the result of a particular \YAWTB
% transform. 
%
% \item[fig] [POSITIVE INTEGER]: specifies the figure in which to
% display the input. 
%
% \item[mode] ['abs','angle', 'essangle', 'real','imag']: is a string which
% defines the display mode. Available modes for the data
% representation are: 
% \begin{description}
% \item['abs']: the absolute value;
% \item['angle']: the complex argument;
% \item['essangle']: the essential argument, that is the argument
% thesholded by default at 1\% of the modulus. You may change this
% value by putting a real number between 0 and 1 after 'essangle'
% in the yashow call.
% \item['real']: the real part;
% \item['imag']: the imaginary part.
% \end{description}
%
% \item[cmap] [STRING]: define the colormap to use in the display,
% e.g. 'jet' [default], 'hsv', 'gray'.
%
% \item['Square'] [BOOLEAN]: specifies if yashow must display a
% matrix like a square
%
% \item['Equal'] [BOOLEAN]: specifies if yashow must keep the
% square shape of the pixels (dx==dy).  
%
% \item['HistEq'] [BOOLEAN]: specifies if yashow must equalize
% histogram of the display matrix.
%
% \item['Normalize'] [BOOLEAN]: specifies if the data must be
% normalized to [-1,1]. This can be useful in 1D, if you plot several
% signal with hold on and you are interested in their shape.
%
% \item['Contour'] [BOOLEAN]: display the contour of the
% matrix. Possible modifiers are:
% \begin{description}
% \item[nlevel] [INTEGER]: the number of levels to display;
%
% \item[vlevel] [1x2 VECTOR]: a vector containing twice the curve level
% to display, e.g. [0 0] to show the curve level of zero height.
% \end{description}
%
% \item['Surf'] [BOOLEAN]: display the matrix as a 3D surface.
%
% \item['maxi'] [BOOLEAN]: specifies if crosses representing maxima
% must be added to the displayed image.
%
% \item['mini'] [BOOLEAN]: specifies if circles representing minima
% must be added to the displayed image.
%
% \item[T] [REAL]: gives an eventual threshold for the maxima or
% the minima displayed by the two preceeding options. T belongs to
% the interval 0<=T<=1. The maxima shown are those which have a
% value greater than MIN + T*(MAX-MIN), where MIN is the global
% minimum of the data and MAX its global maximum. Similarly, the
% minima must be below MAX - T*(MAX-MIN) to be represented.
%
% \item['Spheric'] [BOOLEAN]: (for matrix only !) Specifies if the
% matrix must be mapped onto a sphere (useful for cwtsph \&
% al.). 
%
% The suboptions of this mode are :
% \begin{description}
% \item['Relief'] [BOOLEAN]: the mapping is done in relief, that
% is, the values of the input matrix correspond to the variation of
% spherical radius around 1. The maximum absolute value of this matrix is
% set by default to 1/3 of the sphere radius. This can be changed
% by the ratio variable.
%
% \item[ratio] [DOUBLE]: set the ratio between the highest absolute
% value of the input matrix and the sphere radius.
% \end{description}
% \end{description} 
%
% \mansecExample
%
% In its easiest form, yashow can be used like this:
% \begin{code}
% >> [x,y] = meshgrid(-64:64);
% >> square = max(abs(x), abs(y)) < 20;
% >> fsquare = fft2(square);
% >> wsquare = cwt2d(fsquare,'cauchy',2,0);
% >> yashow(wsquare);
% \end{code}
%
% So, the absolute value the square 2D wavelet transform is shown.
% The last line can be change by
% \begin{code}
% >> yashow(wsquare,'Mode','angle','CMap','gray(40)');
% \end{code}
%
% to display the argument of this transform in the colormap 'gray'
% of 40 levels.
%
% \mansecSeeAlso
%
% /cgt1d$ /cwt1d$ /cwt2d$ /cwtsph$ /wpck2d$ yashow$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/display/yashow.m,v 1.66 2007-11-12 10:07:53 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Managing the input

if (nargin < 1)
  error('At least one input argument is required. Check the command line');
end

%% yashow can display simple N-D matrix
if ( isnumeric(yastruct) | ...
     islogical(yastruct) )
  ans = yastruct;
  clear yastruct;
  yastruct.data = ans;
  
  %% .. on a volume (<3 could be a color image)
  if (size(yastruct.data,3) > 3) 
    yastruct.type = 'volume';
    
  elseif (size(yastruct.data,1) >= 2) & (size(yastruct.data,2) >= 2)
    %% .. on a sphere
    if getopts(varargin,'spheric',[],1) 
      yastruct.type = 'spheric';
      
    elseif getopts(varargin,'sphvf',[],1) 
      yastruct.type = 'sphvf';
      
    %% .. a time sequence
    elseif getopts(varargin,'timeseq',[],1) 
      yastruct.type = 'timeseq';
      
    %% ... the standard way
    else                                
      yastruct.type = 'matrix';
    end    
  else
    yastruct.type = 'vector';
  end
else

  if (~isstruct(yastruct)) | (~isfield(yastruct,'type'))
    error('Unrecognized input type')
  end
  
  %% The display part
  
  %% Allow overloading of yashow if the showing method of the yawtb
  %% result is implemented in yashow_*.m
  
  if exist([ 'yashow_' yastruct.type ]) == 2
    feval(['yashow_' yastruct.type], yastruct,varargin{:});
    return
    
  elseif (~any(strcmp(yastruct.type,YashowInnerTypes)))
    
    error(sprintf('yashow not implemented for the %s type', ...
		  yastruct.type));
  end
end


%% Else, let's do the work by yashow!

%% Selecting the good figure
oldfig = gcf;
[fig,varargin] = getopts(varargin,'fig',gcf);
figure(fig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Specific methods of 'matrix' and 'vector' %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch lower(yastruct.type)
 case 'volume'
  %% Determining if an 'x' or 'y' axis is given
  if (isfield(yastruct,'x'))
    x_opts = {'x', yastruct.x};
  else
    x_opts = {};
  end
  
  if (isfield(yastruct,'y'))
    y_opts = {'y', yastruct.y};
  else
    y_opts = {};
  end
  
  if (isfield(yastruct,'z'))
    z_opts = {'z', yastruct.z};
  else
    z_opts = {};
  end
  
  yashow_volume(yastruct.data, x_opts{:}, y_opts{:}, z_opts{:}, varargin{:});
 
 case 'matrix',
  
  if (isfield(yastruct,'x'))
    x_opts = {'x', yastruct.x};
  else
    x_opts = {};
  end
  
  if (isfield(yastruct,'y'))
    y_opts = {'y', yastruct.y};
  else
    y_opts = {};
  end
  
  yashow_matrix(yastruct.data, x_opts{:}, y_opts{:}, varargin{:});
  
 case 'spheric',
  
  yashow_spheric(yastruct.data, varargin{:});
  
 case 'sphvf',
  
  yashow_sphvf(yastruct.data, varargin{:});
 
 case 'vector',
  %% Determining if an 'x' or 'y' axis is given
  [ox,varargin] = getopts(varargin,'x',1:length(yastruct.data));
  
  %% The final plotting
  plot(ox,yastruct.data(:),varargin{:});
  
 case 'timeseq',
  yashow_timeseq(yastruct.data, varargin{:});

 otherwise
  error(['The mode ''' mode ''' is undefined in yashow']);  
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
