function coeff = sarcwt2d(mat,wavname,scales,angles,varargin)
% \manchap
%
% Compute the CWT scale (angle) representation of mat
%
% \begin{TODO} 
% Implement this program without cwt2d, directly with the
% scalar product of mat and the wavelet.
% This will of course decrease the computing time!
% \end{TODO}
%
% \mansecSyntax
% coeff = sarcwt2d(mat,wavname,scales,angles
%           [,'x',x,'y',y] 
%           [,'Show'] ['ShowIn',resfig] [,'Fig',fig] 
%           [,'WaveletParameterName',WaveletParameterValue']) 
%
% \mansecDescription
%
% Compute the scale angle continuous wavelet representation at the
% point (x:col, y:row) of the matrix mat. These coordinates can be
% either given to the program through with the ('x', x) and
% ('y', y) options, or directly selected with the mouse on a figure
% of mat. This figure is either display by the call of sarcwt2d, or
% taken in an existent figure if the fig option is set (through the
% command ('Fig',n) with 'n' the index of the current figure).
% As in cwt2d, the wavelet parameters can be introduced with the
% usual syntax (see cwt2d for explanations).  
%
% \mansubsecInputData
% \begin{description}
%
% \item[mat] [MATRIX]: the input image.
%
% \item[wavname] [STRING]: the name of the wavelet. See cwt2d for
% an exact list of the available wavelets.
%
% \item[scales] [REAL VECTOR]: the vector of scales.
%
% \item[angles] [REAL VECTOR]: the vector of angles.
%
% \item[x, y] [REAL]: the coordinates of the point (x:col, y:row),
% that is the fixed position b of the wavelet transform.
%
% \item[fig] [INTEGER]: the index of the figure where to select the
% position b if not given through x and y.
%
% \item[WaveletParameterValue] [MISC]: the parameters of the
% wavelet. See the corresponding wavelet code for explanation. 
%
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
%
% \item[out] [VECTOR]: the vector of wavelet coefficient according scales.
%
% \end{description} 
%
% \mansecExample
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwt2d 
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/2d/sarcwt2d.m,v 1.4 2003-06-24 08:39:22 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with this library)
% (See the notice at the end of the file.)

%% Initialization
extraopts    = varargin;
nsc          = length(scales);
nang         = length(angles);

nrow         = size(mat,1);
ncol         = size(mat,2);

tmat         = fft2(mat);

[x,extraopts]       = getopts(extraopts,'x',[]);
[y,extraopts]       = getopts(extraopts,'y',[]);
[mainfig,extraopts] = getopts(extraopts,'Fig',[]);
[show,extraopts]    = getopts(extraopts,'Show',[],1);
[showin,extraopts]  = getopts(extraopts,'Showin',0);
show = show | showin;
[markpoint,extraopts] = getopts(extraopts,'Mark',[],1);

plotcolor    = 'ymcrgbk';
thecolor     = plotcolor(floor(rand*length(plotcolor))+1);


[posx,posy]  = meshgrid(1:ncol,1:nrow);

%% Determine if it is the "mouse" mode or not 
if isempty(x) | isempty(y)
  mousechoose = 1;
else
  mousechoose = 0;
end

%% Let the user choose his maxima if not given in 
%% extraopts (==varargin)
if (mousechoose)
  
  %% Find first if another call of mmcwt2d has draw a main
  %% figure
  if isempty(mainfig)
    figs    = get(0,'Children');
    mainfig = figs(find(strcmp(get(get(0,'Children'),'tag'), ...
			       [mfilename '_main_' inputname(1) '_' wavname])));
  else
    figure(mainfig);
    hold on
  end
  
  if isempty(mainfig)
    figure;
    mainfig = gcf;
    set(gcf,'tag', [mfilename '_main_' inputname(1) '_' wavname]);
    yashow(mat,'fig',gcf);
    axis equal;
    axis tight;
    hold on
    colormap(gray);
  else
    mainfig = mainfig(1);
    figure(mainfig)
  end

  [x,y] = ginput(1);
  
end
x     = min(max(1,round(x)),ncol);
y     = min(max(1,round(y)),nrow);

if (mousechoose)
  fprintf('You have selected the position (x:%g,y:%g)\n',x,y);
end

%% mark the point on the main graphic
if (mousechoose) & (markpoint)
  theindex=length(findobj('type','text','parent',gca));
  yashow(y,'x',x,[thecolor '.'],'MarkerSize',3,'fig',mainfig);
  h=text(x,y,['---(' num2str(theindex+1) ')']);
  set(h,'color',thecolor);
  %plot(x,y,[thecolor 'o'],'MarkerSize',10);
  %% Force the draw of this dot by flushing matlab graphics
  drawnow
  drawnow
  drawnow
end

%% Search the corresponding maxima coeff beginning on dots(:,index)
if (nang == 1)
  coeff = zeros(1,nsc);
else
  coeff = zeros(nsc,nang);
end

%% Initializing the progress bar
oyap = yapbar([],nsc*nang);

for sc = 1:nsc,
  for th = 1:nang,
    %% Incrementing the progress bar
    oyap = yapbar(oyap,'++');
  
    %% Computing the wavelet coefficients (there is a better way to
    %% do that but I have no time now)
    wav = feval('cwt2d',tmat,wavname,scales(sc),angles(th), extraopts{:});
    coeff(nsc*(th-1) + sc) = wav.data(y,x);
  end
end

%% Closing the progress bar
oyap = yapbar(oyap,'close');

%% Quit (with results) here if the user doesn't want to see plots
if (~show)
  return;
end

%% Select a new figure for showing the results unless the 'showin'
%% is set.
if showin
  figure(showin);
  hold on;
else
  figure;
end

%% Predefined plot exectued if the 'show' (boolean) is present
%% inside varargin == extraopts.
if (nang == 1)
  %% First subplot: The CWT in function of scales.
  %% => Information about the typical feature size
  plot(log(scales),real(coeff),thecolor);
  hold on
  xlabel('Log of scales');
  ylabel('CWT');
  title(['2D CWT ' wavname ' coefficients according log of scales']);
  
  [peak,pos] = max(real(coeff));
  spos = log(scales(pos));
  plot(spos,peak,'rx');
  xlim = get(gca,'xlim');
  ylim = get(gca,'ylim');
  h=line([spos spos],[-inf inf]);
  set(h,'LineStyle',':');
  h=text(spos+(xlim(2)-xlim(1))/80,peak + (ylim(2) - ylim(1))/40,[' ' num2str(peak)]);
  set(h,'color',thecolor);
  if (mousechoose) & (markpoint)
    h=text(log(scales(nsc)),real(coeff(nsc)),...
	   [' ---(' num2str(theindex+1) ')']);
    set(h,'color',thecolor);
  end
  hold off
else
  yashow(coeff,'x',angles,'y',scales,'cmap',jet);
  axis equal;
  axis tight;
  xlabel('Angles');
  ylabel('Scales');
  title(['Scale Angle Representation at (' ...
	 num2str(x) ',' num2str(y) ')']);
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
