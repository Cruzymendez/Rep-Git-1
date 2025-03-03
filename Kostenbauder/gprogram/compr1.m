function [ret]=compr()
clear all;
close all;

mic=1;
mm=mic/1000;

%_PULSE_PARAMETERS______________________________________________________
% ojo, en el ajuste sellmeier las longitudes de onda están en micras...
lc=0.8;                 % longitud de onda a estudiar (mic)
ko=2*pi/lc;             % vector de onda (mic^-1)
vluz=0.29979;           % velocidad de la luz (mic fs^-1)
wo=2*pi*vluz/lc;        % frecuencia central (fs^-1)
tp=50;                  % la duracion es doble!!definido en funcion pulso)
a=4*10^-3;              % fwhm espacial pulso
dt=tp/20.;maxt=4000;     % coordenada temporal
energia=1.0e-12;        % mJ

%_UNIDADES_STRETCHER_COMPRESSOR__________________________________________
l0=mm*lc;                % longitud de onda en mm
k0=2*pi/l0;              % vector de noda (mm^-1)
vluzsc=0.29979*mm;       % velocidad de la luz (mm fs^-1)
w0=2*pi*vluzsc/l0;         % frecuencia central (fs^-1)
%----------------------------------------------------------------------

%_STRETCHER_DISPERSION__________________________________________________
%_parameters
lambda=l0;
rad=pi/180;
alfa=28.7 *rad;                        % ángulo de incidencia en radianes.
lred=1200;                             % lineas/mm de la red
d=1/lred;                              % separación entre líneas en mm.
Lg=400;                                % mm, distancia entre redes
kpstr=1:3;
kpcompr=kpstr;
kpcompr=compressor_dispersion(alfa,d,Lg,lambda,vluzsc);
kpstr=-2*kpcompr;
kp2st=kpstr(1);
kp3st=kpstr(2);
kp4st=kpstr(3);
[Ei,Eo,t,wf]=plot_pulse(kpstr,tp,dt,maxt,energia,a);
%-----------------------------------------------------------------------

%_ MATERIAL_DISPERSION___________________________________________________
%gvd,tod y fod.en fs y mm.
kpmat=1:3;
lambda=lc;
material=1;                                          % 1=fused silica
length_m=200.;                                         % mm
kpmat=mat_dispersion(material,lambda,vluz,length_m); %todo en micras y mm
material=4;                                          % 4=zafiro
length_m=880.;                                         % mm
kpmat=kpmat+mat_dispersion(material,lambda,vluz,length_m); %todo en micras y mm
kp2m=kpmat(1);
kp3m=kpmat(2);
kp4m=kpmat(3);
[Ei,Eo,t,wf]=plot_pulse(kpmat+kpstr,tp,dt,maxt,energia,a);
%-----------------------------------------------------------------------

% ejemplo de busqueda de mejores parametros de compresion
alfav=26.5:0.05:31.5;                     % barremos angulos
Lgv=390:0.2:440;                        % barremos distancia de red
[xa,yl]=meshgrid(alfav,Lgv);
trf=xa.^2+yl.^2;
trf=0.*trf;

[a salfa]=size(alfav);
[b sLgv]= size(Lgv);

%_COMPRESSOR_DISPERSION__________________________________________________
%_parameters
lambda=l0;
rad=pi/180;
lred=1200;                             % lineas/mm de la red
d=1/lred;                              % separación entre líneas en mm.
kpcompr=1:3;
i2=1;
for alfavi=26.5:0.5:31.5
    i1=1;
    for Lgvi=390:1:440
        alfa=alfavi*rad;               % ángulo de incidencia en radianes.
        Lg=Lgvi;                    % mm, distancia entre redes
        kpcompr=2*compressor_dispersion(alfa,d,Lg,lambda,vluzsc);
        kp2c=kpcompr(1);kp3c=kpcompr(2);kp4c=kpcompr(3);
        [Ei,Eo,t,wf]=plot_pulse(kpcompr+kpmat+kpstr,tp,dt,maxt,energia,a);
        fwhmEo=ffwhm(Eo,t);fwhmEi=ffwhm(Ei,t);
        trf(i1,i2)=fwhmEo;
        i1=i1+1;
        trazac=autocorr(Eo,t,800);
     end
    i2=i2+1
end
figure,surf(xa,yl,trf);shading interp;

