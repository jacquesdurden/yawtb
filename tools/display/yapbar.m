function [oyapbar] = yapbar(oyapbar, mode, msg)
% \manchap
%
% This function create a figure with a progress bar.
%
% \mansecSyntax
%
% oyapbar = yapbar([], lim )
% oyapbar = yapbar(oyapbar, iter )
% oyapbar = yapbar(oyapbar, 'Close');
%
% \mansecDescription
% This function create a progress bar inside a figure. This is
% useful inside long computatino program.
%
% \mansubsecInputData
% \begin{description}
% \item[oyapbar] [STRUCT]: progress bar object returned by the
% initialization with oyapbar set to [].
% \item[lim] [INTEGER]: the limit of the progress bar.
% \item[iter] [INTEGER| '++' | '--']: the iterator. In its
% numerical form, it must be greater than 0 and lesser than the
% original lim.
% \item['Close'] [BOOLEAN]: tell to yapbar to close the progress bar
% and set oyapbar to [].
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[oyapbar] [STRUCT]: the progress bar object.
% \end{description} 
%
% \mansecExample
% Initialization of the yapbar object (10 is the number of steps):
% \begin{code}
% >> oyap = yapbar([],10);
% \end{code}
%
% Progression of the yapbar:
% \begin{code}
% >> for k=1:10, ...
%    oyap = yapbar(oyap,'++'); ...
%    end
% \end{code}
%
% Closing of this yapbar:
% \begin{code}
% >> oyap = yapbar(oyap,'close');
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
% $Header: /home/cvs/yawtb/tools/display/yapbar.m,v 1.19 2007-10-18 08:52:35 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Initialization
is_visible = strcmp(getyawtbprefs('yapbarVisible'),'on');
is_graphic = strcmp(getyawtbprefs('yapbarMode'),'graphic');

if (~exist('msg'))
  msg = '';
end

%% Check if the user want a progress bar
if ~is_visible
  return;
end

%% Determining the calling application (caller)
if ((isunix) & (strcmp(version('-release'),'13')))
  caller = dbstack;
  caller = caller(min(2,length(caller))).name;
  pos    = yastrfind(caller,'/');
  caller = caller((pos(end)+1):end);
  pos    = yastrfind(caller,'.');
  caller = caller(1:pos(1)-1);
  if strcmp(caller,'yapbar')
    caller = '';
  end
else
  caller = '';
end     

%% If oyapbar is empty, we create the progress bar.
if isempty(oyapbar)
  oyapbar.iter  = 0;
  
  if ~isnumeric(mode)
    error('You have to provide a numerical value for the limit');
  end
  
  oyapbar.lim   = mode;
  oyapbar.text  = '  0.0%';
  
  if is_graphic 
    oyapbar.fig   = figure;
    oyapbar.hrect = rectangle('position', [0 0 eps 1]);
    oyapbar.htbox = rectangle('position', [0.46 0.2 0.12 0.6]);  
    oyapbar.htext = text(0.48,0.5,oyapbar.text);
  
    fig   = oyapbar.fig;
    htbox = oyapbar.htbox;
    hrect = oyapbar.hrect;
  
    set(fig,'MenuBar','none');

    %% Setting the title with the calling function
  
    if isempty(caller')
      set(fig,'Name','Progress Bar');
    else
      set(fig,'Name',['Progress Bar (' caller ')']);
    end
    
    set(fig,'NumberTitle','off');
    
    set(gca,'xlim',[0 1]); 
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    set(gca,'box','on');
    set(hrect,'facecolor','blue'); 
    set(htbox,'facecolor','white'); 
    set(fig,'position',[200 404 301 32]);
  
    drawnow;
  else
    if isempty(caller)
      oyapbar.text = sprintf('[%s]',oyapbar.text);
    else
      oyapbar.text = sprintf('[%s:%s]',caller,oyapbar.text);
    end    
    fprintf('%s',oyapbar.text);
  end
  return;
end
  
%% If the yapbar figure has been deleted during the process which
%% use it.
  
if is_graphic 
  if (all(get(0,'children') ~= oyapbar.fig))
    return;
  end
end

%% If this is the end, we close the progress bar
if (strcmp(lower(mode),'close')) & (~isempty(oyapbar))
  if is_graphic 
    delete(oyapbar.fig);
  else
    fprintf('\n');
  end
  oyapbar = [];
  return;
end


%% Testing all the possible incrementations
if strcmp(mode,'++')
  oyapbar.iter = oyapbar.iter + 1;
elseif strcmp(mode,'--')
  oyapbar.iter = oyapbar.iter - 1;
elseif isnumeric(mode)
  oyapbar.iter = mode;
elseif strcmp(mode,'==')
  %% Nothing change : allow the display of a message 
else
  error(['the iterator be either numeric, either ''++'' or' ...
	 ' ''--''']);
end

%% Simplifying the use of futur variables
if is_graphic 
  fig   = oyapbar.fig;
  hrect = oyapbar.hrect;
  htbox = oyapbar.htbox;
  htext = oyapbar.htext;
end

lim  = oyapbar.lim;
iter = oyapbar.iter;

%% Drawing the change
if (iter <= lim) & (iter >= 0)
  new_text = sprintf('%3.1f%%',iter/lim*100);
  if is_graphic
    set(hrect,'position',[0 0 ((iter/lim)+eps) 1]);
    set(htext,'string',new_text);
    htextpos = get(htext,'extent');
    htboxpos = get(htbox,'position');
    htboxpos(3) = htextpos(3) + 0.015;
    set(htbox,'position',htboxpos);
    drawnow;
    if (~empty(msg))
      disp(msg);
    end
  else
    if isempty(caller)
      new_text = ['[' repmat(' ',1,6-length(new_text)) new_text '] ' msg];
    else
      new_text = ['[' caller ':' repmat(' ',1,6-length(new_text)) new_text ...
                  '] ' msg];
    end
    if (~strcmp(new_text, oyapbar.text))   
      prev_text_lgth = length(oyapbar.text);
      oyapbar.text = new_text;
      fprintf(repmat('\b',1,prev_text_lgth));
      fprintf('%s',oyapbar.text);
    end
  end
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
