function out = cwt2d(fimg, wavname, scales, angles, varargin)
% \manchap
%
% Compute several 2D continuous wavelet transforms
%
% \mansecSyntax
% out = cwt2d(fimg, wavname, scales, angles [,WaveletParameter] 
%             [,'Norm',NormValue] [,'Export'] [,'Contrast']
%             [,'Pos', pos [,'fig',selfig]] [,'Exec', exec] 
%             [,'NoPBar'] )
%
% out = cwt2d(fimg, wavname, scales, angles [,'WaveletOptionName',
%             WaveletOptionValue] [,'Norm',NormValue]
%             [,'Export'] [,'Contrast'] 
%             ['Pos', pos [,'fig',selfig]] [,'Exec', exec] 
%             [,'NoPBar'] )
%
% \mansecDescription
% This function computes the 2d continuous wavelet transform of an
% image. Wavelets are taken inside the sub directory 'wave\_defs' (see  
% the README to know how to write your own wavelet)
%
% \mansubsecInputData
% \begin{description}
% \item[fimg] [CPLX MATRIX]: the fourier transform of the image;
%
% \item[wavname] [STRING]: the name of the wavelet to use; 
%
% \item[scales, angles] [REALS]: contains the scales and the angles of the
% transform. The 'angles' parameter is needed but not use in the
% case of istropic wavelet.
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
% \item[NormValue] ['l0'|'l1'|'l2']: is a string which describes the
% normalization of the wavelet transform, namely the 'L0', 'L1' or
% 'L2' normalization. The 'L2' is taken by default.
%
% \item['Export'] [BOOLEAN]: tell to cwt2d if the output must be
% just a matrix. If the keyword 'Export' is missing, 
% the output is a yawtb object.
%
% \item['Contrast'] [BOOLEAN]: if implemented, normalized the CWT
% by the convolution of the image with a kernel of the same
% geometry than the wavelet. The mfile implementing this kernel has
% a name of the form $<$wavname$>$\_ctr.m. See [1] for
% explanations.
%
% \item[pos] [ARRAY 2x1|'inter']: gives the position vector b 
% ( in (x,y)==(j,i) format) where to compute the CWT. 
% You can also select it interactively on the figure by entering
% the keyword 'inter' instead of the position vector; 
%
% \item[selfig] [INTEGER]: In the interactive 'Pos' mode, you can
% specify the number of the figure where to select the position
% with selfig.
%
% \item[exec] [STRING]: execute a command specified by the string
% 'exec' on each result of the cwt2d transform of each iteration of
% the scale-angle loop. 
%
% 'out.data' is then a cell array of size
% length(scales)*length(angles) which contains
% the result of the application of 'exec' on each CWT of fimg.
%
% Syntax of 'exec': '$<$iter$>$' or '$<$init$>$;$<$iter$>$'
%
% The '$<$init$>$' string contains some commands which have to be executed
% before the loop.
%
% The '$<$iter$>$' string is the command to execute at each iteration.
%
% Special keywords of '$<$iter$>$':
% \begin{itemize}
% \item \$cwt can be used to specified the current CWT coefficients;
% \item \$last the preceeding stored result (you have to initialize \$rec
% to use it);
% \end{itemize}
%
% Special keywords of '$<$iter$>$' and '$<$init$>$':
% \begin{itemize}
% \item \$rec represent the cell array where each computation is stored;
% \item \$fimg represent the FFT of the image.
% \end{itemize}
%
% \item[NoPBar] [BOOLEAN]: Disable the loopbar in case of several
% scales and angles.
%
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[out] [STRUCT]: the output of the transform. If the keyword
% 'Export' is not present, out is a structured
%   data with the following fields:
%   \begin{itemize}
%   \item "out.data" (the resulting matrix),
%   \item "out.type" (the type of the transform),
%   \end{itemize}
% else, out is just a matrix containing the CWT coefficients.
%
% \end{description}
%
% \mansecExample
%
% \begin{code}
% >> [x,y] = meshgrid(-64:64);
% >> img   = max( abs(x), abs(y) ) < 30;
% >> fimg  = fft2(img);
% >> wimg  = cwt2d(fimg, 'morlet', 2, 0);
% >> yashow(wimg);
% \end{code}
% Give the 2D Morlet wavelet transform of a 64 pixel width square
% for a scale equal to 2 and angle equal to 0.
% The implicit values are the Morlet wavelet parameters: w0=6; sigma=1.
% For other values, you can type something like
% \begin{code}
% >> wimg  = cwt2d(fimg, 'morlet', 2, 0, 7, 2);
% \end{code}
% or,
% \begin{code}
% >> wimg  = cwt2d(fimg, 'morlet', 2, 0, 'w0', 7 , 'sigma', 2);
% \end{code}
% This change values of w0 and sigma respectively to 7 and 2.
% Note that the first example is order dependant and not the second.
%
% Finally, you can change the normalization of the cwt with the
% following command:
% \begin{code}
% >> wimg  = cwt2d(fimg, 'morlet', 2, 0, 'w0', 7 , 'sigma', 2, ...
%                  'norm','l1');
% \end{code}
% for the L1 normalization (and 'l2' for L2).
%
% \mansecReference
% [1]: M. Duval-Destin, M.A. Muschietti and B. Torresani, Continous
% wavelet decompositions, multiresolution and contrast analysis"
% SIAM J. Math Anal. 24 (1993).
%
% \mansecSeeAlso
%
% ^continuous/2d/.*2d$  ^tools/display/yashow$
%
% \mansecLicense
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at 
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"}
%
% $Header: /home/cvs/yawtb/continuous/2d/cwt2d.m,v 1.44 2004-08-24 12:43:28 ljacques Exp $
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

