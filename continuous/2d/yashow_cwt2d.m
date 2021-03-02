function yashow_cwt2d(yawres, varargin)
% \manchap
%
% Display the result of cwt2d. Automatically called by yashow!
%
% \mansecSyntax
% cwt2d\_yashow(yawres [,'filter' [,filter\_type]] )
%
% \mansecDescription
% This function displays the result of the cwt2d function. It is
% automatically called by yashow with respect to the type of
% yawres, that is, the name of yawres.type. 
%
% \mansubsecInputData
% \begin{description}
%
% \item[yawres] [YAWTB OBJECT]:  the input structure coming from
% cwt2d.
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
% $Header: /home/cvs/yawtb/continuous/2d/yashow_cwt2d.m,v 1.2 2002-07-25 12:31:40 ljacques Exp $
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
  scales  = yawres.sc;
  angles  = yawres.ang;
  wavname = yawres.wav;
  nsc     = length(scales);
  nang    = length(angles);
  mask    = 0*yawres.data;
  nrow    = size(yawres.data,1);
  ncol    = size(yawres.data,2);
  
  fx      = vect(-pi,pi,ncol,'open');
  fy      = vect(-pi,pi,nrow,'open');
  
  [kx,ky] = meshgrid(fx, fy);
  
  csc  = scales(shsc);
  cang = angles(shang);

  [nkx, nky] = yadiro(kx,ky,csc,cang,'freq');
  
  %% Determining the wavelet parameters
  strwavopts = '';
  for k=1:length(yawres.para)
    strwavopts = [ strwavopts ',yawres.para(' num2str(k) ')' ];
  end
  
  %% Determining the filter
  mask = eval([ wavname '(nkx,nky' strwavopts ')']);
  
  if (strcmp(filter_type,'freq'))
    %% and display it in the yashow for simple matrix
    yashow(mask, 'x',fx, 'y',fy, 'equal', varargin{:});
  
    %% Display frequency axis
    h1 = line([-pi pi],[0 0]);
    h2 = line([0 0],[-pi pi]);
    set(h1,'LineStyle','--');
    set(h2,'LineStyle','--');
  
    %% Naming the axes
    xlabel('kx');
    ylabel('ky');
  else
    tmp = fftshift(ifft2(fftshift(mask)));
    px  = vect(-ncol/2,ncol/2,ncol,'open');
    py  = vect(-nrow/2,nrow/2,nrow,'open');
    yashow(tmp, 'x',px, 'y',py, 'equal', varargin{:});

    %% Naming the axes
    xlabel('X');
    ylabel('Y');
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
	   '(a,\theta)=(' num2str(yawres.sc(shsc)) ... 
	   ',' num2str(yawres.ang(shang)) ')  ']; ...
	 ['and ' strpar ]});
 
  
else
  if (iscell(yawres.data)) 
    %% In the case of a selected position for the CWT (see option
    %% 'pos' of cwt2d)
    tmp = [yawres.data{:,:}];
    if (size(tmp,1) == 1)
      yashow(tmp,'x',yawres.ang, varargin{:});
    elseif (size(tmp,2) == 1)
      yashow(tmp,'x',yawres.sc, varargin{:});
    else
      yashow(tmp,'x',yawres.ang,'y',yawres.sc,varargin{:});
    end
    %% Set a good title according to yawres fields
    
  else
    %% Display in the yashow for simple matrix
    yashow(yawres.data(:,:,shsc,shang), varargin{:});
  end
  
  %% Set a good title according to yawres fields
  wavpar = eval([ yawres.wav '([])']);
  nbpar  = length(wavpar);
  wavpar(2:2:end) = num2cell(yawres.para);
  
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
  
  strsc  = sprintf('%g',yawres.sc(shsc));
  strang = sprintf('%g',yawres.ang(shang));
  
  if (~isempty(yawres.pos))
    if (size(tmp,1) == 1)
      title({[ 'CWT2D:' ...
	       ' fixed a=' num2str(yawres.sc) ', b=(' num2str(yawres.pos(1)) ',' num2str(yawres.pos(2)) ')']; ...
	     ['Wavelet: ' yawres.wav ...
	      ' (' strpar ' )' ]});
      xlabel('Angles');
    elseif (size(tmp,2) == 1)
      title({[ 'CWT2D:' ...
	       ' fixed \theta=' num2str(yawres.ang) ', b=(' num2str(yawres.pos(1)) ',' num2str(yawres.pos(2)) ')']; ...
	     ['Wavelet: ' yawres.wav ...
	      ' (' strpar ' )' ]});
      ylabel('Scales');
    else
      title({[ 'CWT2D:' ...
	       ' fixed b=(' num2str(yawres.pos(1)) ',' num2str(yawres.pos(2)) ')']; ...
	     ['Wavelet: ' yawres.wav ...
	      ' (' strpar ' )' ]});
      xlabel('Angles');
      ylabel('Scales');
    end      
  else
    title({[ 'CWT2D:' ...
	     ' fixed (a,\theta)=(' strsc ',' strang ')']; ...
	   ['Wavelet: ' yawres.wav ...
	    ' (' strpar ' )' ]});
    xlabel('X');
    ylabel('Y');
  end
end    

%% Setting to 14 the size of the different text
set(get(gca,'title'), 'fontsize', 14);
set(get(gca,'xlabel'), 'fontsize', 14);
set(get(gca,'ylabel'), 'fontsize', 14);


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
