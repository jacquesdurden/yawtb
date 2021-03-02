function pgmwrite(mat,fname)
% \manchap
%
% Write an image in the raw PGM format.
%
% \mansecSyntax
%
% pgmwrite(mat, fname)
%
% \mansecDescription
%
% Write an image 'mat' in a file 'fname' in the raw PGM format.
%
% \mansubsecInputData
% \begin{description}
%
% \item[mat] [ARRAY]: the origanl matrix. If this file is not in
% the uint8 format, it is converted.
%
% \item[fname] [STRING]: the string containing the name of the file
% to write in the current dir.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[] []:
% \end{description} 
%
% \mansecExample
% \begin{code}
% >>
% \end{code}
%
% \mansecReference
%
% Matthew Dailey's writepgm.m file (see http://ai.ucsd.edu/Tutorial/matlab.html)
%
% \mansecSeeAlso
%
% ^tools/io/pgmread$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/io/pgmwrite.m,v 1.4 2002-03-01 15:34:39 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Converting the matrix in the uint8 format;
mmat = min(min(mat));
gmat = max(max(mat)) - mmat;
mat  = uint8(255*(mat-mmat)/gmat);

%% Handling the name of the file
if (length(fname) < 4) | (~strcmp(fname(end-3:end),'.pgm'))
  fname = [ fname '.pgm' ];
end

%% Open the file
file = fopen(fname,'w');
if (file <= 0)
  error(['Unable to open file ' fname ' for writting']);
end

%% Writing pgm information
height = size(mat,1);
width  = size(mat,2);

fprintf(file,'P5\n');
fprintf(file,'# Writed by MATLAB::pgmwrite\n');
fprintf(file,'%d %d\n',width,height);
fprintf(file,'255\n');

%% Writing the raw data
lgdata = fwrite(file,mat,'uchar');

if (lgdata ~= width*height)
  error(['Error in writing ' fname '. Not all data have been' ...
	 ' copied.']);
end

%% Closing the file
fclose(file);

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
