function [fgnrw] = gainrw(l,l0,fwhm)
   % Parabola
    gain0=1; 
   Dl=gain0/2/fwhm^2;
   fgnrw=gain0-Dl*(l-l0).^2;
   for i1=1:length(fgnrw)
       if fgnrw(i1)<0
           fgnrw(i1)=0.;
       end
   end
%    lorentziana
%    Pfw=4/fwhm^2;
%    fgnrw=gain0./(1+Pfw*((l-l0).^2));
%figure(234);
%plot(l,fgnrw);title('gain narrowing');grid on;