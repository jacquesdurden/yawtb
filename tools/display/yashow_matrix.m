function yashow_matrix(mat, varargin)
% \manchap
%
% display a matrix
%
% \mansecSyntax
%
% yashow\_matrix( mat [,'x',x] [,'y',y] ...
%                [,'CMap', cmap] ['Square'] ['Equal'] ... 
%                [,'Contour'[,n]] [,'Surf'] [,'HistEq'] ...
%                [,'maxi' [,T]] [,'mini' [,T]] [,'Freq'] )
%
% \mansecDescription
% Specialization of yashow to the display of real matrices.
%
% \mansubsecInputData
% \begin{description}
% \item[mat] [MATRIX]: 
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
% $Header: /home/cvs/yawtb/tools/display/yashow_matrix.m,v 1.11 2005-01-20 08:57:26 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Putting the matrix in mat
mat_orig = mat;
[nrow, ncol, ncolor] = size(mat);

%% Determining if user want to see the frequency representation of
%% his image.
[isfreq,varargin] = getopts(varargin,'freq',[],1);
if (isfreq)
  mat = fftshift(fft2(mat));
end

%% Determining the parameter of certain special modes like essangle
modepar = {};

if (getopts(varargin, 'essangle', [], 1))
  modepar{1} = getopts(varargin, 'essangle', 0.01);
  if ((~isnumeric(modepar{1}))| isempty(modepar{1}))
    modepar{1} = 0.01;
  end
end


%% Modifying the matrix with the selected mode  
%% e.g. abs, real, image, essangle ...
if isreal(mat)
  defmode = 'real';
else
  defmode = 'abs';
end
[mode,varargin] = getopts(varargin,'mode',defmode);

mode = lower(mode);
modelist = {'abs', 'angle', 'essangle', 'real', 'imag', 'ener', 'bool'};
if all(~strcmp(modelist, mode)) 				  
  error(['The mode ''' mode ''' is undefined in yashow']);
end
mat = feval(mode,mat, modepar{:});

%% Determining if the user want to normalize his data
[normalize, varargin] = getopts(varargin, 'normalize', [], 1);

if (normalize)
  mat = mat ./ max(max(abs(mat)));
end

%% Image or contour representation ?
iscontr = getopts(varargin,'contour',[],1);
ncontr  = getopts(varargin,'contour','');

if ( (ischar(ncontr)) | ...  %% If ncontr is a string, it means that no
     (isempty(ncontr)))      %% options for 'contour' have been specified
  ncontr = 20;
end

%% ... or surf representation
[issurf, varargin]  = getopts(varargin,'surf',[],1);

%% Determining if an histogram equalization is requested
[histequal, varargin] = getopts(varargin,'histeq',[],1);

if (histequal)
  %% Recording of mat for further uses which don't like 
  %% histequalized mat (like maxi, mini, ...).
  mat = mat - amin(mat);
  mat = uint8(256* mat ./ amax(mat));
  mat = histeq(mat);
end

%% Determining if an 'x' or 'y' axis is given

[ox,varargin] = getopts(varargin,'x',1:ncol);
[oy,varargin] = getopts(varargin,'y',1:nrow);

%% Finally, the true display step with imagesc or contour
if (iscontr)    
  contour(ox,oy,mat,ncontr);
  axis('ij');
elseif (issurf)
  surf(ox,oy,mat);
  shading flat
  camlight
  lighting phong
else
  imagesc(ox,oy,mat);
end

%% Add cross on maxima if asked
showmaxi = getopts(varargin,'maxi',[],1);
[showmaxi_thresh,varargin] = getopts(varargin,'maxi',0.01);
if (~isnumeric(showmaxi_thresh))
  showmaxi_thresh = 0.01;
end


if (showmaxi)
  hold on;
  if (histequal)
    [y,x] = find(yamax(mat_orig,'thresh',showmaxi_thresh));
  else
    [y,x] = find(yamax(mat,'thresh',showmaxi_thresh));
  end
  plot(ox(x),oy(y),'kx');
  hold off;
end

%% Add cross on minima if asked
showmini = getopts(varargin,'mini',[],1);
[showmini_thresh,varargin] = getopts(varargin,'mini',0.01);
if (~isnumeric(showmini_thresh))
  showmini_thresh = 0.01;
end

if (showmini)
  hold on;
  if (histequal)
    [y,x] = find(yamax(-mat_orig,'thresh',showmini_thresh));
  else
    [y,x] = find(yamax(-mat,'thresh',showmini_thresh));
  end
  plot(ox(x),oy(y),'ko');
  hold off;
end

%%axis('equal');
%%axis('tight');

%% ++++++++ Another useful options +++++++++

%% Determining the colormap (default: 'gray' for binary and uint8 images,
%%                                    'jet' for others.)

if ( islogical(mat) | ( strcmp(class(mat),'uint8') & (ncolor == 1) ))
  defcmap = 'gray';
else
  defcmap = 'jet';
end

[cmap,varargin] = getopts(varargin,'cmap',defcmap);

if (~isnumeric(cmap))
  pos_par = yastrfind(cmap,'(');
  if isempty(pos_par)
    cmap_base = cmap;
  else
    cmap_base = cmap(1:(pos_par-1));
  end
  if (exist(cmap_base) ~= 2)
    error(['The colormap ''' cmap ''' doesn''t exist']);
  end
  
  eval(['colormap(' cmap ')']);
else
  colormap(cmap);
end

%% Determiniing if it is a squared representation
[square,varargin] = getopts(varargin,'square',[],1);

if (square) | (nrow == ncol)
  axis square;
end

%% Determiniing if it is a equalized representation (pixel==square)
[equal,varargin] = getopts(varargin,'equal',[],1);

if (equal);
  axis equal;
  axis tight;
end

%% Miscellaneous subfunctions
function out = amin(mat)
out = min(mat(:));

function out = amax(mat)
out = max(mat(:));

%% == Various specifical modes ==

%% Energy mode
function out = ener(mat)
%% Display the energy of mat, that is its square modulus.
out = abs(mat).^2;

%% Binary mode
function out = bool(mat)
%% Display the non zero entries of mat (absolute sense).
out = ~~abs(mat);

function out = essangle(mat, thresh)
%% Setting to NaN all the value of angle(mat) where abs(mat) is
%% less than 1%.
out = zeros(size(mat))*NaN;
goodpt = yathresh(abs(mat),thresh)>0;
out(goodpt) = angle(mat(goodpt));


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
