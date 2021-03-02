function [out] = yamax(mat,varargin)
% \manchap
% 
% Determines the regional maxima of a real matrix 
%
% \mansecSyntax
% [out] = yamax(mat ['connect',connexion] [,'pos'] [,'thresh',T] ['dir',angle])
%
% \mansecDescription
% This function determines the local maxima of the real matrix
% 'mat' with a specified pixel connection (4 or 8 neighbours).
%
% \mansubsecInputData
% \begin{description}
% \item[mat] [REAL MATRIX]: the input matrix;
%
% \item[connexion] [INTEGER]: the connection to use: 4 or 8.
%
% \item['pos'] [BOOLEAN]: tell to yamax to give the list of
% the row and column positions of the maxima as result.
%
% \item['strict'] [BOOLEAN]: if you want the strict maximums, that is, 
% strictly greater than their neighbours.
%
% \item[T] [REAL]: a threshold between 0 and 1 for the maxima
% detection. Only maxima greater than minmat + T*(maxmat - minmat)
% are conserved.
%
% \item[angle] [REAL|REAL MATRIX]: determine the maxima of mat in
% the direction angle. This angle is either a scalar, or a matrix
% giving one angle for each element of mat. In the two cases, each
% element of angle must be inside the interval [-pi/2 pi/2].
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [MISC]: 
% If 'pos' is not specified, out is a binary matrix with 1 on
% maxima and 0 elsewhere.
% If 'pos' is specified, out is a struct array, with fields
% \begin{description}
% \item[out.i] the row positions of the maxima;
% \item[out.j] the column positions of the maxima;
% \item[out.lin] the positions in a linear mode such that,
% mat(out.lin) gives all the maxima of mat.
% \end{description}
% \end{description} 
%
% \mansecExample
% The center of a Gaussian
% \begin{code}
% >> [x,y]=meshgrid(vect(-1,1,5));
% >> g=exp(-x.^2-y.^2);
% >> yamax(g)
% \end{code}
% 
% Maxima of this Gaussian in the directions of 0 and pi/4 radian
% \begin{code}
% >> yamax(g,'dir',0)
% >> yamax(g,'dir',pi/4)
% \end{code}
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
% $Header: /home/cvs/yawtb/tools/misc/yamax.m,v 1.10 2002-06-17 15:59:13 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Checking if we want a directionnal maximum detection
[angle, varargin] = getopts(varargin, 'dir', []);
isdir = ~isempty(angle);

if (~isnumeric(angle))
  yahelp('yamax','usage');
  error('''ang'' must be numeric in the directionnal mode');
end

%% Determining the desired connection
[connection, varargin] = getopts(varargin, 'connect', 4);
if (connection ~= 4) & (connection ~= 8)
  yahelp('yamax','usage');
  error('This connection is not supported (4 or 8 only).');
end

%% See if we are interested in strict maximum
[isstrict,varargin] = getopts(varargin,'strict',[],1);

zeroh = 0*mat(1,:);
zerov = 0*mat(:,1);

dmat_r = mat - [mat(:,2:end)  zerov         ];  
dmat_l = mat - [zerov         mat(:,1:end-1)];
dmat_u = mat - [zeroh;        mat(1:end-1,:)];
dmat_d = mat - [mat(2:end,:); zeroh         ];

if (isdir)
  zeroh_1 = 0*mat(1,1:end-1);
  zerov_1 = 0*mat(1:end-1,1);
  
  dmat_ur = mat - [zeroh; [mat(1:end-1,2:end)   zerov_1]];
  dmat_ul = mat - [zeroh; [zerov_1 mat(1:end-1,1:end-1)]];
  dmat_dr = mat - [[mat(2:end,2:end)   zerov_1];   zeroh];
  dmat_dl = mat - [[zerov_1 mat(2:end,1:end-1)];   zeroh];
  
  %% We quantify angle
  angle_step = pi/8; 
  Qangle = zeros(size(angle));
  
  Qangle = Qangle + ( (angle <  ( -pi + angle_step ) ) | ...
		      (angle >  (  pi - angle_step ) ) );  
  
  for k=-3:3,
    Qangle = Qangle + ((angle >= ( (k-1)*pi/4 + angle_step) ) & (angle < (k*pi/4 + angle_step)))*(k+5);
  end
  
  if (isstrict)
    out = (((Qangle==1)|(Qangle==5)) & (dmat_r  > 0) & (dmat_l  > 0)) | ...
	  (((Qangle==2)|(Qangle==6)) & (dmat_dr > 0) & (dmat_ul > 0)) | ...
	  (((Qangle==3)|(Qangle==7)) & (dmat_d  > 0) & (dmat_u  > 0)) | ...
	  (((Qangle==4)|(Qangle==8)) & (dmat_dl > 0) & (dmat_ur > 0));
  else
    out = (((Qangle==1)|(Qangle==5)) & (dmat_r  >= 0) & (dmat_l  >= 0)) | ...
	  (((Qangle==2)|(Qangle==6)) & (dmat_dr >= 0) & (dmat_ul >= 0)) | ...
	  (((Qangle==3)|(Qangle==7)) & (dmat_d  >= 0) & (dmat_u  >= 0)) | ...
	  (((Qangle==4)|(Qangle==8)) & (dmat_dl >= 0) & (dmat_ur >= 0));
  end
  
else
  if (isstrict)
    out = (dmat_r > 0) & (dmat_l > 0) & ...
	  (dmat_u > 0) & (dmat_d > 0);
  else
    out = (dmat_r >= 0) & (dmat_l >= 0) & ...
	  (dmat_u >= 0) & (dmat_d >= 0);
  end
  
  if (connection == 8)
    zeroh_1 = 0*mat(1,1:end-1);
    zerov_1 = 0*mat(1:end-1,1);
    
    dmat_ur = mat - [zeroh; [mat(1:end-1,2:end)   zerov_1]];
    dmat_ul = mat - [zeroh; [zerov_1 mat(1:end-1,1:end-1)]];
    dmat_dr = mat - [[mat(2:end,2:end)   zerov_1];   zeroh];
    dmat_dl = mat - [[zerov_1 mat(2:end,1:end-1)];   zeroh];
    
    if (isstrict)	 
      out = out & (dmat_ur > 0) & (dmat_ul > 0) & ...
	    (dmat_dr > 0) & (dmat_dl > 0);
    else 
      out = out & (dmat_ur >= 0) & (dmat_ul >= 0) & ...
	    (dmat_dr >= 0) & (dmat_dl >= 0);
    end
  end
end
  
%% Applying the threshold
[T,varargin] = getopts(varargin,'thresh',0);
if (T)
  min_mat = min(min(mat));
  max_mat = max(max(mat));
  out = out & (mat >= (min_mat + T * (max_mat - min_mat)));
end

%% Recording the location
if getopts(varargin,'pos',[],1)
  [posi, posj] = find(out);
  out.cache    = out;
  out.i        = posi;
  out.j        = posj;
  out.lin      = posi + (posj-1)*size(mat,1);
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
