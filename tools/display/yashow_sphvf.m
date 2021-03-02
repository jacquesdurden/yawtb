function yashow_sphvf(vz, varargin)
% \manchap
%  
% Display a vector field on the sphere expressed in complex value  
%
% \mansecSyntax
%
% showsphgrad(vz [,'subsampling', n ])
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[vz] [CPLX MATRIX]: The vector field in complex coordinates (real
% according phi and imaginary according phi)
% \item[n] [INT] particular downsampling to bring to data to display
% something interesting. Default n = max(1,round(max(size(vz))/32)) 
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
% $Header: /home/cvs/yawtb/tools/display/yashow_sphvf.m,v 1.2 2007-11-13 15:06:59 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

[nrow, ncol] = size(vz);
[phi, theta] = sphgrid(nrow, ncol);

vx = real(vz);
vy = imag(vz);

R = 1;
wx = R*sin(theta).*cos(phi);
wy = R*sin(theta).*sin(phi);
wz = R*cos(theta);

%% Computing local basis to tangent plane on w = (wx,wy,wz)
%% e1 = z ^ w
e1x = - wy ./ abs(wx + i*wy);
e1y =   wx ./ abs(wx + i*wy);
e1z = zeros(nrow,ncol);

%% e2 = w ^ e1
e2x = -wx.*wz;
e2y = -wy.*wz;
e2z = wx.^2 + wy.^2;
e2 = (e2x.^2 + e2y.^2 + e2z.^2).^.5;

e2x = e2x./e2;
e2y = e2y./e2;
e2z = e2z./e2;

%% Subsampling
sampling = getopts(varargin, 'subsampling',  max(1,round(max(size(vz))/32)) );

if (sampling ~= 1);
  
  [ind_phi, ind_th] = meshgrid(1:ncol, 1:nrow); 
  gen_ind = ind_th + (ind_phi-1).*nrow;
  spl_gen_ind = [];
  
  for t = 1:sampling:nrow;
    c_spl = min(ncol, 2^round(log2(sampling ./ sin(theta(t,1)))));
    cur_ind = gen_ind(t, 1:c_spl:end);
    spl_gen_ind = [spl_gen_ind; cur_ind(:)];
  end
  
% $$$   wx = wx(1:sampling:end,1:sampling:end);
% $$$   wy = wy(1:sampling:end,1:sampling:end);
% $$$   wz = wz(1:sampling:end,1:sampling:end);
% $$$   
% $$$   e1x = e1x(1:sampling:end,1:sampling:end);
% $$$   e1y = e1y(1:sampling:end,1:sampling:end);
% $$$   e1z = e1z(1:sampling:end,1:sampling:end);
% $$$   
% $$$   e2x = e2x(1:sampling:end,1:sampling:end);
% $$$   e2y = e2y(1:sampling:end,1:sampling:end);
% $$$   e2z = e2z(1:sampling:end,1:sampling:end);
% $$$   
% $$$   vx = vx(1:sampling:end,1:sampling:end); 
% $$$   vy = vy(1:sampling:end,1:sampling:end); 
  
  wx = wx(spl_gen_ind);
  wy = wy(spl_gen_ind);
  wz = wz(spl_gen_ind);
  
  e1x = e1x(spl_gen_ind);
  e1y = e1y(spl_gen_ind);
  e1z = e1z(spl_gen_ind);
  
  e2x = e2x(spl_gen_ind);
  e2y = e2y(spl_gen_ind);
  e2z = e2z(spl_gen_ind);
  
  vx = vx(spl_gen_ind);
  vy = vy(spl_gen_ind);
end

%% Display


mat = getopts(varargin, 'bg', NaN*ones(10,10));

yashow(mat,'spheric', varargin{:});

if isnan(mat(1,1))
  cmap=[.7 .7 .7];
  colormap(cmap);
end

hold on
quiver3(wx, wy, wz, ...
	vx.*e1x + vy.*e2x, ...
	vx.*e1y + vy.*e2y, ...
	vx.*e1z + vy.*e2z );
hold off

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
