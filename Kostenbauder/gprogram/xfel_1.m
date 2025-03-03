function [ret]=xfel_1()

clear all;
close all;

% prt=1/0  print/noprint results
prt=0;

if prt == 1
   fid0=fopen('res.txt','w+');
end
% units
mic=1;fs=1;ns=1e6;mJ=1;mm=mic/1000;m=1e-3;ps=1e3;s=fs*1e-15;J=mJ*1e-3;nJ=mJ*1e-6;

%_PULSE_PARAMETERS______________________________________________________
lc=0.8;                % pulse central wavelength (mic)
ko=2*pi/lc;            % mic^-1)
vluz=0.299792458;      % speed of light (mic fs^-1)
%vluz=0.3;             % speed of light (mic fs^-1)
wo=2*pi*vluz/lc;       % pulse central omega (fs^-1)
tp=5*fs;               % pulse width (fs).
a=0.35;                % spatial fwhm (mm)
energia=8*nJ;          % Energy (mJ)
%-----------------------------------------------------------------------

%_TEMPORAL_AND_SPECTRAL_AXIS________________________________________________
npuntos=2^19;                          % number of points.
maxt=1*ps;                             % temporal window to follow [fs]                

dt=2*maxt/(npuntos-1);                 % time resolution [fs]
t=-maxt:dt:maxt;                       % temporal axis (fs)
dw=2*pi/(2*maxt);                      % frequency axis (fs^-1)
wN=-pi/dt:dw:pi/dt;
w=ifftshift(wN); 
wf=-w;                                 % for frequency sign criteria
ejel=wf.*1000*lc*lc/vluz/2/pi+1000*lc; % wavelength axis (nm)
Bint_T=0.;Bint=0.;
%------------------------------------------------------------------------

%_ELECTRIC_FIELD________________________________________________________
% GAUSSIAN PULSE:
 E=exp(-t.*t*(log(2))/2/tp^2);         % fwhm intensity
% E=exp(-t.*t/2/tp^2);                % 1/e intensity
% E=exp(-t.*t/tp^2);                  % 1/e^2 intensity
fwhmP=fwhm(t,(abs(E)).^2)             % FWHM en intensidad
% SECH PULSE:
% tau=tp/(2*acosh(sqrt(2))); to=0.; P=(sech((t-to)/tau)).^2; E=sqrt(P);
% fwhmP=fwhm(t,P);
%-----------------------------------------------------------------------
%_PULSE_NORMALIZED___________________________________________________________ 
norma=0;
for it=1:length(t)
    norma=norma+abs(E(it))^2;
end
norma=norma*dt; E=E.*sqrt(energia/norma);
Eosc=E;
% correct factor to plot in IS
factorsi=J/s;
spatialnorm=pi*(0.1*0.1*a^2)/2;                 % cm2 y 1/e^2 spatial intensity
factortotal=factorsi/spatialnorm;
I0=factortotal*(abs(E)).^2;                     % Intensidad inicial          
%---------------------------------------------------------------TEMPORAL-
                nfig=1;figure(nfig);nfig=nfig+1;
                plot(t,I0);axis([-4*tp 4*tp 0 max(I0)]);
                xlabel('t(fs)');ylabel('I (W/cm^2)');title('Initial pulse ');
                str = strcat('fwhm = ', num2str(fwhmP));legend(str); grid on;
%------------------------------------------------------------------------
%--------------------------------------------------------------FREQUENCY-
                Ew=ifft(E); I0w=(abs(Ew)).^2;fwhmPw=fwhm(w,I0w)
                figure(nfig);nfig=nfig+1;
                plot(w,I0w);
                xlabel('w(fs^-1)');ylabel('Iw (W/cm^2)');title('Initial pulse ');
                str = strcat('fwhm = ', num2str(fwhmP));legend(str); grid on;
%------------------------------------------------------------------------
pause;
%_ADDITIONAL_DISPERSION_DATOS_MATERIAL__________________________________________________
%gvd,tod y fod.en fs y mm.
kposc=1:3;
kposc(1)=2.4e6;kposc(2)=0.;kposc(3)=0.;
[E]=disp_pulse(E,w,kposc);
%-----------------------------------------------------------------------
            fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
            plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('Stretcher oscillator output: chain 3');
            str = strcat('fwhm = ', num2str(fwhmEo));legend(str); grid on;
            if prt == 1
               fprintf(fid0,'\nkposc= %e %e %e -- %f \n',kposc(1),kposc(2),kposc(3),fwhmEo);
            end
%----------------------------------------------------------------------

