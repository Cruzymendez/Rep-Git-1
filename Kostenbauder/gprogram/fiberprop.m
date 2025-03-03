function [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,w0,lc,kp2,kp3,kp4,lfiber,a,SS,RS,TR,SPM,L,n2)
vluz=0.3e-3;                     % mm/fs

%_ NON_LINEAR_PARAMETERS________________________________________________
rp=a;                               % aproximamos ancho pulso con core?.
Aeff=pi*rp^2;                       % mm^2
g=n2*w0/vluz/Aeff;                  % fs/mm/mJ
L=L/10/log10(exp(1));   % absorption, paso de dB a agrawal pag 6.
%Bint=0.*E;
Bint=0.;
%-----------------------------------------------------------------------

%_PROPAGATION_LENGTH_AND_STEPS__________________________________________
nslices=lfiber/10;
zmax=lfiber;
dz=zmax/nslices;
z=0.;
%-----------------------------------------------------------------------

%max(g*zmax*2*abs(E).^2)
while(z<=zmax)
    %_LINEAR_TERM_dz____________________________________________________
    Ew=ifft(E);
    phase=w.*w*kp2/2+(w.^3)*kp3/6+(w.^4)*kp4/24;
    Ew=Ew.*exp(dz*(j*phase-L/2));
    E=fft(Ew);

    %_NON_LINEAR_TERM_dz________________________________________________
    if SS == 1 | RS == 1
      Iw=ifft(abs(E).^2);
      Iw=-Iw.*w*j;
      dtI=fft(Iw);
    
      Ew=ifft(E);
      Ew=-Ew.*w*j;
      dtE=fft(Ew);
      Ew=ifft(conj(E));
      Ew=-Ew.*w*j;
      dtEc=fft(Ew);
%       el factor 2 de spm para tener la intensidad en el centro de la
%       gaussiana, el doble de flat top en area efectiva
%       leer:    http://www.rp-photonics.com/self_phase_modulation.html
      E=E.*exp(j*dz*g*(2*SPM*abs(E).^2+j*SS/w0*(2*dtE.*conj(E)+E.*dtEc)-RS*TR*dtI));
    else
      E=E.*exp(j*dz*g*(2*SPM*abs(E).^2));
    end
    Bint=Bint+g*dz*2*max(abs(E).^2);
%    Bint=Bint+g*dz*2*abs(E).^2;
%     figure(100);
%     plot(t,Bint); axis([-4*tp 4*tp 0 max(Bint)]); xlabel('t(fs)');ylabel('Bintegral');title('Final B integral'); grid on;
    z=z+dz;
end



