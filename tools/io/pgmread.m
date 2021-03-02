function [mat] = pgmread(fname)
% \manchap
%
% Read an image in the raw PGM format (8bits).
%
% \mansecSyntax
%
% [mat] = pgmread(fname)
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[fname] [STRING]: the name of the file to read. 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [ARRAY]: a matrix containing the image.
% \end{description} 
%
% \mansecExample
% \begin{code}
% >>
% \end{code}
%
% \mansecReference
%
% Matthew Dailey's readpgm.m file (see http://ai.ucsd.edu/Tutorial/matlab.html)
%
% \mansecSeeAlso
%
% ^tools/io/pgmwrite$
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/io/pgmread.m,v 1.4 2002-03-01 15:34:39 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Handling input
if ~ischar(fname)
  error('You have to provide a string for the file name');
end

%% Open the file
file = fopen(fname);

%% Check if it is really a pgm file
str = fgets(file);
while (str(1) == '#')
  str = fgets(file);
end
if ~strcmp(str(1:2), 'P5')
  error('You file in not in the PGM format');
end

%% Obtaining the different sizes

%% Avoiding to take commentary lines
str  = fgets(file);
while (str(1) == '#')
  str = fgets(file);
end

pgmsize = sscanf(str,'%d');
nrow    = pgmsize(2);
ncol    = pgmsize(1);
total   = nrow*ncol;

%% Checking if we are in the gray mode
str     = fgets(file);
while (str(1) == '#')
  str = fgets(file);
end

levels  = sscanf(str,'%d');
if (levels ~= 255)
  error('pgmread can only read 8bits pgm images');
end

%% Introducing data into the matrix
[mat, lg] = fread(file, inf, 'uchar');
if (lg ~= total)
  error('Corrupted pgm file');
end

%% Reshaping mat to its true size
mat = reshape(mat,nrow,ncol);

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
