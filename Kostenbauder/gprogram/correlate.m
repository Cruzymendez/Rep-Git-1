function y = correlate(x1,x2)

% This function computes the intensity correlation between the
% two signals x1 and x2.  (If x2 is not specified, it computes
% the autocorrelation instead.)  Both x1 and x2 are assumed to
% represent one period of periodic sequences.  x1 and x2 must
% have the same length and periodicity.  The routine computes
% the periodic correlation of |x1|^2 and |x2|^2 using the FFT.
% Note that the right and left halves of the output vector are
% swapped.  
% 
% USAGE:
% 
% y = correlate(x1)
% y = correlate(x1,x2)
% 
% INPUT:
% 
% x1 - first signal
% x2 - second signal
% 
% OUTPUT:
% 
% y - Intensity correlation of x1 and x2.
  
if (nargin<2)
  x2 = x1;
end

y = fftshift(real(ifft(fft(abs(x1).^2).*conj(fft(abs(x2).^2)))));