% figure;
% subplot(1,3,1);
% plot(t,abs(Ei).^2,'k');axis([-100 100 0 max(abs(Ei).^2)]);
% subplot(1,3,2);
% plot(t,abs(Eo).^2,'g');axis([-300 300 0 max(abs(Eo).^2)]);
% theta=unwrap(angle(Ei));
% theta0=unwrap(angle(Eo));
% subplot(1,3,3);plot(wf,theta0,'k.',wf,theta,'g.');

function trazac=autocorr(E,t,res)
[d1 d2]=size(t);
if res ~= 0
   vc=ceil(d2/2);
   En=ones(1,2*res);
   tn=ones(1,2*res);
   i2=vc-res;
   for i3=1:2*res
      En(i3)=E(i2+i3-1);
      tn(i3)=t(i2+i3-1);
   end
   [d1 d2]=size(tn);
   I1=(abs(En)).^2;
else 
end

dt=t(2)-t(1);
nt=1:2*d2;
A1=zeros(1,3*d2);
A2=A1;
trazac=zeros(1,2*d2);
delay=0;
for delay=1:2*d2
    for i0=1:d2
        A1(i0+delay)=I1(i0);
        if delay==1
            A2(i0+d2)=I1(i0);
        else
        end
    end
    nt(delay)=delay*dt;
    trazac(delay)=sum(A1.*A2);
end
subplot(1,2,1);plot(nt,trazac,'k.');
subplot(1,2,2);plot(tn,(abs(En)).^2);
pause;





function fwhm = ffwhm(E,t)
% fwhm de un campo dado, como valor de busqueda
hm=(max(abs(E).^2))/2;
% coordenada central
% en vez de la centra... voy a buscar el maximo...
[d1 d2]=max(abs(E).^2);
vi=d2;
[d1 d2]=size(t);
%vi=ceil(d2/2)
Ep=(abs(E).^2)-hm;
valor1=0.;
valor2=0.;
vis=0;
if Ep(vi)>0.
    for i1=vi:-1:1
        if Ep(i1)<0
            valor1=i1;
            vis=1;
        end
        if vis==1
         break
        end
    end
    vis=0;
    for i2=vi:d2
        if Ep(i2)<0
            valor2=i2;
            i2=d2;
            vis=1;
        end
        if vis==1
         break
        end
    end
else
    disp('valor negativo');
    figure()
    plot(t,(abs(E).^2),'k',t,Ep,'r');
end
% t(valor1)
% t(valor2)
fwhm=abs(t(valor1))+abs(t(valor2));
if fwhm>300
    fwhm=-100;
end

function [Ei,Eo,t,wf]=plot_pulse(dispersion,tp,dt,maxt,energia,a)

% coordenada temporal
t=-maxt*tp:dt:maxt*tp;

% coordenada frecuencias
dw=2*pi/(2*maxt*tp);
wN=-pi/dt:dw:pi/dt;
w=ifftshift(wN); 
wf=-w;                        % por criterio de signo en frecuencias

% pulso sin chirp
% E=exp(-t.*t*(log(2))/2/tp^2);       % fwhm en intensidad
 E=exp(-t.*t/tp^2);                % 1/e^2 en intensidad
% E=exp(-t.*t/2/tp^2);              % 1/e en intensidad
ENC=E;

% pulso con chirp
kp2=dispersion(1); %fs^2
kp3=dispersion(2);
kp4=dispersion(3);
Ew=ifft(E);
phase=(kp2*w.*w/2+kp3*(w.^3)/6+kp4*(w.^4)/24);
Ew=Ew.*exp(j*phase);
E=fft(Ew);

% energia del pulso 
norma=0;
normaNC=0;
for it=1:length(t)
    norma=norma+abs(E(it))^2;
    normaNC=normaNC+abs(ENC(it))^2;
end
norma=norma*dt*pi*a^2/2;
normaNC=normaNC*dt*pi*a^2/2;

E=E.*sqrt(energia/norma);
ENC=ENC*sqrt(energia/norma);

Eo=E;
Ei=ENC;



function kpcompr=compressor_dispersion(alfa,d,Lg,lambda,vluz)
%_ COMPRESSOR_DISPERSION_RESULTS____________________________________________________
%gvd,tod y fod.en fs y mm.
l0=lambda;
w0=2*pi*vluz/l0;
mic=1;
mm=mic/1000;
l1=0.78:0.005:0.82;l1=l1.*mm;                % longitud de onda en mm
k1=2*pi./l1;              % vector de noda (mm^-1)
w1=2*pi*vluz./l1;         % frecuencia central (fs^-1)

