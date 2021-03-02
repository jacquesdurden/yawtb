function scp = sphscp(f1, f2)
% Compute the spherical scalar product on L²(S²) between two functions
%
% \mansecSyntax
%
% scp = sphscp(f1, f2)
%
% \mansecDescription
%
% Compute the scalar product on L²(S²) between two functions f1 and f2
% discretized on the same equi-angular grid. These function are of course
% assumed band limited to allow such a discrtization.
%
% \mansubsecInputData
% \begin{description}
% \item[f1] [CPLX MATRIX]: function 1 on the grid
% \item[f2] [CPLX MATRIX]: function 2 on the grid
% \end{description} 
%
% \mansubsecOutputData
% \begin{description}
% \item[scp] [REAL]: value of the scalar product
% \end{description} 
%
% \mansecExample
% \begin{code}
% >> [phi,theta] = sphgrid(256);
% >> f=exp(-tan(theta/2).^2).*cos(6*phi);
% >> sphcp(f,f)
% \end{code}
%
% \mansecSeeAlso
% sphgrid, sphweight
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/tools/misc/sphscp.m,v 1.1 2008-01-21 08:47:46 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)  
  
  
  [nth, nph] = size(f1);
  if (any(size(f2) ~= [nth, nph]))
    error('The two function must have the same size');
  end
  
  if (mod(nth,2))
    w = sphweight(nth, nph);
  else
    w = sphweight(nth, nph, 'nopoles');
  end
  
  scp = sum(w(:).*conj(f1(:)).*f2(:));
  