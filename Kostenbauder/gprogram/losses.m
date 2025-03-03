% Losses point in fiber chain
% Taking into account losses in one join point of the chain.
% alfa is dB and must have the correct sign (for losses -)
function [E]=losses(E,alfa)
   E=E*sqrt(10^(alfa/10));