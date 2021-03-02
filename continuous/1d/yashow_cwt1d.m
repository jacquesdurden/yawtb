function yashow_cwt1d(yawres,varargin)
% \manchap
%
% Display the result of \libfun{cwt1d}. Automatically called by
% \libfun{yashow}!
%
% \mansecSyntax
%
% cwt1d\_yashow(yawres[,'thresh',thresh] [,'edgeeffect'])
%
% \mansecDescription
%
% This function displays the result of the \libfun{cwt1d} function. It is
% automatically called by \libfun{yashow} with respect to the type of
% \libvar{yawres}, that is, the name of \libvar{yawres.type}. 
% 
% \mansubsecInputData
%
% \begin{description}
% \item[yawres] [YAWTB OBJECT]: the input structure coming from
% \libfun{cwt1d}.
%
% \item[thresh] [REAL SCALAR $\in[0,1]$]: the thresholding of the displayed
% matrix. Default value is 0.05 that is 5\%.
% \end{description} 
%
% \item['edgeeffect'] [BOOL]: display the edge effects on the cwt.
%
% \mansubsecOutputData
%
% \mansecExample
% \begin{code} 
% >> sig = yachirp;
% >> sc = vect(4, 50, 128, 'log');
% >> wav = cwt1d(fft(sig), 'morlet', sc);
% >> yashow(wav, 'mode', 'angle');
% \end{code} 
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/1d/cwt.*  ^continuous/1d/wave_defs/.*  /yashow$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1d/yashow_cwt1d.m,v 1.7 2004-05-17 15:07:31 ljacques Exp $
%
% Copyright (C) 2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Taking the specific options of cwt1d
[t,varargin]      = getopts(varargin,'t',1:size(yawres.data,2));
[fig,varargin]    = getopts(varargin,'fig',gcf);
[thresh,varargin] = getopts(varargin,'thresh',0.05);

%%%%%%%%%%%% DISPLAY PART %%%%%%%%%%%%%%%%

figure(fig);


%% ============================
%% ---- Showing the signal ----
%% ============================

plot_up=subplot(2,1,1);
tmp_sig = ifft(yawres.fsig);
tmp_sig_r = real(tmp_sig);
tmp_sig_i = imag(tmp_sig);
plot(tmp_sig_r);

if (max(abs(tmp_sig_i)) > (max(abs(tmp_sig_r))/1000) )
  hold on
  plot(tmp_sig_i,'r');
  legend('Real','Imag');
end
axis('tight');

% ylab = ylabel('Signal')
% set(ylab,'position',[0.1300    0.7700    0.7750    0.1000]);
% set(get(gca,'ylabel'), 'fontsize', 14);

set(gca,'ytick',[]);
set(gca,'xtick',[]);

%% Set a good title according to yawres fields
wavpar = feval(yawres.wav,[]);
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

wavname = yawres.wav;
title({[ 'CWT1D ' ]; ...  
       ['Wavelet: ' upper(wavname(1)) lower(wavname(2:end)) ' (' ...
	strpar ')' ]});

set(get(gca,'title'), 'fontsize', 14);

%% ============================================
%% ---- Display of the time-frequency plan ----
%% ============================================

% Selecting the good subfigure
plot_down = subplot(2,1,2);

% Thresholding yawres.data to 'thresh' (def. 5) percent of its
% absolute value.

ndata = yathresh(yawres.data, thresh);
  

% Determining if the scale are in log representation
sc      = yawres.sc;
logsc   = ( abs((sc(1)/sc(2)) - (sc(2)/sc(3))) < 10*eps );
  
if logsc
  nsc = log(sc);
else
  nsc = sc;
end

% Showing the result
feval('yashow', ndata, 'x', t/yawres.sampling, 'y', nsc, ...
      'fig',fig, varargin{:});

if getopts(varargin, 'edgeeffect', [], 1)
  hold on
  edge = zeros(1,size(yawres.data,2));
  edge(1) = 1;
  edge(end) = 1;
  tedge = fft(edge);
  wedge = cwt1d(tedge, yawres.wav, yawres.sc, yawres.extra{:});
  wedge = abs(wedge.data);
  contour(t,nsc,wedge,3,'w');
  hold off
end


if (yawres.sampling ~= 1)
  xlabel(['Position (Sampl. ' num2str(yawres.sampling) 'Hz)']);
else
  xlabel('Positions');
end

if logsc
  ylabel('Log of Scales');
else
  ylabel('Scales');
end

set(get(gca,'ylabel'), 'fontsize', 14);
set(get(gca,'xlabel'), 'fontsize', 14);

%%%%%%%%%%%% RESIZING %%%%%%%%%%%%%%%

set(plot_up,  'position',[0.1300    0.77    0.7750   0.1]);
set(plot_down,'position',[0.1300    0.12    0.7750   0.648]);

if ((getopts(varargin,'showfreq',[],1)) & (strcmp(yawres.wav,'morlet1d')))
  %% Determining frequencies
  %  
  h1 = plot_down;
  
  h1_pos = get(h1,'position');
  h1_sc = get(h1, 'ytick');
  
  if (logsc)
    freq = yawres.sampling * (yawres.para(1)/(2*pi)) ./ exp(h1_sc);
  else
    freq = yawres.sampling * (yawres.para(1)/(2*pi)) ./ h1_sc;
  end
  
  h1_xlim = get(h1, 'xlim');
  h1_ylim = get(h1, 'ylim');
  
  h2 = axes('units', 'normalized', 'position', h1_pos, ...
	    'XaxisLocation', 'bottom', ... 
	    'YAxisLocation', 'right', 'color', 'none', ...
	    'xlim',h1_xlim, 'ylim', h1_ylim, ...
	    'xtick', [], 'ydir', 'reverse', ...
	    'ytick', h1_sc, 'yticklabel', round(100*freq)/100);
  h2_ylab = get(h2, 'ylabel');
  set(h2_ylab, 'string', 'Frequencies');
  
  
  axes(h1);
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
