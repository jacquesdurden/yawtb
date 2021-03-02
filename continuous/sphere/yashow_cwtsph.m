function yashow_cwtsph(yawres, varargin)
% \manchap
%
% Display the result of cwtsph. Automatically called by yashow!
%
% \mansecSyntax
% cwtsph\_yashow(yawres [,'fig',fig] [,'faces',N] [,'filter']
%                   [,'relief'[,'ratio',ratio]])
%
% \mansecDescription
%
% This function displays the result of the cwtsph function. It is
% automatically called by yashow with respect to the type of
% yawres, that is, the name of yawres.type. The data are mapped
% onto a sphere approximate by a N faces polygon (N=20 by default).
%
% \mansubsecInputData
% \begin{description}
% \item[yawres] [YAWTB OBJECT]:  the input structure coming from
% cwtsph.
%
% \item[fig] [INTEGER]: the figure where to display result.
%
% \item[N] [INTEGER]: change the number of faces for the sphere
% approximation.
%
% \item[filter] [BOOLEAN]: the presence of this modifier specify if
% we want to display the filter, that is, the spherical wavelet. 
%
% \item[relief] [BOOLEAN]: this modifier change the display of the
% CWT (or its filter) from a simple spherical mapping to a true
% relief vision.
%
% \item[ratio] [DOUBLE SCALAR]: in conjunction with the boolean
% 'relief', this parameter determines the ratio between the CWT
% highest value and the sphere radius. By default, it is set to 1/3.
%
% \end{description} 
%
% \mansubsecOutputData
%
% \mansecExample
% \begin{code}
% >> load world;
% >> wav = cwtsph(mat,'dog',0.05,0);
% >> yashow(wav);
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% cwtsph
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/sphere/yashow_cwtsph.m,v 1.3 2003-04-08 14:33:23 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Determining which scale and which angle to show

[shsc,varargin]  = getopts(varargin,'sc',1);
[shang,varargin] = getopts(varargin,'ang',1);

if ( (shsc  < 1) | (shsc  > length(yawres.sc)) | ...
     (shang < 1) | (shang > length(yawres.ang) ) )
  error('Invalid angle or scale index value');
end

%% Determining if we want to see only the filter
[showfilter,varargin] = getopts(varargin,'filter',[],1);
if showfilter
  
  scales      = yawres.sc;
  angles      = yawres.ang;
  wavname     = yawres.wav;
  nsc         = length(scales);
  nang        = length(angles);
  [Hgth,Wdth] = size(yawres.data);
  
  %% The spherical grid
  phi          = vect(-pi, pi, Wdth, 'open');
  th           = vect(0, pi, Hgth);
  [PHI,THETA]  = meshgrid(phi,th);
  dphi         = phi(2) - phi(1);
  dth          = th(2)  - th(1); 
  
  %% The 3D coordinates of this grid
  %% Spherical coordinates on sphere:
  X      = sin(THETA).*cos(PHI); 
  Y      = sin(THETA).*sin(PHI);
  Z      = cos(THETA);
  
  
  %% Determining the wavelets parameter taking account of those set
  %% in varargin.
  [wavopts,varargin] = yawopts(varargin,wavname);
  
  %% The wavelet
  csc  = yawres.sc(shsc);
  cang = yawres.ang(shang);
  tmp  = feval(wavname, X,Y,Z,0,0,1,csc,cang, wavopts{:});
else
  tmp  = yawres.data; 
end

%% The display part: calling the spherical part of yashow
yashow(tmp,'spheric', varargin{:});

%% Set a good title according to yawres fields
wavpar = feval(yawres.wav,[]);
nbpar  = length(wavpar);
wavpar(2:2:nbpar) = yawres.para;

strpar = '';
for l = 1:nbpar, 
  if l == 1
    strpar = [ strpar ' ' num2str(wavpar{l}) ]; 
  elseif rem(l,2)
    strpar = [ strpar ', ' num2str(wavpar{l}) ]; 
  else
    strpar = [ strpar '=' num2str(wavpar{l}) ]; 
  end
end

strsc   = sprintf('%g',yawres.sc(shsc));
strang  = sprintf('%g',yawres.ang(shang));
wavname = yawres.wav;

if showfilter
  title({[ upper(wavname(1)) lower(wavname(2:end)) ' spherical wavelet '...
	  'for (a,\theta)=(' strsc ',' strang ')']; ...
	 ['and ' strpar ]});
else
  title({[ 'CWTSPH: fixed (a,\theta)=(' strsc ',' strang ')']; ...
	 [ 'Wavelet: ' yawres.wav ' (' strpar ' )' ]});
end

%% Setting to 14 the size of the different text
set(get(gca,'title'), 'fontsize', 14);
set(get(gca,'xlabel'), 'fontsize', 14);
set(get(gca,'ylabel'), 'fontsize', 14);
set(get(gca,'zlabel'), 'fontsize', 14);


%% Resizing the window to allow a 2 line title
set(gca,'position',[0.13 0.11 0.775 0.775]); 

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
