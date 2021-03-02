function yashow_wpck2d(yawres, varargin)
% \manchap
%
% Display the output of cwt2d. Automatically called by yashow!
%
% \mansecSyntax
% wpck2d\_yashow(yawres [,'approx'] [,'details', index])
%
% \mansecDescription
%
% \mansubsecInputData
% \begin{description}
% \item[] 
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[]
% \end{description} 
%
% \mansecExample
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
% $Header: /home/cvs/yawtb/discrete/packet/2d/yashow_wpck2d.m,v 1.1 2002-07-25 08:59:27 ljacques Exp $
%
% Copyright (C) 2001, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Determining what to show
[approx,varargin]  = getopts(varargin,'approx',[],1);
[detail,varargin]  = getopts(varargin,'details',1);
if (rem(detail,1)) | ...
      (detail < 1) | (detail > (length(yawres.sc) - 1))
  error('detail integer index must be coherent with the scale vector');
end

scales = yawres.sc;
wpck   = yawres.wpck;

%% Generate a string which describe the remaining varargin in an
%% the 'eval' use
strvarargin = '';
for k = 1:length(varargin),
  strvarargin = [ strvarargin sprintf(',varargin{%i}',k) ];
end

%% Display the result

if approx
  eval(['yashow(yawres.approx' strvarargin ');']);
  axis equal;
  axis tight;
  title(['Approximation at scale ' ...
	 num2str(scales(length(scales))) ...
	 ' with the ' wpck ' scaling function']);
  
else
  eval(['yashow(yawres.details(:,:,detail)' strvarargin ')']);
  axis equal;
  axis tight;
  title(['Details at scale ' ...
	 num2str(scales(detail)) ...
	 ' with the ' wpck ' wavelet packet']);
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