kp2wc=- (((l0^3)*Lg/(pi*vluz*vluz*d*d))*(1-((l0/d)-sin(alfa))^2)^(-3/2))/2;  % fs^2
kpcompr(1)=kp2wc;
kp2wc1=-(((l1.^3).*Lg./(pi*vluz*vluz*d*d)).*(1-((l0./d)-sin(alfa)).^2).^(-3/2))/2;
kp3wc= (12*pi*pi*vluz*Lg)/((d*d*w0^4)*(1-((2*pi*vluz/d/w0)-sin(alfa))^2)^(3/2));
kp3wc= kp3wc+(24*pi*pi*pi*vluz*vluz*Lg*((2*pi*vluz/d/w0)-sin(alfa)))/(d*d*d*(w0^5)*(1-((2*pi*vluz/d/w0)-sin(alfa))^2)^(5/2));
kp3wc1= (12*pi*pi*vluz*Lg)./((d*d*w1.^4).*(1-((2*pi*vluz/d./w1)-sin(alfa)).^2).^(3/2));
kp3wc1= kp3wc+(24*pi*pi*pi*vluz*vluz*Lg.*((2*pi*vluz/d./w1)-sin(alfa)))./(d*d*d*(w1.^5).*(1-((2*pi*vluz/d./w1)-sin(alfa)).^2).^(5/2));
kpcompr(2)=kp3wc;
kp4wc= (48*(pi^4)*vluz*vluz*vluz*Lg)/((d*d*d*d*w0^7)*(1-((2*pi*vluz/d/w0)-sin(alfa))^2)^(5/2));
kp4wc= kp4wc+(48*(pi^2)*vluz*Lg)/((d*d*w0^5)*(1-((2*pi*vluz/d/w0)-sin(alfa))^2)^(3/2));
kp4wc= kp4wc+ (192*pi*pi*pi*vluz*vluz*Lg*((2*pi*vluz/d/w0)-sin(alfa)))/(d*d*d*(w0^6)*(1-((2*pi*vluz/d/w0)-sin(alfa))^2)^(5/2));
kp4wc= kp4wc+ (240*pi*pi*pi*pi*vluz*vluz*vluz*Lg*((2*pi*vluz/d/w0)-sin(alfa))^2)/(d*d*d*d*(w0^7)*(1-((2*pi*vluz/d/w0)-sin(alfa))^2)^(7/2));
kp4wc= -kp4wc;
kpcompr(3)=kp4wc;
kp4wc1= (48*(pi^4)*vluz*vluz*vluz*Lg)./((d*d*d*d*w1.^7).*(1-((2*pi*vluz/d./w1)-sin(alfa)).^2).^(5/2));
kp4wc1= kp4wc1+(48*(pi^2)*vluz*Lg)./((d*d*w1.^5).*(1-((2*pi*vluz/d./w1)-sin(alfa)).^2).^(3/2));
kp4wc1= kp4wc1+ (192*pi*pi*pi*vluz*vluz*Lg.*((2*pi*vluz/d./w1)-sin(alfa)))./(d*d*d*(w1.^6).*(1-((2*pi*vluz/d./w1)-sin(alfa)).^2).^(5/2));
kp4wc1= kp4wc1+ (240*pi*pi*pi*pi*vluz*vluz*vluz*Lg.*((2*pi*vluz/d./w1)-sin(alfa)).^2)./(d*d*d*d*(w1.^7).*(1-((2*pi*vluz/d./w1)-sin(alfa)).^2).^(7/2));
kp4wc1=-kp4wc1;

% figure (1)
% subplot(1,3,1); plot(w1,kp2wc1);
% subplot(1,3,2); plot(w1,kp3wc1);
% subplot(1,3,3); plot(w1,kp4wc1);
%pause;

function kpmat=mat_dispersion(material,lc,vluz,length);
%length en mm.

