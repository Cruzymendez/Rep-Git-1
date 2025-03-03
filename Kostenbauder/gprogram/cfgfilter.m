function [E,filter]=cfgfilter(E,l,l0,Dl,m)
   % Supergaussian filter for cfbg
   Ew=ifft(E);
   filter=exp(-(2*(l-l0)/Dl).^(2*m));     % Intensity filter
   Ew=Ew.*sqrt(filter);
   E=fft(Ew);
   
   %plot(l,filter); grid on;title('CFBG1 supergaussian filter')
   
   
