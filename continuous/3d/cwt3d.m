function out = cwt3d(fvol, wavname, scale, angles, varargin)
% \manchap
%
% Compute several 3D continuous wavelet transforms
%
% \mansecSyntax
% out = cwt3d(fvol, wavname, scale, angles, [,WaveletParameter] 
%             [,'Norm',NormValue] ) 
%
% out = cwt3d(fvol, wavname, scale, angles, [,'WaveletOptionName',
%             WaveletOptionValue] [,'Norm',NormValue] )
%
% \mansecDescription
% This function computes the 3d continuous wavelet transform of an
% image. Wavelets are taken inside the sub directory 'wave\_defs' (see  
% the README to know how to write your own wavelet)
%
% \mansubsecInputData
% \begin{description}
% \item[fvol] [CPLX MATRIX]: the fourier transform of the image;
%
% \item[wavname] [STRING]: the name of the wavelet to use; 
%
% \item[scale] [REALS]: contains the scale of the transform. 
%
% \item[angles] [2 REALS]: a 1x2 vector containing the two angles
% of the cwt, that is tha angles (theta,phi). 
%
% \item[WaveletParameter] [MISC]: a wavelet parameter. His type
% depend of the wavelet used. See the corresponding wavelet mfile
% (inside wave\_defs) for the correct parameters.
%
% \item[WaveletOptionName, WaveletOptionValue] [STRING, MISC]:
% Another way of writting wavelet parameters. The wavelet parameter
% name (a string) is followed by its value. See the corresponding
% wavelet mfile (inside wave\_defs) for the parameter to enter.
%
% \item[NormValue] ['l1'|'l2']: is a string which describes the
% normalization of the wavelet transform, namely the 'L1' or 'L2'
% normalization. The 'L2' is taken by default.
%
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRUCT]: the output of the transform. A structured
%   data with the following fields:
%   \begin{itemize}
%   \item "out.data" (the resulting matrix)
%   \item "out.type" (the type of the transform)
%   \end{itemize}
% \end{description}
%
% \mansecExample
%
% \begin{code}
% >> vol  = cube(64);
% >> yashow(vol,'fig',1),
% >> fvol = fftn(vol);
% >> wvol = cwt3d(fvol, 'mexican', 2, [0 0]);
% >> yashow(wvol,'fig',2);
% \end{code}
%
% This code gives the 3D Mexican Hat wavelet transform of a 64 pixel width cube
% for a scale equal to 2. The angles here are useless because of
% the MH isotropicity.
% The implicit values are the Mexcian wavelet parameters: sigma=1.
% For other values, you can type something like
% \begin{code}
% >> wvol  = cwt3d(fvol, 'mexican', 2, [0 0], 2);
% \end{code}
% or,
% \begin{code}
% >> wvol  = cwt3d(fvol, 'mexican', 2, [0 0], 'sigma', 2);
% \end{code}
% This change values of sigma respectively to 2.
% Note that the first example is order dependant and not the second.
%
% Notice that you can change the normalization of the cwt with the
% following command:
% \begin{code}
% >> wvol  = cwt3d(fvol, 'mexican', 2, [0 0], 'sigma', 2, 'norm','l1');
% \end{code}
% for the L1 normalization (and 'l2' for L2).
%
% Finally, you can visualize several transparent layers of the
% result by specifying the number of levels to show: 
% \begin{code}
% >> yashow(wvol,'levels',3)
% \end{code}
%
% \mansecReference
%
% \mansecSeeAlso
%
% ^continuous/3d/.*3d$  ^tools/display/yashow$
%
% \mansecLicense
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"}
%
% $Header: /home/cvs/yawtb/continuous/3d/cwt3d.m,v 1.6 2008-09-09 07:19:13 jacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with 
% this library) (See the notice at the end of the file.)

%% Managing of the input
if (nargin < 4 | nargout > 1)
  error('Argument Mismatch - Check Command Line');
end

if isnumeric(wavname)
  error('''wavname'' must be a string');
end

if (length(angles) < 2)
  if (angles == 0)
    angles = [0 0];
  else
    error(['The angles must be a 1x2 vector containing (theta,phi)' ...
	   ' angles.']);
  end
end

%% The wavelet matlab function must exist (in lower case) in the
%% wave_defs subdir.
%% Note tha the real name can be wavename or [wavname '2d'] to
%% avoid eventuel confusion with 1D wavelets. This case is checked
%% first, before the existence of 'wavname' alone.
wavname = lower(wavname);

if (exist([wavname '3d']) >= 2) 
  wavname = [ wavname '3d'];
elseif (exist(wavname) < 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 '3d'' doesn''t exist!']);
end
  

if ~exist('varargin')
  varargin = {};
end

%% Keeping varargin into output for reproductibility
out.extra = varargin;

%% Input handling
if (~isnumeric(scale)) 
  error('scale must be numeric');
end

if (isempty(fvol)) fvol = 0; end

%% Choice of the normalization ('getopts' is part of yawtb: see the
%% 'utils' yawtb's subdirectory)
[NormChoice,varargin] = getopts(varargin,'norm','l2');
switch lower(NormChoice)
 case 'l2'
  norm = 1.5;
 case 'l1'
  norm = 0;
 otherwise %% Default: the L2 normalization.
  norm = 1.5;
end

%% Determining the wavelet parameters
wavopts    = yawopts(varargin,wavname);
strwavopts = '';
for k=1:length(wavopts)
  strwavopts = [ strwavopts ',wavopts{' num2str(k) '}' ];
end

%% Creation of the frequency plane ('vect' is part of yawtb: see
%% utils directory)
[Hgth,Wdth,Dpth] = size(fvol);
[kx,ky,kz]       = meshgrid( yapuls(Wdth), yapuls(Hgth), yapuls(Dpth) );

out.data    = zeros(Hgth,Wdth,Dpth);

%% Angles considerations
th = angles(1);
ph = angles(2);

cth = cos(th);
sth = sin(th);
cph = cos(ph);
sph = sin(ph);

if (th)
  %% Rotation of phi around the oz axis 
  nkx   = cph*kx - sph*ky;
  nky   = sph*kx + cph*ky;
  nkz   = kz;
  
  %% Rotation of theta around the oy axis
  kx  =  cth * nkx + sth * nkz; 
  ky  =  nky;
  kz  = -sth * nkx + cth * nkz;
end

%% The dilation of scale 'a'
nkx = scale * kx;
nky = scale * ky;
nkz = scale * kz;

%% Call of the wavelet function through 'eval'.
mask = eval([ wavname '(nkx,nky,nkz' strwavopts ')']);

out.data = scale^norm * ifftn(fvol.* conj(mask));

out.type = mfilename;
out.wav  = wavname;
out.para = eval([ '[' strwavopts(2:length(strwavopts)) ']' ]); 
out.sc   = scale;
out.ang  = angles;

%% out.extra is already recorded (see top)

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
