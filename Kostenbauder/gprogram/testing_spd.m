% testing
function [ret]=testing_spd()
clear all;
close all;
% units
mic=1;fs=1;ns=1e6;mJ=1;mm=mic/1000;m=1e-3;ps=1e3;s=fs*1e-15;J=mJ*1e-3;

%_PULSE_PARAMETERS______________________________________________________
lc=1.03;             % pulse central wavelength (mic)
ko=2*pi/lc;          % mic^-1)
vluz=0.3;            % speed of light (mic fs^-1)
wo=2*pi*vluz/lc;     % pulse central omega (fs^-1)
tp=159.135*fs;       % pulse width (fs).
a=5*10^-3;           % spatial fwhm (mm)
energia=6.12e-7;     % Energy (mJ)
%-----------------------------------------------------------------------

%_TEMPORAL_AND_SPECTRAL_AXIS__________________________________________________________
npuntos=2^18;                          % number of points.
maxt=6*ns;                             % temporal window to follow                  

dt=2*maxt/(npuntos-1);                 % time resolution
t=-maxt:dt:maxt;                       % temporal axis (fs)
dw=2*pi/(2*maxt);                      % frequency axis (fs^-1)
wN=-pi/dt:dw:pi/dt;
w=ifftshift(wN); 
wf=-w;                                 % for frequency sign criteria
ejel=wf.*1000*lc*lc/vluz/2/pi+1000*lc; % wavelength axis (nm)
%------------------------------------------------------------------------

%_ELECTRIC_FIELD________________________________________________________
tau=tp/(2*acosh(sqrt(2))); to=0.; P=(sech((t-to)/tau)).^2; E=sqrt(P);
%-----------------------------------------------------------------------
Eo=E;
tic
for i1=1:500
    E=ifft(E);
    E=fft(E);
end
toc
%------------------------------------------------------------------------
                nfig=1;figure(nfig);nfig=nfig+1;
                plot(t,(abs(Eo)).^2,'r.',t,(abs(E)).^2,'b');
%------------------------------------------------------------------------
GPUstart
EG=GPUdouble(Eo);
tic
for i2=1:500
    EG=ifft(EG);
    EG=fft(EG);
end
toc
%------------------------------------------------------------------------
                nfig=1;figure(nfig);nfig=nfig+1;
                plot(t,(abs(Eo)).^2,'r.',t,(abs(EG)).^2,'b');
%------------------------------------------------------------------------
