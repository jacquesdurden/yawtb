function out = ffwtsph(mat, wavname, varargin)
% \manchap
%
% Framed Wavelet Transforn on the sphere
%
% \mansecSyntax
%
% out = fwtsph( mat, wavname, ...
%              [,'WaveletOptionName', WaveletOptionValue], ...
%              [,'a0', a0], [, 'b0', b0] [, 'J', J]);
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[mat] [DOUBLE MATRIX] : the original data (cfr \libfun{fst})
%
% \item[wavname] [STRING]: The name of the spherical wavelet (for
% instance 'dog').
%
% \item[WaveletOptionName, WaveletOptionValue] [STRING, MISC]:
% The wavelet parameter name (a string) is followed by its value. See the corresponding
% wavelet mfile (inside continuous/sphere/wav\_defs) to know the
% parameters to enter.
%
% \item[a0] [REAL]: the scale to start de scale sequence according
% aj=a0/2^j with j=-J,..,J. Default value: $a_0=1$.
%
% \item[b0] [REAL]: the half size of the minimal grid associated to
% a0. For instance the DOG requires at least b0=4 for a0=1.
% \end{description} 
%
% \item[J] [INT]: the half-number of resolution. 
% Default value, J = floor(log2(a0*B/3)) + 1;
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [SRUCT]: Structure containing the frame
% coefficients. Imortant fields are:
% \begin{description}
%   \item[out.fimg] [REAL MATRIX]: the Fourier transform of the
%   original image;
%   \item[out.wavname] [STRING]: the name of wavelet;
%   \item[out.wavopts] [MISC]: the parameters of the wavelet;
%   \item[out.J] [INT]: the number of scale (default: log2(a0*B/3));
%   \item[out.jv] [INT VECTOR]: scale index; 
%   \item[out.a0] [REAL]: the initial scale where the scale sequence is starded;
%   \item[out.aj] [REAL VECTOR]: the scale sequence;
%   \item[out.b0] [REAL]: the half size of the minimal grid;
%   \item[out.bj] [REAL VECTOR]: the bandwidth sequence;
% \end{description}
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world2 %% Loading the world map (256 lat x 256 long)
% >> yashow(mat,'spheric','fig',1);
% >> wav=ffwtsph(mat,'dog'); %% It's time to drink a cup of coffee!
% >> yashow(wav.data{1},'spheric','fig',2);
% >> yashow(wav.data{2},'spheric','fig',3);
% >> yashow(wav.data{3},'spheric','fig',4);
% >> yashow(wav.data{4},'spheric','fig',5);
% >> yashow(wav.data{5},'spheric','fig',6);
% >> yashow(wav.data{6},'spheric','fig',7);
% >> yashow(wav.data{7},'spheric','fig',8);
% >> yashow(wav.data{8},'spheric','fig',9);
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
% $Header: /home/cvs/yawtb/frames/sphere/ffwtsph.m,v 1.3 2007-01-15 08:56:03 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Handling the input
wavname = lower(wavname);
fmat = fst(mat);

if (exist([wavname 'sph']) >= 2) 
  wavname = [ wavname 'sph'];
elseif (exist(wavname) < 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 'sph'' doesn''t exist!']);
end

%% First scale
a0 = getopts(varargin, 'a0', 1);

%% Maximal bandwidth (Warning: b0 < 4 causes problem with fst!)
b0 = getopts(varargin, 'b0', 4);
B = size(fmat,1); 

%% Maximal grids
[phi, theta] = sphgrid(2*B, 2*B);

%% Number of scales
J = getopts(varargin, 'J', floor(log2(a0*B/3))+1);
jv = 0:J;
aj = a0 ./ (2.^jv);
bj = min(B,b0 .* (2.^abs(jv)));

%% Processing using continuous spherical WT
nj = length(jv);
oyap = yapbar([], length(jv));

for j = 1:length(jv),
  wav = fcwtsph(fmat, wavname, aj(j), 0, varargin{:});
  out.ffilter{j} = wav.ffilter{1};
  
  %% Defining the subgrid where the coefficients are defined
  [cph, cth] = sphgrid(2*bj(j), 2*bj(j));
  
  out.data{j} = interp2(phi, theta, wav.data, cph, cth);
  oyap = yapbar(oyap, '++');
end

%% High frequencies components
if (getopts(varargin, 'high', [], 1))
  wav = fcwtsph(fmat, wavname, aj(end)/2, 0, varargin{:}, 'fgrid', 4*B);
  out.hffilter = wav.ffilter{1};
  out.hdata = wav.data;
end

oyap = yapbar(oyap, 'close');

%% Recording important information for rebuilding
out.fimg = fmat;

%% Unreachable component for ifst/ifst because of the spherical sampling
out.outband = mat - ifst(fmat);

out.B = B;

out.wavname = wavname;
out.wavopts = yawopts(varargin, wavname); 

out.J = J;
out.jv = jv;

out.a0 = a0;
out.aj = aj;

out.b0 = b0;
out.bj = bj;

out.extra = varargin;

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
