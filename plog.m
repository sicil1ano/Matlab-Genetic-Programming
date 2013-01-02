function out = plog(x)
%PLOG Function to calculate the element by element protected natural log of
%a vector. 
%
% [OUT]=PLOG(X) performs LOG(ABS(X))



out=log(abs(x));

out(isinf(out))=0;
