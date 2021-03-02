function obj = fwt2d_init(tI, framename, J, K, varargin)
% \manchap
%
% \mansecSyntax
%
% [] = fwt2d\_init()
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[] []: 
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
% \mansecSeeAlso
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/2d/fwt2d_init.m,v 1.5 2003-12-19 22:59:46 ljacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Recording the image Fourier Transform
obj.tI = tI;

%% Computing the frequency map only one times
[obj.kx,obj.ky] = yapuls2(fliplr(size(tI)));
obj.dkxdky = (obj.kx(1,2)-obj.kx(1,1)) * (obj.ky(2,1)-obj.ky(1,1));

%% The type of the object relatively to other possible YAWtb
%% transforms
obj.type = 'fwt2d';

%% Frame settings
obj.frame.name = framename;

%% Getting info on the frame
if ~exist([framename '2d_info'])
  obj.frame.info = {};
else
  obj.frame.info = feval([framename '2d_info']);
end

%% Setting the different functions
obj.frame.app.name = getopts(obj.frame.info, 'app', [ framename '2d_app']);
obj.frame.high.name = getopts(obj.frame.info, 'high', [ framename '2d_high']);
obj.frame.wav.name = getopts(obj.frame.info, 'wav', [ framename '2d_wav']);

if (~exist(obj.frame.wav.name))
  disp(['Sorry, the frame ''' framename ''' is incomplete.']);
  disp('It must contain at least wavelet definitions.');
  disp('If it yours, check the files of yawtb/discrete/frames/2d/frame_defs/');
  disp('If not, please mail a bug report to yawtb-devel@lists.sourceforge.net');
  return;
else
  obj.frame.wav.opts = yawopts(varargin, obj.frame.wav.name);
end

if (~exist(obj.frame.app.name))
  disp('Warning: non existing scaling function.');
  obj.frame.app.name = [];
else
  obj.frame.app.opts = yawopts(varargin, obj.frame.app.name);
end

if (~exist(obj.frame.high.name))
  disp('Warning: non existing high frequency residual function.');
  obj.frame.high.name = [];
else
  obj.frame.high.opts = yawopts(varargin, obj.frame.high.name);
end

%% Information for the rebuilding
obj.frame.type = getopts(obj.frame.info, 'type', 'none');
switch lower(obj.frame.type)
 case 'linear', 
  %% Tight linear frame
  obj.frame.dualdef = 1;
  obj.frame.dapp.name = 'freq_delta';
  obj.frame.dhigh.name = 'freq_delta';
  obj.frame.dwav.name = 'freq_delta';
  obj.frame.dapp.opts = {};
  obj.frame.dhigh.opts = {};
  obj.frame.dwav.opts = {};
  
 case 'quadratic', 
  %% Tight quadratic frame
  obj.frame.dualdef = 1;
  obj.frame.dapp.name = obj.frame.app.name;
  obj.frame.dhigh.name = obj.frame.high.name;
  obj.frame.dwav.name = obj.frame.wav.name;
  obj.frame.dapp.opts = obj.frame.app.opts;
  obj.frame.dhigh.opts = obj.frame.high.opts;
  obj.frame.dwav.opts = obj.frame.wav.opts;
  
 case 'biorthogonal', 
  %% Frame with defined dual functions
   obj.frame.dualdef = 1;
   obj.frame.dapp.name = getopts(obj.frame.info, 'dapp', [ framename '2d_dapp']);
   obj.frame.dhigh.name = getopts(obj.frame.info, 'dhigh', [ framename '2d_dhigh']);
   obj.frame.dwav.name = getopts(obj.frame.info, 'dwav', [ framename '2d_dwav']);
   obj.frame.dapp.opts = yawopts(varargin, obj.frame.dapp.name);
   obj.frame.dhigh.opts = yawopts(varargin, obj.frame.dhigh.name);
   obj.frame.dwav.opts = yawopts(varargin, obj.frame.dwav.name);
   
 case 'none', 
  %% Nothing, 'allwav' must 
  %% be computed for the dual funtions
  obj.frame.dualdef = 0;
end


%% Numerical parameters settings
obj.J = J;
[obj.sJ,varargin] = getopts(varargin,'octave',1);
[obj.J0,varargin] = getopts(varargin,'j0',0);
if (rem(obj.J0,1) ~= 0) | (obj.J0 < 0) | (obj.J0 >= obj.J)
  error('''J0'' must be a positive integer in [0,J[');
end

obj.ismultisel = getopts(varargin, 'multisel', [], 1);

if (obj.ismultisel)
  if (rem(log2(K),1) ~= 0)
    error('K must be a power of 2 for multiselectivity mode');
  end
  obj.K = 2*K - 1;
  
  obj.Ks = [];
  for l = 0:log2(K);
    obj.Ks = [obj.Ks 2^l*ones(1,2^l)];
  end
else
  obj.K = K;
  obj.Ks = K*ones(1,K);
end

sJ_1 = 1/obj.sJ;
obj.sc = 2.^(obj.J0 : sJ_1 : (J-sJ_1));
obj.nsc = length(obj.sc);

obj.ang = vect(0,2*pi, K, 'open');
if (obj.ismultisel)  
  cang = obj.ang;
  for l = 1:log2(K)
    obj.ang = [cang(1:2^l:end) obj.ang];
  end
end

%% Scales for obj.allwav computation
obj.asc = 2.^((obj.J0-2) : sJ_1 : (J-sJ_1));

[obj.sel_sc,varargin] = getopts(varargin, 'sel_sc', []);
[obj.sel_ang,varargin] = getopts(varargin, 'sel_ang', []);

obj.extra = varargin;

%% Initializing all the possible transforms
obj.allwav = [];
obj.app = [];
obj.high = cell(1, obj.K);
obj.wav = cell(obj.nsc, obj.K);

if (obj.ismultisel)
  obj.lmax_high = [];
  obj.lmax = [];
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
