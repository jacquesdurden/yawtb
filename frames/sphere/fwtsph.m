function out = fwtsph(mat, wavname, varargin)
% \manchap
%
% Framed Wavelet Transforn on the sphere
%
% \mansecSyntax
%
% out = fwtsph( mat, wavname, ...
%              [,'WaveletOptionName', WaveletOptionValue], ...
%              [,'a0', a0], [,'tg'], [,'voice', voice]);
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[mat] [REAL MATRIX]: The spherical signal on an equiangular
% spherical grid. Its size must be $2^M+1 x 2^N$ with $M$ and $N$ positive integer.
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
% to the rule selected ('tangential' or 'dyadic'). Default value: $a_0=4$.
%
% \item[tg] [BOOL]: Use a tangential scale sequence, that is 
% $a_j = a_0 tan((\pi/4) 2^{-j})$, instead of the default dyadic one, i.e.
% $a_j = a_0 2^{-j}$
%
% \item[voice] [INT]: Number of voice in each scale octave. Default
% value: 1.
%
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [SRUCT]: Structure containing the frame
% coefficients. Imortant fields are:
% \begin{description}
%   \item[out.img] [REAL MATRIX]: the orignal matrix;
%   \item[out.wavname] [STRING]: the name of wavelet;
%   \item[out.wavopts] [MISC]: the parameters of the wavelet;
%   \item[out.J] [INT]: the number of scale equals to $M-1$;
%   \item[out.jv] [INT VECTOR]: scale index; 
%   \item[out.a0] [REAL]: the initial scale where the scale sequence is starded;
%   \item[out.a] [REAL VECTOR]: the scale sequence;
%   \item[out.nth] [INT]: number of theta values in the spherical grid;
%   \item[out.nph] [INT]: number of phi values in the spherical grid;
%   \item[out.lth] [INT]: log2(out.nth -1);
%   \item[out.lph] [INT]: log2(out.nph);
%   \item[out.th\_step] [INT VECTOR]: number of points between two adjacent
%   theta angles in function of scale;
%   \item[out.ph\_step] [INT VECTOR]: number of points between two adjacent
%   phi angles in function of scale;
% \end{description}
%
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> load world
% >> yashow(mat,'spheric','fig',1);
% >> wav=fwtsph(mat,'dog'); %% It's time to drink a cup of coffee!
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
% $Header: /home/cvs/yawtb/frames/sphere/fwtsph.m,v 1.5 2003-08-18 13:56:34 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Warning: nth is such that log2(nth -1) is an integer 
[nth, nph] = size(mat);

if (rem(log2(nth -1),1) ~= 0)
  error('log2(nth -1) must be an integer, e.g. 257');
end

if (rem(log2(nph),1) ~= 0)
  error('''nph'' must be a power of 2');
end

lth = log2(nth -1);
lph = log2(nph);

%% Handling the input
wavname = lower(wavname);

if (exist([wavname 'sph']) >= 2) 
  wavname = [ wavname 'sph'];
elseif (exist(wavname) < 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 'sph'' doesn''t exist!']);
end


%% Number of scales
J = lth - 1;

%% Scale indices (contains one element more than required to allow
%% ifwtsph to compute the weight da = a(j+1)-a(j)/a(j)^2)
nbvoice = getopts(varargin, 'voice', 1);
jv = 0:(1/nbvoice):(J + 1);

%% Angular steps
th_step = 2.^ceil(J - jv(1:end-1));
ph_step = 2.^ceil(J - jv(1:end-1));

%% First scale
a0 = getopts(varargin, 'a0', 2);

%% Scaling rule
if (getopts(varargin,'tg',[],1))
  a = a0*tan( (pi/4) ./ 2.^jv);
else
  a = a0./2.^jv;
end

%% Processing using continuous spherical WT
nj = length(jv)-1;
oyap = yapbar([], nj);

for j = 1:nj,
  wav = cwtsph(mat, wavname, a(j), 0, varargin{:});
  out.data{j} = wav.data(1:th_step(j):end, 1:ph_step(j):end);
  oyap = yapbar(oyap, '++');
end
oyap = yapbar(oyap, 'close');

%% Recording important information for rebuilding
out.img = mat;

out.wavname = wavname;
out.wavopts = yawopts(varargin, wavname); 

out.J = J;
out.jv = jv;
out.nbvoice = nbvoice;

out.a0 = a0;
out.a = a;

out.nth = nth;
out.nph = nph;
out.lth = lth;
out.lph = lph;

out.th_step = th_step;
out.ph_step = ph_step;

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
