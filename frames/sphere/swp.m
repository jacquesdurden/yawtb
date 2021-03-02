function W = swp(F, G, H, depth)
% \manchap
%
% Isotropic spherical wavelet frame - Forward transform
%
% \mansecSyntax
%
% W = swp(F, G, H, depth)
%
% \mansecDescription
%
% \mansecInputData
%
% \begin{description}
% \item[F] [REAL MATRIX]: Input signal.
% \item[G] [REAL VECTOR]: Highpass filter
% \item[H] [REAL VECTOR]: Lowpass filter. Filters G and H can be easily
% created with the associated function swp_genfilters()
% \item[depth] [INTEGER]: Number of decomposition steps. Must be smaller
% than log2(min(size(F))) - 3 (since bandwidth >= 4). 
% \end{description} 
%
% \mansecOutputData 
% \begin{description}
% \item[W] [STRUCT]: a structure containing wavelet subbands (sampled on
% equi-angular grids). The last level is the approximation level.
% \end{description}
%
% \mansecExample
% \begin{code}
% >> load topo;
% >> topo = topo(1:2:end,1:2:end); Lmax = size(topo,1)/2;
% >> [G,H] = swp_genfilters(5, Lmax, 3);
% >> W = swp(topo, G, H);
% >> W
% >> ntopo = iswp(W);
% >> max(abs(topo(:)-ntopo(:)))/max(abs(topo(:)))
% \end{code}
%
% \mansecReference  
%
% O. Blanc, EPFL, Master Report.
%
% \mansecSeeAlso
% swp_genfilters, iswp, fst, ifst,  
%
% \mansecLicense
%
% This file is part of YAW Toolbox (Yet Another Wavelet Toolbox)
% You can get it at
% \url{"http://www.fyma.ucl.ac.be/projects/yawtb"}{"yawtb homepage"} 
%
% $Header: /home/cvs/yawtb/frames/sphere/swp.m,v 1.1 2008-01-21 15:32:26 jacques Exp $
%
% Copyright (C) 2001-2008, the YAWTB Team (see the file AUTHORS distributed with
% this library) (See the notice at the end of the file.)

if (~exist('depth'))
  depth = floor(log2(min(size(F)))) - 3;
elseif (depth >= log2(min(size(F))) - 3)
  error('ERROR: Depth must be strictly smaller than log2(min(size(F))) - 2');
end
	
W.depth = depth;
W.G = G;
W.H = H;

W.wav = {};

%% Bandlimited signal
F_bw = ifst(fst(F));

%% Recording residual high freq information between signal and its
%% bandlimited projection.
W.res = real(F - F_bw);

	
Flm = fst(F_bw);
Flm = lmshape(Flm);

%% First stage
scale = Flm;

%% Recursion
for n = 1:depth
  
    detail = spharm_conv(G, scale);
    W.wav{n} = real(ifst(ilmshape(detail)));

    scale = spharm_conv(H, scale);
    scale = lowfreq(scale);

    G = G(1:2:end);
    H = H(1:2:end);
end

%% Last but not least, approximation
W.app = real(ifst(ilmshape(scale)));

%% Home brewed functions
function Y = spharm_conv(h,X)
% convolve a function X with axisymmetric filter h
% X must be lmshaped
Y = (ones(size(X,1),1)*h).*X;

function Y = lowfreq(X)
% Extract the low frequency coefficients
b = size(X,2);
Y = X( [1:b/2, (3*b/2+1):end], 1:b/2 );
