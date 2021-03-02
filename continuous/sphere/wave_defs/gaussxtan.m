function wav = gaussxtan(x, y)

wav = - x .* exp( - (x.^2 + y.^2)/2);