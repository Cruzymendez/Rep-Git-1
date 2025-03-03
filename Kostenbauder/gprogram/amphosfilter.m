function [E,filter]=amphosfilter(E,l,l0,Dl)
   % Amphos filter
   Ew=ifft(E);
   filter=gainrw(l,l0,Dl);     % Intensity filter
   Ew=Ew.*sqrt(filter);
   E=fft(Ew);
   
   %figure;plot(l,filter); grid on;title('Amphos filter')
   
   
