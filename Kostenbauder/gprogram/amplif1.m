function [E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,w0,lc,filename)
vluz=0.3e-3;                     % mm/fs
%_LECTURA_DE_PARAMETROS_________________________________________________
fid=fopen(filename,'r');
data = textscan(fid,'%s %f','HeaderLines',17,'Delimiter',' ');%,'CollectOutput',1)
dispersion(1)=data{2}(1);
dispersion(2)=data{2}(2);
dispersion(3)=data{2}(3);
gain=data{2}(4);
CP=data{2}(5);
lfiber=data{2}(6);
nslices=data{2}(7);
ampliDB=data{2}(8);               % dB total gain of fiber amplifier
PAT=data{2}(9);                   % dB pump absorption
SPM=data{2}(10);                  % selp-phase modulation
SS=data{2}(11);                   % self-steepening
RS=data{2}(12);                   % Raman-scattering
L=(data{2}(13))/10/log10(exp(1)); % absorption, paso de dB a agrawal pag 6. 
n2=data{2}(14);                   % mm^2 fs mJ^-1
a=data{2}(15);
TR=data{2}(16);                   % Raman-Scattering
gnrw=data{2}(17);                 % gnrw=1/0 -> with/without gain-narrowing
gfwhm=data{2}(18);                % fwhm gain-narrowing
fclose(fid)
%-----------------------------------------------------------------------

%_ NON_LINEAR_PARAMETERS________________________________________________
rp=a;                           % aproximamos ancho pulso con core?.
Aeff=pi*rp^2;                   % mm^2
g=n2*w0/vluz/Aeff;              % fs/mm/mJ
Bint=0.;
%-----------------------------------------------------------------------

% propagation length and steps
zmax=lfiber;
dz=zmax/nslices;
z=0.;

%_FIBER_GAIN_______________________________________________________________
pa=10^(PAT/10);
GN=ampliDB;                             % dB total gain of fiber amplifier
GP=10^(GN/10);                          % gain db -> power
i1=0;
gst=log(GP)*(exp((log(pa))/nslices)-1)/(exp((nslices+1)*(log(pa))/nslices)-1);
Gt=1;

%_GAIN_NARROWING_________________________________________________________
ejel=wf.*1000*lc*lc/(vluz*1e3)/2/pi+1000*lc; %nm
if gnrw == 1
   fgnrw = gainrw(ejel,lc*1e3,gfwhm);
end
%------------------------------------------------------------------------

kp2=dispersion(1);
kp3=dispersion(2);
kp4=dispersion(3);

while(z<=zmax)
    %_GAIN_PER_SLICE____________________________________________________
    if gain==1
        if CP==1
         gsl=gst*exp(z*(log(pa))/zmax);          % co-prop.
        else
         gsl=gst*exp((zmax-z)*(log(pa))/zmax);   % counter-prop.
        end
    else
      gsl=0.;                                    % without gain.
    end
               %_PLOT_GAIN________________________________________________
               %     i1=i1+1;
               %     Gt=Gt*exp(gsl);
               %     figure(600)
               %     plot(z,gsl,'.'); xlabel('z(mm)');ylabel('Gain');title('gain profile');
               %     grid on;
               %     hold on;
               %----------------------------------------------------------
    
    %_GAIN_NARROWING_____________________________________________________
    if gnrw == 1 
      Ew=ifft(E);
      Ew=Ew.*sqrt(fgnrw);
      E=fft(Ew);
    end

    %_LINEAR_TERM_dz_____________________________________________________
    Ew=ifft(E);
    phase=w.*w*kp2/2+(w.^3)*kp3/6+(w.^4)*kp4/24;
    Ew=Ew.*exp(dz*(j*phase-L/2));
    E=fft(Ew);
    E=E.*sqrt(exp(gsl));

    %_NON_LINEAR_TERM_dz_________________________________________________
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
    z=z+dz;
end

figure(400)
plot(t,abs(E),t,abs(ifft(fft(E))),'.',t,abs(fftshift(ifft(abs(fft(E))))));


