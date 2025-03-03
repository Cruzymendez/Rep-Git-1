function [norma]=normy(E,t,dt)
   norma=0.;
   for it=1:length(t)
      norma=norma+abs(E(it))^2;
   end
   norma=norma*dt;