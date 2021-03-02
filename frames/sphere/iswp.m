function F = iswp(W)
% \manshap
%
% Isotropic spherical wavelet frame - Inverse transform
%
% \mansecSyntax
%
% F = iswp(W)
%
% \mansecInputData
%
% \begin{description}
% \item[W] [STRUCT]: wavelet pyramid (see swp.m)
% \end{description}
%
% \mansecOutputData
% \begin{description}
% \item[F] [REAL MATRIX]: reconstructed signal sampled on an equi-angular grid
% \end{description}
%  
% \mansecExample
% \begin{code}
% >> yademo swp
% \end{code}
%
% \mansecReference  
%
% O. Blanc, EPFL, Master Report.
%
% \mansecSeeAlso
% swp, swp_genfilters, fst, ifst,  
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/sphere/iswp.m,v 1.1 2008-01-21 15:32:26 jacques Exp $
%
% Copyright (C) 2001-2008, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

%% Initializations
depth = length(W.wav) - 1;

%% First step
Flm = lmshape(fst(W.app));

H = W.H;
G = W.G;

%% Recursion
for n = (depth+1):-1:1
  
    Flm = doublefreq(Flm);
    
    fG = G(1:2^(n-1):end);
    fH = H(1:2^(n-1):end);
    
    Flm = spharm_conv(fH, Flm);
    
    detail = spharm_conv(fG, lmshape(fst(W.wav{n})));
    
    Flm = Flm + detail;    
end

%% Reshape function
Flm = ilmshape(Flm);
F = real(ifst(Flm)) + W.res;

%% Home brewed functions

function Y=spharm_conv(h,X)
% convolve a function X with axisymmetric filter h
% X must be lmshaped
Y=(ones(size(X,1),1)*h).*X;

function Y=doublefreq(X)
% Double frequency resolution. Pad with zeros
b=size(X,2);
if (b>1)
    Y=zeros(4*b-1, 2*b);
    Y(1:b, 1:b)=X(1:b, :);
    Y((3*b+1):end,1:b)=X((b+1):end, :);
else
    Y=zeros(3, 2);
    Y(1,1)=X(1,1);
end