%_DISPERSION_LONGITUD_FIBRA________________________________________________
kpch3_1=1:3; kpch3_1(1)=23; kpch3_1(2)=75.4; kpch3_1(3)=0; 
Lfib=2600; kpch3_1=Lfib*kpch3_1;
[E]=disp_pulse(E,w,kpch3_1);
% [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch3_1(1)/Lfib,kpch3_1(2)/Lfib,kpch3_1(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% Bint_T=Bint_T+Bint;
%-----------------------------------------------------------------------
            fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
            plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before CFBG_XF2');
            str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpch3_1= %e %e %e -- fwhm: %f  Bint=%f\n',kpch3_1(1),kpch3_1(2),kpch3_1(3),fwhmEo,Bint);
            end

%--------------------------------------------------------------------

%_CFBG_XF2_DISPERSION___________________________________________________
%gvd,tod y fod.en fs y mm.
kpcfbgxf2=1:3; kpcfbgxf2(1)=23.03e6; kpcfbgxf2(2)=0*-0.3250e9; kpcfbgxf2(3)=0.; 
[E]=disp_pulse(E,w,kpcfbgxf2);
%-----------------------------------------------------------------------
            fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
            plot(t,factortotal*abs(E).^2);axis([-400*ps 400*ps 0 max(factortotal*abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('CFBG_XF2 output with no filter');
            str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpcfbgxf2= %e %e %e -- %f \n',kpcfbgxf2(1),kpcfbgxf2(2),kpcfbgxf2(3),fwhmEo);
            end
%----------------------------------------------------------------------

%_LOSSES_REFLECTIVITY_CFBG_X2_AND_CIRC___________________________________
[E]=losses(E,-5.21933599);
% Pulse energy after losses in CFBG_X2:
norma=normy(E,t,dt)
            if prt == 1
               fprintf(fid0,'CFBG_2 & CIRC LOSSES: %e \n',norma);
            end
%%--------------------------------------------------------------------------

%_CFBG_XF2_FILTERING______________________________________________________
% en nm
filterwidth=15.3;
supergaussianm=10;
[E,filter]=cfgfilter(E,ejel,lc*1000,filterwidth,supergaussianm);
%----------------------------------------------------------------------
            figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
            subplot(1,2,1);
            plot(ejel,abs(ifft(Eosc)).^2,'k',ejel,abs(ifft(E)).^2,'b');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
            xlabel('l(nm))');ylabel('I (W/cm^2)');title('Spectrum filtering by CFBG_XF2');
            str = strcat('fwhmi = ', num2str(fwhmSP0));
            str = strcat(str,'    fwhmf= ');
            str = strcat(str,num2str(fwhmSPF));
            legend(str); grid on;
            subplot(1,2,2);
            plot(ejel,filter);xlabel('l(nm))'); title('CFBG_XF2 filter');grid on;
            if prt == 1
               fprintf(fid0,'filter CFBG_XF2= %f %f -- %f vs %f \n',filterwidth,supergaussianm,fwhmSP0,fwhmSPF);
            end
            %-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,abs(E).^2);axis([-400*ps 400*ps 0 max(abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('CFG1 output with filter');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%----------------------------------------------------------------------

%_0.8+0.8+1+0.3_m_PM980__________________________________________________
kpch3_2=1:3; kpch3_2(1)=23; kpch3_2(2)=75.4; kpch3_2(3)=0; 
Lfib=2900; kpch3_2=Lfib*kpch3_2;
[E]=disp_pulse(E,w,kpch3_2);
% [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch3_2(1)/Lfib,kpch3_2(2)/Lfib,kpch3_2(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% Bint_T=Bint_T+Bint;
%-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 2.9 m PM980');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpch3_2= %e %e %e -- fwhm: %f  Bint=%f\n',kpch3_2(1),kpch3_2(2),kpch3_2(3),fwhmEo,Bint);
            end

%--------------------------------------------------------------------

%_PREAMP_1_____________________________________________________________
% Total dispersion of amplifier... just for testing...
disp_preamp1=1:3;disp_preamp1(1)=23.; disp_preamp1(2)=75.4; disp_preamp1(3)=0.;  
Lpreamp_1=800;    
kppreamp_1=1:3;kppreamp_1(1)=Lpreamp_1*disp_preamp1(1);kppreamp_1(2)=Lpreamp_1*disp_preamp1(2);kppreamp_1(3)=Lpreamp_1*disp_preamp1(3);

%[E]=disp_pulse(E,w,kppreamp_1);
[E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,wo,lc,'Preamp1.txt');
Bint_T=Bint_T+Bint

            fwhmE=fwhm(t,abs(E).^2);figure(nfig);nfig=nfig+1;
            plot(t,factortotal*abs(E).^2);axis([-300*ps 300*ps 0 max(factortotal*abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('Preamp1 output');
            str = strcat('fwhm = ', num2str(fwhmE)); grid on;legend(str);
% --------------------------------------------------------------------------
%_FINAL_SPECTR__________________________________________________________
                figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
                plot(ejel,(abs(ifft(Eosc)).^2)/max(abs(ifft(Eosc)).^2),'k',ejel,(abs(ifft(E)).^2)/max(abs(ifft(E)).^2),'r--');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
                xlabel('l(nm)');ylabel('I (W/cm^2)');title('Spectrum evolution Preamp1');
                str = strcat('fwhmi = ', num2str(fwhmSP0));
                str = strcat(str,'    fwhmf= ');
                str = strcat(str,num2str(fwhmSPF));
                legend(str); grid on;
                if prt == 1
                  fprintf(fid0,'Preamp1= %f %f ',fwhmE,fwhmSPF);
                end
%-----------------------------------------------------------------------

norma=normy(E,t,dt)
            if prt == 1
               fprintf(fid0,'After Preamp1: %e %e\n',norma,Bint);
            end
            
%_0.8_m_PM980__________________________________________________
kpch6_0=1:3; kpch6_0(1)=23; kpch6_0(2)=75.4; kpch6_0(3)=0; 
Lfib=800; kpch6_0=Lfib*kpch6_0;
[E]=disp_pulse(E,w,kpch6_0);
% [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch6_0(1)/Lfib,kpch6_0(2)/Lfib,kpch6_0(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% Bint_T=Bint_T+Bint;
%-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.8 m PM980');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpch6_0= %e %e %e -- fwhm: %f  Bint=%f\n',kpch6_0(1),kpch6_0(2),kpch6_0(3),fwhmEo,Bint);
            end
%--------------------------------------------------------------------------            
            
%_LOSSES_EOM___________________________________________________________
[E]=losses(E,-5);
% Pulse energy after losses in EOM:
norma=normy(E,t,dt)
            if prt == 1
               fprintf(fid0,'EOM: %e \n',norma);
            end
%%--------------------------------------------------------------------------
%_0.8+0.3_m_PM980__________________________________________________
kpch6_1=1:3; kpch6_1(1)=23; kpch6_1(2)=75.4; kpch6_1(3)=0; 
Lfib=1100; kpch6_1=Lfib*kpch6_1;
[E]=disp_pulse(E,w,kpch6_1);
% [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch6_1(1)/Lfib,kpch6_1(2)/Lfib,kpch6_1(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% Bint_T=Bint_T+Bint;
%-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 1.1 m PM980');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpch6_1= %e %e %e -- fwhm: %f  Bint=%f\n',kpch6_1(1),kpch6_1(2),kpch6_1(3),fwhmEo,Bint);
            end
%--------------------------------------------------------------------------

%_PREAMP_2_____________________________________________________________
% Total dispersion of amplifier... just for testing...
disp_preamp2=1:3;disp_preamp2(1)=23.; disp_preamp2(2)=75.4; disp_preamp2(3)=0.;  
Lpreamp_2=1000;    
kppreamp_2=1:3;kppreamp_2(1)=Lpreamp_2*disp_preamp1(1);kppreamp_2(2)=Lpreamp_2*disp_preamp2(2);kppreamp_2(3)=Lpreamp_2*disp_preamp2(3);
%[E]=disp_pulse(E,w,kppreamp_2);
[E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,wo,lc,'Preamp2.txt');
Bint_T=Bint_T+Bint

            fwhmE=fwhm(t,abs(E).^2);figure(nfig);nfig=nfig+1;
            plot(t,factortotal*abs(E).^2);axis([-300*ps 300*ps 0 max(factortotal*abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('Preamp2 output');
            str = strcat('fwhm = ', num2str(fwhmE)); grid on;legend(str);
% --------------------------------------------------------------------------
%_FINAL_SPECTR__________________________________________________________
                figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
                plot(ejel,(abs(ifft(Eosc)).^2)/max(abs(ifft(Eosc)).^2),'k',ejel,(abs(ifft(E)).^2)/max(abs(ifft(E)).^2),'r--');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
                xlabel('l(nm)');ylabel('I (W/cm^2)');title('Spectrum evolution Preamp2');
                str = strcat('fwhmi = ', num2str(fwhmSP0));
                str = strcat(str,'    fwhmf= ');
                str = strcat(str,num2str(fwhmSPF));
                legend(str); grid on;
                if prt == 1
                  fprintf(fid0,'Preamp2= %f %f ',fwhmE,fwhmSPF);
                end
%-----------------------------------------------------------------------
norma=normy(E,t,dt)
            if prt == 1
               fprintf(fid0,'After Preamp2: %e %e\n',norma,Bint);
            end
            
%_0.4+0.4_m_PM980__________________________________________________
kpch7_1=1:3; kpch7_1(1)=23; kpch7_1(2)=75.4; kpch7_1(3)=0; 
Lfib=800; kpch7_1=Lfib*kpch7_1;
[E]=disp_pulse(E,w,kpch7_1);
% [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch7_1(1)/Lfib,kpch7_1(2)/Lfib,kpch7_1(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% Bint_T=Bint_T+Bint;
%-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.8 m PM980');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpch7_1= %e %e %e -- fwhm: %f  Bint=%f\n',kpch7_1(1),kpch7_1(2),kpch7_1(3),fwhmEo,Bint);
            end
%--------------------------------------------------------------------------

%_50%/50%_DIVISOR___________________________________________________________

[E]=losses(E,-3.01029995);
% Pulse energy after DIVISOR:
norma=normy(E,t,dt)
            if prt == 1
               fprintf(fid0,'DIVISOR: %e \n',norma);
            end
%%--------------------------------------------------------------------------

%_0.6+0.5_m_PM980__________________________________________________
kpch8_0=1:3; kpch8_0(1)=23; kpch8_0(2)=75.4; kpch8_0(3)=0; 
Lfib=1100; kpch8_0=Lfib*kpch8_0;
[E]=disp_pulse(E,w,kpch8_0);
% [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch8_0(1)/Lfib,kpch8_0(2)/Lfib,kpch8_0(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% Bint_T=Bint_T+Bint;
%-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 1.1 m PM980');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpch8_0= %e %e %e -- fwhm: %f  Bint=%f\n',kpch8_0(1),kpch8_0(2),kpch8_0(3),fwhmEo,Bint);
            end
%--------------------------------------------------------------------------

%%--------------------------------------------------------------------------
%_CFBG_XF1_DISPERSION___________________________________________________
%gvd,tod y fod.en fs y mm.
kpcfbgxf1=1:3; kpcfbgxf1(1)=161e6; kpcfbgxf1(2)=0*-2*0.702e9; kpcfbgxf1(3)=0.; %kpcfbgxf1(1)=2*56e6;
[E]=disp_pulse(E,w,kpcfbgxf1);
%-----------------------------------------------------------------------
            fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
            plot(t,factortotal*abs(E).^2);axis([-maxt maxt 0 max(factortotal*abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('CFBG_XF1 output with no filter');
            str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
            if prt == 1
               fprintf(fid0,'kpcfbgxf1= %e %e %e -- %f \n',kpcfbgxf1(1),kpcfbgxf1(2),kpcfbgxf1(3),fwhmEo);
            end
%----------------------------------------------------------------------

%_LOSSES_REFLECTIVITY_CFBG_X1_AND_CIRC___________________________________
[E]=losses(E,-5.21933599);
% Pulse energy after losses in CFBG_X1:
norma=normy(E,t,dt)
            if prt == 1
               fprintf(fid0,'CFBG_1 & CIRC LOSSES: %e \n',norma);
            end
%--------------------------------------------------------------------------

%_CFBG_XF1_FILTERING______________________________________________________
% en nm
filterwidth=5.63;
supergaussianm=10;
[E,filter]=cfgfilter(E,ejel,lc*1000,filterwidth,supergaussianm);
%----------------------------------------------------------------------
            figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
            subplot(1,2,1);
            plot(ejel,abs(ifft(Eosc)).^2,'k',ejel,abs(ifft(E)).^2,'b');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
            xlabel('l(nm))');ylabel('I (W/cm^2)');title('Spectrum filtering by CFBG_XF1');
            str = strcat('fwhmi = ', num2str(fwhmSP0));
            str = strcat(str,'    fwhmf= ');
            str = strcat(str,num2str(fwhmSPF));
            legend(str); grid on;
            subplot(1,2,2);
            plot(ejel,filter);xlabel('l(nm))'); title('CFBG_XF1 filter');grid on;
            if prt == 1
               fprintf(fid0,'filter CFBG_XF1= %f %f -- %f vs %f \n',filterwidth,supergaussianm,fwhmSP0,fwhmSPF);
            end
            %-----------------------------------------------------------------------
%             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
%             plot(t,abs(E).^2);axis([-400*ps 400*ps 0 max(abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('CFG2 output with filter');
%             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%----------------------------------------------------------------------

% %_0.5+0.6+0.4+0.2_m_PM980__________________________________________________
% kpch8_1=1:3; kpch8_1(1)=23; kpch8_1(2)=75.4; kpch8_1(3)=0; 
% Lfib=1700.; kpch8_1=Lfib*kpch8_1;
% [E]=disp_pulse(E,w,kpch8_1);
% % [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch8_1(1)/Lfib,kpch8_1(2)/Lfib,kpch8_1(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% % Bint_T=Bint_T+Bint;
% %-----------------------------------------------------------------------
% %             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
% %             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
% %             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 1.7 m PM980');
% %             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%             if prt == 1
%                 fprintf(fid0,'kpch8_1= %e %e %e -- fwhm: %f  Bint=%f\n',kpch8_1(1),kpch8_1(2),kpch8_1(3),fwhmEo,Bint);
%             end
% %--------------------------------------------------------------------------
% 
% %_PREAMP_3_____________________________________________________________
% % Total dispersion of amplifier... just for testing...
% disp_preamp3=1:3;disp_preamp3(1)=23.; disp_preamp3(2)=75.4; disp_preamp3(3)=0.;  
% Lpreamp_3=1000;    
% kppreamp_3=1:3;kppreamp_3(1)=Lpreamp_3*disp_preamp3(1);kppreamp_3(2)=Lpreamp_3*disp_preamp3(2);kppreamp_3(3)=Lpreamp_3*disp_preamp3(3);
% %[E]=disp_pulse(E,w,kppreamp_3);
% [E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,wo,lc,'Preamp3.txt');
% Bint_T=Bint_T+Bint
% 
%             fwhmE=fwhm(t,abs(E).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-maxt maxt 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Preamp3 output');
%             str = strcat('fwhm = ', num2str(fwhmE)); grid on;legend(str);
% % --------------------------------------------------------------------------
% %_FINAL_SPECTR__________________________________________________________
%                 figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
%                 plot(ejel,(abs(ifft(Eosc)).^2)/max(abs(ifft(Eosc)).^2),'k',ejel,(abs(ifft(E)).^2)/max(abs(ifft(E)).^2),'r--');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
%                 xlabel('l(nm)');ylabel('I (W/cm^2)');title('Spectrum evolution Preamp3');
%                 str = strcat('fwhmi = ', num2str(fwhmSP0));
%                 str = strcat(str,'    fwhmf= ');
%                 str = strcat(str,num2str(fwhmSPF));
%                 legend(str); grid on;
%                 if prt == 1
%                   fprintf(fid0,'Preamp3= %f %f ',fwhmE,fwhmSPF);
%                 end
%                 
% %-----------------------------------------------------------------------
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'After Preamp3: %e %e\n',norma,Bint);
%             end
%             
% %_0.2+0.4_m_PM980__________________________________________________
% kpch10_0=1:3; kpch10_0(1)=23; kpch10_0(2)=75.4; kpch10_0(3)=0; 
% Lfib=600; kpch10_0=Lfib*kpch10_0;
% [E]=disp_pulse(E,w,kpch10_0);
% % [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch10_0(1)/Lfib,kpch10_0(2)/Lfib,kpch10_0(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% % Bint_T=Bint_T+Bint;
% %-----------------------------------------------------------------------
% %             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
% %             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
% %             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.6 m PM980');
% %             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%             if prt == 1
%                fprintf(fid0,'kpch10_0= %e %e %e -- fwhm: %f  Bint=%f\n',kpch10_0(1),kpch10_0(2),kpch10_0(3),fwhmEo,Bint);
%             end
% %--------------------------------------------------------------------------
% 
% %_LOSSES_AOM1___________________________________________________________
% [E]=losses(E,-5.5);
% % Pulse energy after losses in AOM:
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'AOM1: %e \n',norma);
%             end
% %%--------------------------------------------------------------------------
% %_0.4+0.2_m_PM980__________________________________________________
% kpch10_1=1:3; kpch10_1(1)=23; kpch10_1(2)=75.4; kpch10_1(3)=0; 
% Lfib=600; kpch10_1=Lfib*kpch10_1;
% [E]=disp_pulse(E,w,kpch10_1);
% % [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch10_1(1)/Lfib,kpch10_1(2)/Lfib,kpch10_1(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% % Bint_T=Bint_T+Bint;
% %-----------------------------------------------------------------------
% %             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
% %             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
% %             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.6 m PM980');
% %             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%             if prt == 1
%                fprintf(fid0,'kpch10_1= %e %e %e -- fwhm: %f  Bint=%f\n',kpch10_1(1),kpch10_1(2),kpch10_1(3),fwhmEo,Bint);
%             end
% %--------------------------------------------------------------------------
% 
% %_PREAMP_4_____________________________________________________________
% % Total dispersion of amplifier... just for testing...
% disp_preamp4=1:3;disp_preamp4(1)=23.; disp_preamp4(2)=75.4; disp_preamp4(3)=0.;  
% Lpreamp_4=1500;    
% kppreamp_4=1:3;kppreamp_4(1)=Lpreamp_4*disp_preamp4(1);kppreamp_4(2)=Lpreamp_4*disp_preamp4(2);kppreamp_4(3)=Lpreamp_4*disp_preamp4(3);
% %[E]=disp_pulse(E,w,kppreamp_4);
% [E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,wo,lc,'Preamp4.txt');
% Bint_T=Bint_T+Bint
% 
%             fwhmE=fwhm(t,abs(E).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-maxt maxt 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Preamp4 output');
%             str = strcat('fwhm = ', num2str(fwhmE)); grid on;legend(str);
% % --------------------------------------------------------------------------
% %_FINAL_SPECTR__________________________________________________________
%                 figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
%                 plot(ejel,(abs(ifft(Eosc)).^2)/max(abs(ifft(Eosc)).^2),'k',ejel,(abs(ifft(E)).^2)/max(abs(ifft(E)).^2),'r--');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
%                 xlabel('l(nm)');ylabel('I (W/cm^2)');title('Spectrum evolution Preamp4');
%                 str = strcat('fwhmi = ', num2str(fwhmSP0));
%                 str = strcat(str,'    fwhmf= ');
%                 str = strcat(str,num2str(fwhmSPF));
%                 legend(str); grid on;
%                 if prt == 1
%                   fprintf(fid0,'Preamp4= %f %f ',fwhmE,fwhmSPF);
%                 end
% %-----------------------------------------------------------------------
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'After Preamp4: %e %e\n',norma,Bint);
%             end
%             
% %_0.2+0.4_m_PM980__________________________________________________
% kpch10_2=1:3; kpch10_2(1)=23; kpch10_2(2)=75.4; kpch10_2(3)=0; 
% Lfib=600; kpch10_2=Lfib*kpch10_2;
% [E]=disp_pulse(E,w,kpch10_2);
% % [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch10_2(1)/Lfib,kpch10_2(2)/Lfib,kpch10_2(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% % Bint_T=Bint_T+Bint;
% %-----------------------------------------------------------------------
% %             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
% %             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
% %             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.6 m PM980');
% %             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%             if prt == 1
%                fprintf(fid0,'kpch10_2= %e %e %e -- fwhm: %f  Bint=%f\n',kpch10_2(1),kpch10_2(2),kpch10_2(3),fwhmEo,Bint);
%             end
% %--------------------------------------------------------------------------
% %_LOSSES_AOM2___________________________________________________________
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'After preamp4: %e %e\n',norma,Bint);
%             end
% [E]=losses(E,-5.5);
% % Pulse energy after losses in AOM2:
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'AOM2: %e \n',norma);
%             end
% %%--------------------------------------------------------------------------
% %_0.4+0.3_m_PM980__________________________________________________
% kpch10_3=1:3; kpch10_3(1)=23; kpch10_3(2)=75.4; kpch10_3(3)=0; 
% Lfib=700; kpch10_3=Lfib*kpch10_3;
% [E]=disp_pulse(E,w,kpch10_2);
% % [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch10_3(1)/Lfib,kpch10_3(2)/Lfib,kpch10_3(3)/Lfib,Lfib,3.3e-3,1,1,5,1,0,3e-2);
% % Bint_T=Bint_T+Bint;
% %-----------------------------------------------------------------------
% %             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
% %             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
% %             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.7 m PM980');
% %             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%             if prt == 1
%                fprintf(fid0,'kpch10_3= %e %e %e -- fwhm: %f  Bint=%f\n',kpch10_3(1),kpch10_3(2),kpch10_3(3),fwhmEo,Bint);
%             end
% %--------------------------------------------------------------------------
% %_LOSSES_Splice1/XF1___________________________________________________________
% [E]=losses(E,-1.5);
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'Splice1/XF1: %e \n',norma);
%             end
% %%--------------------------------------------------------------------------
% 
% %_0.3+0.3_m_PM-10-micron__________________________________________________
% kpch10_4=1:3; kpch10_4(1)=23; kpch10_4(2)=75.4; kpch10_4(3)=0; 
% Lfib=600; kpch10_4=Lfib*kpch10_4;
% [E]=disp_pulse(E,w,kpch10_4);
% % [E,Bint]=fiberprop(E,t,w,wf,tp,dt,maxt,energia,wo,lc,kpch10_4(1)/Lfib,kpch10_4(2)/Lfib,kpch10_4(3)/Lfib,Lfib,5e-3,1,1,5,1,0,3e-2);
% % Bint_T=Bint_T+Bint;
% %-----------------------------------------------------------------------
% %             fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
% %             plot(t,factortotal*abs(E).^2);axis([-60*ps 60*ps 0 max(factortotal*abs(E).^2)]);
% %             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Chain 3: before 0.6 m PM-10-micron');
% %             str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%             if prt == 1
%                fprintf(fid0,'kpch10_4= %e %e %e -- fwhm: %f  Bint=%f\n',kpch10_4(1),kpch10_4(2),kpch10_4(3),fwhmEo,Bint);
%             end
% %--------------------------------------------------------------------------
% %_PREAMP_5_____________________________________________________________
% % Total dispersion of amplifier... just for testing...
% disp_preamp5=1:3;disp_preamp5(1)=23.; disp_preamp5(2)=75.4; disp_preamp5(3)=0.;  
% Lpreamp_5=1500;    
% kppreamp_5=1:3;kppreamp_5(1)=Lpreamp_5*disp_preamp5(1);kppreamp_5(2)=Lpreamp_5*disp_preamp5(2);kppreamp_5(3)=Lpreamp_5*disp_preamp5(3);
% %[E]=disp_pulse(E,w,kppreamp_5);
% [E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,wo,lc,'Preamp5.txt');
% Bint_T=Bint_T+Bint
% 
%             fwhmE=fwhm(t,abs(E).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-maxt maxt 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Preamp5 output');
%             str = strcat('fwhm = ', num2str(fwhmE)); grid on;legend(str);
% % --------------------------------------------------------------------------
% %_FINAL_SPECTR__________________________________________________________
%                 figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
%                 plot(ejel,(abs(ifft(Eosc)).^2)/max(abs(ifft(Eosc)).^2),'k',ejel,(abs(ifft(E)).^2)/max(abs(ifft(E)).^2),'r--');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
%                 xlabel('l(nm)');ylabel('I (W/cm^2)');title('Spectrum evolution Preamp5');
%                 str = strcat('fwhmi = ', num2str(fwhmSP0));
%                 str = strcat(str,'    fwhmf= ');
%                 str = strcat(str,num2str(fwhmSPF));
%                 legend(str); grid on;
%                 if prt == 1
%                   fprintf(fid0,'Preamp5= %f %f ',fwhmE,fwhmSPF);
%                 end
% %-----------------------------------------------------------------------
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'After preamp5: %e %f\n',norma,Bint);
%                fprintf(fid0,'Total Bint = %f\n',Bint_T);
%             end
%             
% %_LOSSES_Splice2/XF1___________________________________________________________
% [E]=losses(E,-3);
% % Pulse energy after losses in Splice2/XF1:
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'Splice2/XF1: %e \n',norma);
%             end
% %%--------------------------------------------------------------------------
% %_PREAMP_PA/XF1_____________________________________________________________
% % Total dispersion of amplifier... just for testing...
% disp_preampa=1:3;disp_preampa(1)=23.; disp_preampa(2)=75.4; disp_preampa(3)=0.;  
% Lpreampa=2500;    
% kppreampa=1:3;kppreampa(1)=Lpreampa*disp_preampa(1);kppreampa(2)=Lpreampa*disp_preampa(2);kppreampa(3)=Lpreampa*disp_preampa(3);
% %[E]=disp_pulse(E,w,kppreampa);
% [E,Bint]=amplif1(E,t,w,wf,tp,dt,maxt,energia,wo,lc,'Preampa.txt');
% Bint_T=Bint_T+Bint
% 
%             fwhmE=fwhm(t,abs(E).^2);figure(nfig);nfig=nfig+1;
%             plot(t,factortotal*abs(E).^2);axis([-maxt maxt 0 max(factortotal*abs(E).^2)]);
%             xlabel('t(fs)');ylabel('I (W/cm^2)');title('Preampa output');
%             str = strcat('fwhm = ', num2str(fwhmE)); grid on;legend(str);
% % --------------------------------------------------------------------------
% %_FINAL_SPECTR__________________________________________________________
%                 figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
%                 plot(ejel,(abs(ifft(Eosc)).^2)/max(abs(ifft(Eosc)).^2),'k',ejel,(abs(ifft(E)).^2)/max(abs(ifft(E)).^2),'r--');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
%                 xlabel('l(nm)');ylabel('I (W/cm^2)');title('Spectrum evolution Preampa');
%                 str = strcat('fwhmi = ', num2str(fwhmSP0));
%                 str = strcat(str,'    fwhmf= ');
%                 str = strcat(str,num2str(fwhmSPF));
%                 legend(str); grid on;
%                 if prt == 1
%                   fprintf(fid0,'Preampa= %f %f ',fwhmE,fwhmSPF);
%                 end
% %-----------------------------------------------------------------------
% norma=normy(E,t,dt)
%             if prt == 1
%                fprintf(fid0,'After preampa: %e %e\nTotal Bint = %e\n',norma,Bint,Bint_T);
%             end
            
%_AMPHOS_FILTERING______________________________________________________
% en nm
[E,filter]=amphosfilter(E,ejel,lc*1000,2);
%----------------------------------------------------------------------
            figure(nfig);nfig=nfig+1;fwhmSP0=abs(fwhm(ejel,abs(ifft(Eosc)).^2));fwhmSPF=abs(fwhm(ejel,abs(ifft(E)).^2));
            subplot(1,2,1);
            plot(ejel,abs(ifft(Eosc)).^2,'k',ejel,abs(ifft(E)).^2,'b');%axis([-10*tp 10*tp 0 max(abs(E).^2)]);
            xlabel('l(nm))');ylabel('I (W/cm^2)');title('Spectrum filtering by AMPHOS');
            str = strcat('fwhmi = ', num2str(fwhmSP0));
            str = strcat(str,'    fwhmf= ');
            str = strcat(str,num2str(fwhmSPF));
            legend(str); grid on;
            subplot(1,2,2);
            plot(ejel,filter);xlabel('l(nm))'); title('AMPHOS filter');grid on;
            if prt == 1
               fprintf(fid0,'filter AMPHOS= %f %f -- %f vs %f \n',filterwidth,supergaussianm,fwhmSP0,fwhmSPF);
            end
            %-----------------------------------------------------------------------
            fwhmEo=fwhm(t,(abs(E)).^2);figure(nfig);nfig=nfig+1;
            plot(t,abs(E).^2);axis([-400*ps 400*ps 0 max(abs(E).^2)]);
            xlabel('t(fs)');ylabel('I (W/cm^2)');title('AMPHOS output with filter');
            str = strcat('fwhm = ', num2str(fwhmEo)); grid on;legend(str);
%----------------------------------------------------------------------

%_COMPRESSOR_DISPERSION____________________.______________________________
E1=E;
kpcompr=1:3;
kpcompr1=0.*kpcompr;
% for i11=1:3
%     kpcompr1(i11)=-kposc(i11)-kpch3_1(i11)-kpcfbgxf2(i11)-kpch3_2(i11)-kpch6_0(i11)-kpch6_1(i11)-kpch7_1(i11)-kpcfbgxf1(i11)-kpch8_0(i11);
%     kpcompr1(i11)=kpcompr1(i11)-kpch8_1(i11)-kpch10_0(i11)-kpch10_1(i11)-kpch10_2(i11)-kpch10_3(i11)-kpch10_4(i11);
%     kpcompr1(i11)=kpcompr1(i11)-kppreamp_1(i11)-kppreamp_2(i11)-kppreamp_3(i11)-kppreamp_4(i11)-kppreamp_5(i11)-kppreampa(i11);
% end
%             if prt == 1
%                fprintf(fid0,'kpcompr1= %e %e %e -- %f \n',kpcompr1(1),kpcompr1(2),kpcompr1(3),fwhmEo);
%             end
%_parameters
lambda=mm*lc;                       % longitud de onda en mm;
vluzsc=vluz*mm;                     % velocidad de la luz (mm fs^-1)
rad=pi/180;
alfa=62.*rad;                       % incidence angle (rad).
lred=1760;                          % grating lines/mm.
d=1/lred;                           % line separation (mm).
j1=0;
Lg=500;                             % grating distance (mm).

% CHEQUEO A MANO
while j1==0
        kpcompr=2*compressor_dispersion(alfa,d,Lg,lambda,vluzsc);
%         factorcompr=kpcompr(1)/kpcompr1(1)
%         kpcompr=kpcompr./factorcompr
        kpcompr(3)=0.;
        kpcompr(2)=0.; % pongo las dos a cero porque supongo que el tercer y el cuarto orden estan perfectamente compensados en las cfbg. tambien lo pongo a cero en ellas.
        [E1]=disp_pulse(E,w,kpcompr);
        trazac=correlate(E1);fwhmTR=fwhm(t,trazac)
        fwhmE1=fwhm(t,abs(E1).^2)
        % 10% wings
        fwings=0.1*max(factortotal*abs(E1).^2);
        FW=0.*E1+fwings;
        figure(nfig);nfig=nfig+1;
                subplot(1,2,1);plot(t,factortotal*abs(E1).^2,'b',t,FW,'r');axis([-10*tp 10*tp 0 max(factortotal*abs(E1).^2)]);
                xlabel('t(fs)');ylabel('I (W/cm^2)');title('Compressor output');
                str = strcat('fwhm = ', num2str(fwhmE1));legend(str);grid on;
                subplot(1,2,2);plot(t,trazac,'k');axis([-10*tp 10*tp 0 max(trazac)]);
                xlabel('t(fs)');ylabel('I (W/cm^2)');title('ACT Compressor output');
                str = strcat('fwhm = ', num2str(fwhmTR));legend(str);grid on;
        j1=0;

        Lg1=Lg;
        Lg=input('Lg');
        if Lg == 0
            if prt == 1
               fprintf(fid0,'%f %f %f\n',Lg1,fwhmE1,fwhmTR);
               descripcion=input('Descripcion del fichero: ','s')
               fprintf(fid0,'%s\n',descripcion);
               cl=clock;
               strfilename=strcat('xf1_1_',num2str(cl(4)),num2str(cl(5)),num2str(cl(6)),'.txt');
               fid1=fopen(strfilename,'w');
               y = [t;real(E1);imag(E1)];
               fprintf(fid1,'%f %e %e\n',y);
               fid2=fopen('xf1_1_files.txt','a+');
               fprintf(fid2,'%s\n',strfilename);
               fprintf(fid0,'%s %s\n','file = ',strfilename);
               fclose(fid1);
            end
            break;
        end
end
                
fclose('all');


                
