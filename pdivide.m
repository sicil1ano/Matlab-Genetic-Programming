function [out]=pdivide(arg1,arg2)
%PDIVIDE function to perform a protected element by element divide on 
%two vectors of equal length.
%
%   [OUT]=PDIVIDE(ARG1,ARG2)
% 
%   For each element in ARG1 and ARG2:
% 
%   OUT=ARG1/ARG2
%
%   Unless ARG2==0 then OUT=0
%
%   v1.0


out=arg1./arg2;
I=(out==inf);

out(I)=0;