%% Seeing if the user want a yawtb object in output or just a
%% matrix (see explanations for 'Export' above).

[export,varargin] = getopts(varargin,'export',[],1);


%% The wavelet matlab function must exist (in lower case) in the
%% wave_defs subdir.
%% Note tha the real name can be wavename or [wavname '2d'] to
%% avoid eventuel confusion with 1D wavelets. This case is checked
%% first, before the existence of 'wavname' alone.
wavname = lower(wavname);

if (exist([wavname '2d']) >= 2) 
  wavname = [ wavname '2d'];
elseif (exist(wavname) < 2)
  error(['The wavelet ''' wavname ''' or ''' wavname ...
	 '2d'' doesn''t exist!']);
end
  

if ~exist('varargin')
  varargin = {};
end

%% Keeping varargin into output for reproducibility
if (~export)
  out.extra = varargin;
end

%% Input handling
if (~all(isnumeric(scales))) | (~all(isnumeric(angles))) 
  error('scale(s) and angle(s) must be numeric');
end

if (isempty(fimg)) fimg = 0; end

%% Choice of the normalization ('getopts' is part of yawtb: see the
%% 'utils' yawtb's subdirectory)
[NormChoice,varargin] = getopts(varargin,'norm','l2');
switch lower(NormChoice)
 case 'l2'
  norm = 1;
 case 'l1'
  norm = 0;
 case 'l0';
  norm = 2;
 otherwise %% Default: the L2 normalization.
  norm = 1;
end

%% Are we in the contrast normalization case ?
[ctr,varargin] = getopts(varargin,'contrast',[],1);
if (ctr)
  if (exist([wavname '_ctr']) >= 2) 
    ctrname = [ wavname '_ctr'];
  else
    error(['The wavelet ''' wavname ''' has no contrast' ...
		    ' implemented!']);
  end    
end

%% Determining if we are in the 'Pos' mode 
[fixpos, varargin] = getopts(varargin,'pos',[]);
defexec = '';
if (~isempty(fixpos))
  if strcmp(fixpos,'inter')
    [fig, varargin] = getopts(varargin, 'fig', gcf);
    figure(fig);
    [xsel, ysel] = ginput(1);
    xsel = max(1,min(size(fimg,2),round(xsel)));
    ysel = max(1,min(size(fimg,1),round(ysel)));
    fixpos  = [xsel, ysel];
    defexec = '$cwt(ysel,xsel)';
    fprintf('CWT computed on (x:%i,y:%i)\n',xsel,ysel);
  elseif (~isnumeric(fixpos))
    error('Unknown mode for the selection of the position');
  end
  defexec = '$cwt(fixpos(2),fixpos(1))';
end

%% Determining if we are in the exec mode
[exec,varargin] = getopts(varargin, 'exec', defexec);
is_exec = ~isempty(exec);
if (is_exec)
  exec = strrep(exec,'$cwt','tmp');
  exec = strrep(exec,'$last','[out.data{end,end}]');
  exec = strrep(exec,'$rec','out.data');
  exec = strrep(exec,'$fimg','fimg');
  sep  = find(exec == ';');
  if (~isempty(sep))
    init_exec = exec(1:sep);
    exec = exec(sep+1:end);
  else
    init_exec ='';
  end
end

%% Determining the wavelet parameters
wavopts    = yawopts(varargin,wavname);

%% Let see if the user don't want a progress bar
[nopbar,varargin] = getopts(varargin, 'NoPBar', [], 1);

%% Creation of the frequency plane ('vect' is part of yawtb: see
%% utils directory)
[Hgth,Wdth] = size(fimg);
[kx,ky] = yapuls2(Wdth, Hgth);
dkxdky = abs( (kx(1,2) - kx(1,1)) * (ky(2,1) - ky(1,1)) );

nsc = length(scales);
nang = length(angles);

if (is_exec)
  out.data  = {};
  if (~isempty(init_exec))
    eval(init_exec);
  end
else
  out.data  = zeros(Hgth,Wdth,nsc,nang);
end

isloop = (nsc*nang > 1);

if (isloop)
  if (~nopbar)
    oyap = yapbar([],nsc*nang);
  end
  
  for sc = 1:nsc,
    for ang = 1:nang,
      if (~nopbar)
	oyap = yapbar(oyap,'++');
      end
      
      csc  = scales(sc);
      cang = angles(ang);
      
      [nkx, nky] = yadiro(kx, ky, csc, cang, 'freq');
      
      %% Call of the wavelet function through 'eval'.
      mask = csc^norm * feval(wavname, nkx,nky,wavopts{:});
      
      if (is_exec)
	tmp = ifft2(fimg.* conj(mask));
	out.data{sc,ang} = eval(exec);
      else
	out.data(:,:,sc,ang) = ifft2(fimg.* conj(mask));
	out.wav_norm(sc, ang) = (sum(abs(mask(:)).^2)*dkxdky)^0.5/(2*pi);
      end
      
      if ( (ctr) & (~is_exec) )
	%% The kernel in the frequency space
	mask  = csc^norm * feval(ctrname, nkx,nky,wavopts{:});
	%% The local luminence (must be real) according to this kernel
	lumin = real(ifft2(fimg.* conj(mask)));
	%% Definition of the contrast
	out.data(:,:,sc,ang) = (out.data(:,:,sc,ang) ~= 0) .* ...
	    out.data(:,:,sc,ang) ./ lumin;
	out.wav_norm(sc, ang) = (sum(abs(mask(:)).^2)*dkxdky)^0.5/(2*pi);
      end
      
    end
  end
  
  if (~nopbar)
    oyap = yapbar(oyap,'close');
  end
  
else
  
  [nkx, nky] = yadiro(kx, ky, scales, angles, 'freq');

  %% Call of the wavelet function through 'eval'.
  mask = scales^norm * feval(wavname, nkx,nky,wavopts{:});
  
  out.data = ifft2(fimg .* conj(mask));
  out.wav_norm = (sum(abs(mask(:)).^2)*dkxdky)^0.5/(2*pi);

  if (ctr)
    %% The kernel in the frequency space
    mask  = feval(ctrname, nkx,nky,wavopts{:});
    %% The local luminence (must be real) according to this kernel
    lumin = real(scales^norm * ifft2(fimg.* conj(mask)));
    %% Definition of the contrast
    out.data = (out.data ~= 0) .* out.data ./ lumin;
  end
end
  
%% Setting the output
if (export)
  out = out.data;
else
  out.type  = mfilename;
  out.wav   = wavname;
  out.para  = [ wavopts{:} ]; 
  out.sc    = scales;
  out.ang   = angles;
  %% out.extra is already recorded (see top)
  out.pos   = fixpos;
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
