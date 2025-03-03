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
