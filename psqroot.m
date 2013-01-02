function [out] = psqroot(x)
%PSQROOT function to get the element by element protected square root of 
%a vector, i.e. sqrt(abs(x))
%
% [OUT]=PSQROOT(X) performs the vector operation OUT=SQRT(ABS(X))   


out=sqrt(abs(x));
