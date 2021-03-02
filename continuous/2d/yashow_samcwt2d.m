function yashow_samcwt2d(yawres,varargin)
% \manchap
% 
% Display the samcwt2d results (internal use)
%
% \mansecSyntax
% msacwt2d\_yashow(yawres)
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[] 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[]
% \end{description} 
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
% $Header: /home/cvs/yawtb/continuous/2d/yashow_samcwt2d.m,v 1.2 2002-11-21 10:21:16 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ~strcmp(yawres.type,'samcwt2d')
  error('Invalid input argument');
end

wavname = yawres.wav;
Wavname = [ upper(wavname(1)) lower(wavname(2:length(wavname))) ];
sc      = yawres.sc;
ang     = yawres.ang;
data    = yawres.data;

%% Set a good title according to yawres fields
wavpar = eval([ yawres.wav '([])']);
nbpar  = length(wavpar);
%% wavpar(2:2:nbpar) = yawres.para{:};

strpar = '';
for l = 1:nbpar, 
  if l == 1
    strpar = [ strpar ' ' wavpar{l} ]; 
  elseif rem(l,2)
    strpar = [ strpar ', ' wavpar{l} ]; 
  else
    strpar = [ strpar '=' num2str(yawres.para{l/2}) ]; 
  end
end

if (length(ang) == 1) 
  yashow(data, 'x', sc, varargin{:});
  title(['2D CWT Scale Measure (' Wavname ',' strpar ')']);
  xlabel('Scales');
  ylabel('SAM');
  
elseif (length(sc) == 1)
  yashow(data, 'x', ang, varargin{:});
  title(['2D CWT Angle Measure (' Wavname ',' strpar ')']);
  xlabel('Angles');
  ylabel('SAM');
  
else
  yashow(data, 'x', ang, 'y', sc);
  title(['2D CWT Scale-Angle Measure (' Wavname ',' strpar ')']);
  xlabel('Angles');
  ylabel('Scales');
  
  %% Determining the colormap ('jet' is default)
  [cmap,varargin] = getopts(varargin,'cmap','jet');
  
  if ~isnumeric(cmap)
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
  colorbar;
  
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
