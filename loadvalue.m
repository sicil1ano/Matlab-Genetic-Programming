function [F] = loadvalue()
%LOADVALUE Summary of this function goes here
%   Detailed explanation goes here
s=tf('s');
%F=(1+s)/(s^2+5*s+9);
load tr_sf;
%trf_final=eval(tr_sf);
F=eval(tr_sf);
delete tr_sf.mat;
[mag,fas,w]=bode(F);
for i=1:length(mag);
    mag1(i)=mag(i);
end;
for i=1:length(fas);
    fas1(i)=fas(i);
end;
mag=mag1';
fas=fas1';

save w w;
save fas fas;
save mag mag;

end