B=1:3;
lb=1:3;
%SELLMEIER COEFF (AGRAW)
%wavelength in microns.
switch material
    case 1 % fused silica
      B(1)=0.6961663;
      B(2)=0.4079426;
      B(3)=0.8974794;
      lb(1)=0.0684043;
      lb(2)=0.1162414;
      lb(3)=9.896161;
    case 2 % KDP ordinary wave
      %seguir estudiandolo en http://refractiveindex.info
      B(1)=1-2.259276;
      B(2)=(sqrt(0.001008956))/0.0129426;
      B(3)=13.00522;
      lb(1)=sqrt(2*lc);
      lb(2)=sqrt(0.0129426);
      lb(3)=sqrt(400);
    case 3 % BK7
      B(1)=1.03961212;
      B(2)=0.231792344;
      B(3)=1.01046945;
      lb(1)=0.077464176;
      lb(2)=0.141484679;
      lb(3)=10.17647547;
    case 4 % Sapphire ordinary wave
      B(1)=1.43134930;
      B(2)=0.65054713;
      B(3)=5.3414021;
      lb(1)=sqrt(5.2799261e-3);
      lb(2)=sqrt(1.42382647e-2);
      lb(3)=sqrt(3.25017834e2);
    otherwise % fused silica
      B(1)=0.6961663;
      B(2)=0.4079426;
      B(3)=0.8974794;
      lb(1)=0.0684043;
      lb(2)=0.1162414;
      lb(3)=9.896161;
end
nag(lc,vluz,B,lb) %comprobar para distintos materiales.
wo=2*pi*vluz/lc;
kp2m=(10^3)*(2*dndwag(lc,vluz,B,lb)+wo*d2ndwag(lc,vluz,B,lb))/vluz;    % fs^2/mm
kp3m=(10^3)*(3*d2ndwag(lc,vluz,B,lb)+wo*d3ndwag(lc,vluz,B,lb))/vluz;   % fs^3/mm
kp4m=(10^3)*(4*d3ndwag(lc,vluz,B,lb)+wo*d4ndwag(lc,vluz,B,lb))/vluz;   % fs^4/mm
kpmat(1)=kp2m*length;
kpmat(2)=kp3m*length;
kpmat(3)=kp4m*length;


function nw=nag(l,vluz,B,lb);
% función que da como resultado el índice de refracción de un material a
% partir de los coeficientes de sellmeier. Siguiendo agrawal.
wl=2*pi*vluz./lb;
w=2*pi*vluz./l;

nw=1;
for i1=1:3
    nw=nw+B(i1)*wl(i1)*wl(i1)/(wl(i1)*wl(i1)-w*w);
end
nw=sqrt(nw);

function dndw=dndwag(l,vluz,B,lb);
% primera derivada del índice de refracción con respecto a la frecuencia
% a partir de los coeficientes de sellmeier, siguiendo agrawal.

wl=2*pi*vluz./lb;
w=2*pi*vluz./l;

nw=1;
for i1=1:3
    nw=nw+B(i1)*wl(i1)*wl(i1)/(wl(i1)*wl(i1)-w*w);
end
nw=sqrt(nw);

dndw=0;
for i1=1:3
    dndw=dndw+B(i1)*wl(i1)*wl(i1)*2*w/(wl(i1)*wl(i1)-w*w)^2;
end
dndw=dndw/2/nw;

function d2ndw=d2ndwag(l,vluz,B,lb); %para GVD
% segunda derivada del índice de refracción con respecto a la frecuencia
% a partir de los coeficientes de sellmeier, siguiendo agrawal.

wl=2*pi*vluz./lb;
w=2*pi*vluz./l;

nw=1;
for i1=1:3
    nw=nw+B(i1)*wl(i1)*wl(i1)/(wl(i1)*wl(i1)-w*w);
end
nw=sqrt(nw);

dndw=0;
for i1=1:3
    dndw=dndw+B(i1)*wl(i1)*wl(i1)*2*w/(wl(i1)*wl(i1)-w*w)^2;
end
dndw=dndw/2/nw;

d2ndw=0;
for i1=1:3
    d2ndw=d2ndw+(2*B(i1)*(wl(i1))^4+6*B(i1)*wl(i1)*wl(i1)*w*w)/(wl(i1)*wl(i1)-w*w)^3;
end
d2ndw=-dndw*dndw/nw+d2ndw/(2*nw);

function d3ndw=d3ndwag(l,vluz,B,lb); 
% tercera derivada del índice de refracción con respecto a la frecuencia
% a partir de los coeficientes de sellmeier, siguiendo agrawal.

wl=2*pi*vluz./lb;
w=2*pi*vluz./l;

nw=1;
for i1=1:3
    nw=nw+B(i1)*wl(i1)*wl(i1)/(wl(i1)*wl(i1)-w*w);
end
nw=sqrt(nw);

