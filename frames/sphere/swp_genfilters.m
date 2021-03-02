function [filterG, filterH, Gamma, Phi, Psi] = swp_genfilters(p, nsamples, d)
% \manchap                                                  
%
% Generate filters for the Spherical Wavelet Pyramid
%
% \mansecSyntax
%
% [filterG, FilterH] = swp_genfilters(p, nsamples, d)
%
% \mansecDescription
%
% Generate 2 recursive dyadic filters, based on packet integration
%
% \mansubsecInputData
% \begin{description} 
% \item[p] [INTEGER]: Oscillation factor. (if p=[], p is set to 5)
% \item[nsamples] [INTEGER]: Size of the filters
% \item[d] [REAL]: Dilation factor (default: 3)
% \end{description}
%
% \mansubsecOutputData
% \begin{description}
% \item[filterG] [REAL VECTOR]: High-pass filter 
% \item[filterH] [REAL VECTOR]: Low-pass filter
% \item[Gamma] [REAL VECTOR]: 
% \item[Phi] [REAL VECTOR]: Scaling function
% \item[Psi] [REAL VECTOR]: Wavelet  
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
%
% swp, iswp, fst, ifst
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/sphere/swp_genfilters.m,v 1.1 2008-01-21 15:32:26 jacques Exp $
%
% Copyright (C) 2001-2002, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if isempty(p)
  p = 5;
end

if isempty(d)
  d = 3;
end
  
%% Radial kernel
polyphi=zeros(1,2*p-1);
polyphi(1:2:end)=1./factorial((p-1):-1:0);

%% Filters generation
% Filter mean
mu=factorial(p)*(2^p)./(sqrt(pi)*(prod(1:2:(2*p-1))));

L=linspace(0,d*mu,nsamples);

filterG=sqrt(1-exp(-3*L.^2/4).*polyval(polyphi,L)./polyval(polyphi,L/2));
filterH=sqrt(exp(-3*L.^2/4).*polyval(polyphi,L)./polyval(polyphi,L/2));

%% High frequency approximation
filterG((nsamples/2+1):end)=1;
filterH((nsamples/2+1):end)=0;

%% Wavelet and scaling generation 
Gamma=sqrt(exp(-L.^2/4).*polyval(polyphi,L/2)-exp(-L.^2).*polyval(polyphi,L));
Phi=sqrt(exp(-L.^2).*polyval(polyphi,L));

%% Continuous wavelet generation
Psi=exp(-L.^2/2).*(L).^p;

Psi=Psi.*sqrt(2/factorial(p-1));

