function yashow_cwt1dt(yawres, varargin)
% \manchap
%
% Display the result of cwt1dt. Automatically called by \libfun{yashow}!
%
% \mansecSyntax
% cwt1dt\_yashow(yawres[,'filter'])
%
% \mansecDescription
% This function displays the result of the \libfun{cwt1dt} function which
% computes the 1D+T CWT of a space-time signal. It is
% automatically called by \libfun{yashow} with respect to the type of
% \libvar{yawres}, that is, the name (string) inside the 
% \libvar{yawres.type} field. 
%
% \mansubsecInputData
% \begin{description}
%
% \item[yawres] [YAWTB OBJECT]: the structure returned by \libfun{cwt1dt}.
%
% \item[filter] [BOOLEAN]: If this modifier is set, then the wavelet in
% wave-number/frequency domain is displayed.
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
% ^continuous/1dt/.* /yashow$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1dt/yashow_cwt1dt.m,v 1.2 2002-11-21 10:21:16 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Determining which scale and which velocity to show

[shsc,varargin]  = getopts(varargin,'sc',1);
[shvel,varargin] = getopts(varargin,'vel',1);

if ( (shsc  < 1) | (shsc  > length(yawres.sc)) | ...
     (shvel < 1) | (shvel > length(yawres.vel) ) )
  error('Invalid velocity or scale index value');
end

%% Creating a string which represents the varargin
strvarargin='';
for l=1:length(varargin),
  strvarargin = [ strvarargin sprintf(',varargin{%i}',l) ] ;
end

%% Miscellaneous variables needed for the sequel
nx      = size(yawres.data,2);
nt      = size(yawres.data,1);
scales  = yawres.sc;
velos   = yawres.vel;
wavname = yawres.wav;
csc     = scales(shsc);
cvel    = velos(shvel);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The main part of this YASHOW...    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if getopts(varargin,'filter',[],1)
  
  if (nx == 1) | (nt == 1)
    error(['''filter'' mode doesn''t work for fixed position or' ...
	   ' fixed time.']);
  end
  
  %% In the case of the use of a two dimensional wavelet,
  %% wave-number/frequency domain must be rotated by 45° (assuming 2d
  %% wavelet en X or Y axis)
  twodim = ~isempty(yastrfind(wavname,'2d'));
  
  fk      = vect(-pi,pi,nx,'open');
  fw      = vect(-pi,pi,nt,'open');
  
  [k,w]   = meshgrid(fk, fw);
  
  wavopts = yawopts(varargin,wavname);
  strwavopts = '';
  for l=1:length(wavopts)
    strwavopts = [ strwavopts ',wavopts{' num2str(l) '}' ];
  end

  ncvel = abs(cvel)^0.5;
  
  nk = csc * k * ncvel; 
  nw = csc * w / ncvel * sign(cvel);
  
  if (twodim) %% With 2D wavelet, a 45° rotation is needed 
              %% to place wavelet on a "velocity" 1 pixel/frame
	      %% assuming it originally placed on X or Y axis.
     nk = (nk - nw)/2^0.5;
     nw = nk + 2^0.5*nw;
  end
  
  %% Determining the filter
  mask = eval([ wavname '(nk,nw' strwavopts ')']);
  
  %% and display it in the yashow for simple matrix
  eval(['yashow(mask' strvarargin ',''x'',fk,''y'',fw, ''equal'')']);
  
  %% Display frequency axis
  h1 = line([-pi pi],[0 0]);
  h2 = line([0 0],[-pi pi]);
  set(h1,'LineStyle','--');
  set(h2,'LineStyle','--');
  
  %% Naming the axes
  xlabel('Frequency (k)');
  ylabel('Wave-number (w)');
  axis xy;
  
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
	  '(a,c)=(' num2str(csc) ',' num2str(cvel) ')  ']; ...
	 ['and ' strpar ]});
  
  %% Resizing the window to allow a 2 line title
  set(gca,'position',[0.13 0.11 0.775 0.775]); 

  
%% Mode for fixed velocity 'c' and fixed scale 'a'
elseif (nx>1) & (nt>1) 
  
  %% Display in the yashow for simple matrix
  eval(['yashow(yawres.data(:,:,shsc,shvel)' strvarargin ')']);
  
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
  
  strsc  = sprintf('%g',csc);
  strvel = sprintf('%g',cvel);
  
  title({[ 'CWT1DT:' ...
	  ' fixed (a,c)=(' strsc ',' strvel ')']; ...
	  ['Wavelet: ' upper(wavname(1)) lower(wavname(2:end)) ...
	   ' (' strpar ' )' ]});
  
  xlabel('Position');
  ylabel('Time');
  
  %% Resizing the window to allow a 2 line title
  set(gca,'position',[0.13 0.11 0.775 0.775]); 


% Fixed time representation (cfr. option 'time' of cwt1dt)
elseif (nt == 1) & (nx > 1)
  
  %% Handling the figure number
  [fig,varargin] = getopts(varargin,'fig',gcf);
  figure(fig);
  
  %% Removing 'timeseq' mention
  [null,varargin] = getopts(varargin,'timeseq',[],1);
  
  %% Creating a string which represents the varargin
  strvarargin='';
  for l=1:length(varargin),
    strvarargin = [ strvarargin sprintf(',varargin{%i}',l) ] ;
  end
  
  
  % Selecting the good subfigure
  plot_up = subplot(2,1,1);
  
  %% Display in the yashow for simple matrix
  tmp = squeeze(yawres.data(:,:,shsc,:)).';
  eval(['yashow(tmp' strvarargin ',''y'',velos,''fig'',fig)']);
  
  %% Display zero velocity axis if necessary
  if (velos(1)*velos(end) < 0)
    h = line([1 size(tmp,2)],[0 0]);
    set(h,'LineStyle','--');
  end

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
  
  strsc    = sprintf('%g',csc);
  strtime  = sprintf('%g',getopts(yawres.extra,'time',''));
  strvel   = sprintf('%g',cvel);
  
  title({ [ 'CWT1DT:' ...
	    ' fixed (a,t)=(' strsc ', ' strtime ')'] ; ...
	  [ 'Wavelet: ' upper(wavname(1)) lower(wavname(2:end)) ...
	    ' (' strpar ' )' ]});
  
  ylabel('Velocity');
  set(get(gca,'title'), 'fontsize', 14);
  set(get(gca,'ylabel'), 'fontsize', 14);
  set(gca,'xtick',[]);
  axis xy;
  
  %% The subfigure of the signal
  plot_down = subplot(2,1,2);
  plot(yawres.ftime);
  axis('tight');
  xlabel('Positions');
  set(get(gca,'xlabel'), 'fontsize', 14);
  %%set(gca,'ytick',[]);
  
  %% Resizing of the subfigures
  set(plot_up,  'position',[0.1300    0.2372    0.7750    0.6378]);
  set(plot_down,'position',[0.1300    0.1100    0.7750    0.1272]);

end

%% Setting to 14 the size of the different text
set(get(gca,'title'), 'fontsize', 14);
set(get(gca,'xlabel'), 'fontsize', 14);
set(get(gca,'ylabel'), 'fontsize', 14);




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
