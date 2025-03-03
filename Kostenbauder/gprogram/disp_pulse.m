function [E]=disp_pulse(E,w,dispersion)
% fs,mm
Ew=ifft(E);
phase=(dispersion(1)*w.*w/2+dispersion(2)*(w.^3)/6+dispersion(3)*(w.^4)/24);
Ew=Ew.*exp(j*phase);
E=fft(Ew);