dndw=0;
for i1=1:3
    dndw=dndw+B(i1)*wl(i1)*wl(i1)*2*w/(wl(i1)*wl(i1)-w*w)^2;
end
dndw=dndw/2/nw;

d2ndw=0;
for i1=1:3
    d2ndw=d2ndw+(2*B(i1)*(wl(i1))^4+6*B(i1)*wl(i1)*wl(i1)*w*w)/(wl(i1)*wl(i1)-w*w)^3;
end
d2ndw=-dndw*dndw/nw+d2ndw/(2*nw);

d3ndw=0;
for i1=1:3
    d3ndw=d3ndw-(dndw/(2*nw^2))*dndw*(2*B(i1)*(wl(i1))^4+6*B(i1)*wl(i1)*wl(i1)*w*w)/(wl(i1)*wl(i1)-w*w)^3;
    d3ndw=d3ndw+(1/2/nw)*(24*B(i1)*w*(wl(i1))^4+24*B(i1)*(w^3)*(wl(i1))^2)/(wl(i1)*wl(i1)-w*w)^4;
end
d3ndw=d3ndw+(dndw.^3)/nw/nw-2*dndw*d2ndw/nw;

function newd3ndw=newd3ndwag(l,vluz,B,lb); 
% tercera derivada del índice de refracción con respecto a la frecuencia
% a partir de los coeficientes de sellmeier, siguiendo agrawal.

wl=2*pi*vluz./lb;
w=2*pi*vluz./l;

nw=1;
for i1=1:3
    nw=nw+B(i1)*wl(i1)*wl(i1)/(wl(i1)*wl(i1)-w*w);
end
nw=sqrt(nw);

dndw=0;
for i1=1:3
    dndw=dndw+B(i1)*wl(i1)*wl(i1)*2*w/(wl(i1)*wl(i1)-w*w)^2;
end
dndw=dndw/2/nw;

d2ndw=0;
for i1=1:3
    d2ndw=d2ndw+(2*B(i1)*(wl(i1))^4+6*B(i1)*wl(i1)*wl(i1)*w*w)/(wl(i1)*wl(i1)-w*w)^3;
end
d2ndw=-dndw*dndw/nw+d2ndw/(2*nw);

newd3ndw=0;
for i1=1:3
    newd3ndw=newd3ndw+(1/2/nw)*(24*B(i1)*w*(wl(i1))^4+24*B(i1)*(w^3)*(wl(i1))^2)/(wl(i1)*wl(i1)-w*w)^4;
end
newd3ndw=newd3ndw-3*dndw*d2ndw/nw;

function d4ndw=d4ndwag(l,vluz,B,lb); 
% cuarta derivada del índice de refracción con respecto a la frecuencia
% a partir de los coeficientes de sellmeier, siguiendo agrawal.

wl=2*pi*vluz./lb;
w=2*pi*vluz./l;

nw=1;
for i1=1:3
    nw=nw+B(i1)*wl(i1)*wl(i1)/(wl(i1)*wl(i1)-w*w);
end
nw=sqrt(nw);

dndw=0;
for i1=1:3
    dndw=dndw+B(i1)*wl(i1)*wl(i1)*2*w/(wl(i1)*wl(i1)-w*w)^2;
end
dndw=dndw/2/nw;

d2ndw=0;
for i1=1:3
    d2ndw=d2ndw+(2*B(i1)*(wl(i1))^4+6*B(i1)*wl(i1)*wl(i1)*w*w)/(wl(i1)*wl(i1)-w*w)^3;
end
d2ndw=-dndw*dndw/nw+d2ndw/(2*nw);

d3ndw=0;
for i1=1:3
    d3ndw=d3ndw+(1/2/nw)*(24*B(i1)*w*(wl(i1))^4+24*B(i1)*(w^3)*(wl(i1))^2)/(wl(i1)*wl(i1)-w*w)^4;
end
d3ndw=d3ndw-3*dndw*d2ndw/nw;

d4ndw=0;
for i1=1:3
    d4ndw=d4ndw+(1/2/nw)*(24*B(i1)*(wl(i1))^6+240*B(i1)*(w^2)*(wl(i1))^4+120*B(i1)*(w^4)*(wl(i1))^2)/(wl(i1)*wl(i1)-w*w)^5;
end
d4ndw=d4ndw-3*d2ndw*d2ndw/nw-4*dndw*d3ndw/nw;
