function wav = yadisph(wavfunc, theta, phi, a, chi, varargin)
% Dilate stereographically a function defined on the tangent plane to the
% sphere on the North pole
%
% Inputs :
%   * wavfunc : a function handle to a 2D function (a wavelet). 'wavfunc' has to be
%   called as wavfunc(x,y,...)
%   * theta, phi : coordinates on the sphere (vector or matrix)
%   * a : factor of dilation
%   * chi : orientation around the North pole

tth = tan(theta/2);
tth2 = tth.^2;
a2 = a^2;

cocycle = (1/a) * (1 + tth2) ./ (1 + tth2/a2);

r = 2*tth/a;

x = r .* cos(phi - chi);
y = r .* sin(phi - chi);

wav = cocycle .* (1 + tth2/a2) .* wavfunc(x, y, varargin{:});

