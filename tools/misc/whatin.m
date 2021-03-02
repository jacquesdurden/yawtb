function whatin(mat)
% \manchap
%
% Return information about a matrix
%
% \mansecSyntax
%
% whatin mat
% whatin(mat)
%
% \mansecDescription
% Return the major information of a matrix mat.
%
% \mansubsecInputData
% \begin{description}
% \item[mat] [MATRIX|STRING]: the input matrix or its name in the
% matlab workspace. 
% Note:
% Don't use a name of variable inside a mfile because 'whatin' 
% looks for the variable in the 'base' workspace.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> whatin(rand(5,5) + i*rand(5,5))
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
% $Header: /home/cvs/yawtb/tools/misc/whatin.m,v 1.11 2002-11-21 10:18:07 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if ischar(mat)
  try 
    mat = evalin('base',mat);
  catch
    disp(['Sorry, the variable ' upper(mat) ' doesn''t exist']);
    return;
  end
end

%% Determining the memory used by mat
tmp   = whos('mat');
bytes = tmp.bytes;

if (bytes > (1024*1024))
  bytes = [ num2str( round(100 * bytes / (1024^2))/100 ) 'Mb'];
elseif (bytes > 1024)
  bytes = [ num2str( round(100 * bytes / (1024))/100 ) 'Kb'];
else
  bytes = num2str( bytes );
end

%% Various sizes
dims  = size(mat);
ndim  = length(dims);
tdim  = ndim;

%% Various minimum/maximum.
mat   = double(mat);
rmat  = real(mat);
imat  = imag(mat);
armat = abs(rmat);
aimat = abs(imat);

mr = min(rmat,[],1);
mi = min(imat,[],1);
Mr = max(rmat,[],1);
Mi = max(imat,[],1);

mar = min(armat,[],1);
mai = min(aimat,[],1);
Mar = max(armat,[],1);
Mai = max(aimat,[],1);

tdim = tdim - (dims(1)==1);
  

for k = 2:ndim,
  mr = min(mr,[],k);
  mi = min(mi,[],k);
  Mr = max(Mr,[],k);
  Mi = max(Mi,[],k);
  
  mar = min(mar,[],k);
  mai = min(mai,[],k);
  Mar = max(Mar,[],k);
  Mai = max(Mai,[],k);
  
  tdim = tdim - (dims(k)==1);
end


%fprintf(['Here are some information about the input matrix' ...
%	 ' %s:\n\n'], inputname(1));

tsize = '(';
for k = 1:tdim,
  if (tdim == 1)
    tsize = [ tsize num2str(length(mat)) ];
  elseif (k == 1)
    tsize = [ tsize num2str(size(mat,k)) ];
  else
    tsize = [ tsize 'x' num2str(size(mat,k)) ];
  end
end
tsize = [ tsize ')' ];


fprintf('\n');
flprintf(' Dims: %i %s',tdim,tsize,20,...
	 '|      Real',20, ...
	 '|      Imag',20 );
fprintf('\n');
fprintf(' -----------------------------------------------------------\n');
flprintf(' Minimum:',20,...
	 '| %s%e',str_sign(mr),mr,20, ...
	 '| %s%e',str_sign(mi),mi,20);
fprintf('\n');
flprintf(' Maximum:',20,...
	 '| %s%e',str_sign(Mr),Mr,20, ...
	 '| %s%e',str_sign(Mi),Mi,20);
fprintf('\n');
flprintf(' ABS Minimum:',20,...
	 '| %s%e',str_sign(mar),mar,20, ...
	 '| %s%e',str_sign(mai),mai,20);
fprintf('\n');
flprintf(' ABS Maximum:',20,...
	 '| %s%e',str_sign(Mar),Mar,20, ...
	 '| %s%e',str_sign(Mai),Mai,20);
fprintf('\n');
fprintf(' -----------------------------------------------------------\n');
fprintf(' %s used in memory\n\n', bytes);


function str = str_sign(val)
if (val >= 0)
  str=' ';
else
  str='';
end

%% Print string in a fixed length area
function flprintf(varargin)
% Format:
%   flprintf( string_1,val1,...,valN, lgmax_1, ...
%            ...
%            string_M,val1,...,valN, lgmax_M)
space = ['                                    '];
space = [space '                                    '];
k     = 1;

while (k <= nargin )
  
  str   = varargin{k};
  nbopt = length(yastrfind(str,'%'));
  lgmax = varargin{k+nbopt+1};
  
  sstr   = sprintf(varargin{k:k+nbopt});
  lgsstr = length(sstr);
  
  if (lgsstr <= lgmax)
    sstr = [ sstr space(1:lgmax-lgsstr) ];
  else
    sstr = [ sstr(1:lgmax-3) '...' ];
  end
  fprintf(sstr);
  
  k = k + nbopt + 2;
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
