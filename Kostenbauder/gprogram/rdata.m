function [ret]=rdata()
clear all;
close all;
nfig=1;
fid0=fopen('xf1_1_files.txt','r');

while ~feof(fid0)
    datafile = fscanf(fid0,'%s',1)
    fid1=fopen(datafile,'r');
    a = fscanf(fid1,'%e %e %e',[3 inf]);
    a = a';
    t = a(:,1);
    E1 = a(:,2)+i*a(:,3);
                trazac=correlate(E1);fwhmTR=fwhm(t,trazac);
                fwhmE1=fwhm(t,abs(E1).^2)
                % 10% wings
                fwings=0.1*max(abs(E1).^2);
                FW=0.*E1+fwings;
                figure(nfig);nfig=nfig+1;
                subplot(1,2,1);plot(t,abs(E1).^2,'b',t,FW,'r');axis([-4000 4000 0 max(abs(E1).^2)]);
                xlabel('t(fs)');ylabel('I (W/cm^2)');title('Compressor output');
                str = strcat('fwhm = ', num2str(fwhmE1));legend(str);grid on;
                subplot(1,2,2);plot(t,trazac,'k');axis([-4000 4000 0 max(trazac)]);
                xlabel('t(fs)');ylabel('I (W/cm^2)');title('ACT Compressor output');
                str = strcat('fwhm = ', num2str(fwhmTR));legend(str);grid on;
    fclose(fid1);
end
fclose(fid0);