function yashow_cwt3d(yawres, varargin)
% \manchap
%
% Display the result of cwt3d. Automatically called by yashow!
%
% \mansecSyntax
% cwt3d\_yashow(yawres [,'filter' [,filter\_type]] )
%
% \mansecDescription
% This function displays the result of the cwt3d function. It is
% automatically called by yashow with respect to the type of
% yawres, that is, the name of yawres.type. 
%
% \mansubsecInputData
% \begin{description}
%
% \item[yawres] [YAWTB OBJECT]:  the input structure coming from
% cwt3d.
%
% \item[filter] [BOOLEAN]: the presence of this modifier specify if
% we want to display the filter, that is, the wavelet in frequency.
%
% \item[filter\_type] ['freq'|'pos']: the type of filter to
% display: its frequency ('freq') or its positional ('pos')
% representation. By default, without any precision, the frequency
% part is drawn.
%
% \end{description} 
%
% \mansubsecOutputData
%
% \mansecExample
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
% $Header: /home/cvs/yawtb/continuous/3d/yashow_cwt3d.m,v 1.1 2002-07-25 08:55:57 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Determining the display mode ('abs' is the default)

modelist         = {'abs','angle','real','imag','ener'};
[mode,varargin]  = getopts(varargin,'mode','abs');
mode             = lower(mode);

if all(~strcmp(modelist, mode)) %%TODO: perhaps replace by
                                %%      exist('mode')==2 ?
   error(['The mode ''' mode ''' is undefined in yashow']);
end

%% Creating a string which represents the varargin
strvarargin='';
for k=1:length(varargin),
  strvarargin = [ strvarargin sprintf(',varargin{%i}',k) ] ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The main part of this YASHOW...    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if getopts(varargin,'filter',[],1)
  
  %% Determining if the user want to see the filter in
  %% the positional 'pos' space or in the frequency space 'freq'.
  filter_type = getopts(varargin,'filter','');
  
  if (~strcmp(filter_type,'pos'))
    filter_type = 'freq';
  end
  
  %% Initializations
  scale   = yawres.sc;
  angles  = yawres.ang;
  wavname = yawres.wav;
  mask    = 0*yawres.data;
  
  nrow    = size(yawres.data,1);
  ncol    = size(yawres.data,2);
  ndth    = size(yawres.data,3);
  
  fx      = vect(-pi,pi,ncol,'open');
  fy      = vect(-pi,pi,nrow,'open');
  fz      = vect(-pi,pi,ndth,'open');
  
  [kx,ky,kz] = meshgrid(fx, fy, fz);
  
  %% Angles considerations
  th = angles(1);
  ph = angles(2);
  
  cth = cos(th);
  sth = sin(th);
  cph = cos(ph);
  sph = sin(ph);
  
  if (th)
    %% Rotation of phi around the oz axis 
    nkx   = cph*kx - sph*ky;
    nky   = sph*kx + cph*ky;
    nkz   = kz;
    
    %% Rotation of theta around the oy axis
    kx  =  cth * nkx + sth * nkz; 
    ky  =  nky;
    kz  = -sth * nkx + cth * nkz;
  end
  
  %% The dilation of scale 'a'      
  nkx = scale * kx; 
  nky = scale * ky;
  nkz = scale * kz;
  
  %% Determining the wavelet parameters
  strwavopts = '';
  for k=1:length(yawres.para)
    strwavopts = [ strwavopts ',yawres.para(' num2str(k) ')' ];
  end
  
  %% Determining the filter
  mask = eval([ wavname '(nkx,nky,nkz' strwavopts ')']);
  
  if (strcmp(filter_type,'freq'))
    %% and display it in the yashow for simple matrix
    tmp = eval([ mode '(mask)' ]);
    eval(['yashow(tmp' strvarargin ',''x'',fx,''y'',fy,''z'',fz, ''equal'')']);
  
    %% Display frequency axis
    h1 = line([-pi pi],[0 0],[0 0]);
    h2 = line([0 0],[-pi pi],[0 0]);
    h3 = line([0 0],[0 0],[-pi pi]);
    set(h1,'LineStyle','--');
    set(h2,'LineStyle','--');
    set(h3,'LineStyle','--');
  
    %% Naming the axes
    xlabel('kx');
    ylabel('ky');
    zlabel('kz');
  else
    tmp = eval([ mode '(fftshift(ifftn(fftshift(mask))))' ]);
    eval(['yashow(tmp' strvarargin ',''equal'')']);

    %% Naming the axes
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
  end
  
  %% Set a good title according to the yawres fields
  wavpar = eval([ yawres.wav '([])']);
  nbpar  = length(wavpar);
  wavpar(2:2:nbpar) = num2cell(yawres.para);
  
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
  
  title({[ upper(wavname(1)) lower(wavname(2:length(wavname))) ...
	   ' wavelet for '...
	   'a=' num2str(scale) ', ' ...
	   '\theta=' num2str(th) ', ' ...
	   '\phi=' num2str(ph) ]; ...
	 ['and ' strpar ]});
  
else
  
  %% Display in the yashow for simple matrix
  tmp = eval([ mode '(yawres.data)']);
  eval(['yashow(tmp' strvarargin ')']);
  
  %% Set a good title according to yawres fields
  wavpar = eval([ yawres.wav '([])']);
  nbpar  = length(wavpar);
  wavpar(2:2:nbpar) = num2cell(yawres.para);
  
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
  
  strsc  = sprintf('%g',yawres.sc);
  
  title({[ 'CWT3D:' ...
	  ' fixed a=' strsc ]; ...
	 ['Wavelet: ' yawres.wav ...
	  ' (' strpar ' )' ]});
  xlabel('X');
  ylabel('Y');
  zlabel('Z');
end    

%% Setting to 14 the size of the different text
set(get(gca,'title'), 'fontsize', 14);
set(get(gca,'xlabel'), 'fontsize', 14);
set(get(gca,'ylabel'), 'fontsize', 14);
set(get(gca,'zlabel'), 'fontsize', 14);


%% Resizing the window to allow a 2 line title
set(gca,'position',[0.13 0.11 0.775 0.775]); 

function out = ener(mat)
out = abs(mat).^2;

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
