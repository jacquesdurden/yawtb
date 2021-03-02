function yashow_cgt1d(yawres,varargin)
% \manchap
%
% Display the result of \libfun{cgt1d}. Automatically called by
% \libfun{yashow}!
%
% \mansecSyntax
%
% cgt1d\_yashow(yawres[,'thresh',thresh])
%
% \mansecDescription
%
% This function displays the result of the \libfun{cgt1d} function. It is
% automatically called by \libfun{yashow} with respect to the type of
% \libvar{yawres}, that is, the name of \libvar{yawres.type}. 
% 
% \mansubsecInputData
%
% \begin{description}
% \item[yawres] [YAWTB OBJECT]: the input structure coming from
% \libfun{cgt1d}.
%
% \item[thresh] [REAL SCALAR $\in[0,100]$: the thresholding of the displayed
% matrix. Default value is 5 \%.
% \end{description} 
%
% \mansubsecOutputData
%
% \mansecExample
% \begin{code} 
% >> load superpos
% >> fsig = fft(sig);
% >> freqs = 0.005: (0.12 - 0.005)/127: 0.12;
% >> wsig = cgt1d(fsig, freqs, 'sigma', 50);
% >> yashow(wsig);
% \end{code} 
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/1d/cgt.* ^continuous/1d/win_defs/.* /yashow$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/continuous/1d/yashow_cgt1d.m,v 1.3 2007-03-21 01:09:14 jacques Exp $
%
% Copyright (C) 2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Taking the specific options of cwt1d
sig_lg = length(yawres.fsig);
sampper = 1/yawres.sampfreq;

[t,varargin]      = getopts(varargin,'t',0:sampper:((sig_lg-1)*sampper));
[fig,varargin]    = getopts(varargin,'fig',[]);
[thresh,varargin] = getopts(varargin,'thresh',5);

if isempty(fig)
  figure;
  fig = gcf;
end

%%%%%%%%%%%% DISPLAY PART %%%%%%%%%%%%%%%%

figure(fig);


%% ============================
%% ---- Showing the signal ----
%% ============================

plot_up=subplot(2,1,1);

tmp_sig = ifft(yawres.fsig);
tmp_sig_r = real(tmp_sig);
tmp_sig_i = imag(tmp_sig);
plot(t, tmp_sig_r);

if (max(abs(tmp_sig_i)) > (max(abs(tmp_sig_r))/1000) )
  hold on
  plot(t, tmp_sig_i,'r');
  legend('Real','Imag');
end
axis('tight');

% ylab = ylabel('Signal')
% set(ylab,'position',[0.1300    0.7700    0.7750    0.1000]);
% set(get(gca,'ylabel'), 'fontsize', 14);

set(gca,'ytick',[]);
set(gca,'xtick',[]);

%% Set a good title according to yawres fields
winpar = eval([ yawres.win '([])']);
nbpar  = length(winpar);
winpar(2:2:nbpar) = num2cell(yawres.para);

strpar = '';
for l = 1:nbpar, 
  if l == 1
    strpar = [ strpar num2str(winpar{l}) ]; 
  elseif rem(l,2)
    strpar = [ strpar ', ' num2str(winpar{l}) ]; 
  else
    strpar = [ strpar '=' num2str(winpar{l}) ]; 
  end
end

winname = yawres.win;
title({[ 'CGT1D ' ]; ...  
       ['Window: ' upper(winname(1)) lower(winname(2:end)) '  (' ...
	strpar ')' ]});

set(get(gca,'title'), 'fontsize', 14);

%% ============================================
%% ---- Display of the time-frequency plan ----
%% ============================================

% Selecting the good subfigure
plot_down = subplot(2,1,2);

% Determining if the scale are in log representation
freqs   = yawres.freqs;
logfr   = ( abs((freqs(1)/freqs(2)) - (freqs(2)/freqs(3))) < 10*eps );

if logfr
  nfreqs = log(freqs);
else
  nfreqs = freqs;
end

% Thresholding yawres.data to 'thresh' (def. 1) percent of its
% absolute value.

mdata = max(max(abs(yawres.data)));
ndata = yawres.data .* ... 
	( abs(yawres.data) >= (mdata .* thresh / 100) );
			 

% Showing the result
eval('yashow(ndata,''x'',t,''y'',nfreqs,''fig'',fig, varargin{:})');


xlabel('Positions');
if logfr
  ylabel('Log of Frequency');
else
  ylabel('Frequency');
end

set(get(gca,'ylabel'), 'fontsize', 14);
set(get(gca,'xlabel'), 'fontsize', 14);

%%%%%%%%%%%% RESIZING %%%%%%%%%%%%%%%

set(plot_up,  'position',[0.1300    0.77    0.7750   0.1]);
set(plot_down,'position',[0.1300    0.12    0.7750   0.648]);


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
