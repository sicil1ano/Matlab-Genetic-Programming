function out=iflte(a,b,c,d)
% IFLTE Function to perform an element wise IF THEN ELSE operation
% on vectors and scalars.
%   [OUT]=IFLTE(A,B,C,D)
%
%   This performs: 
%   If A<=B then C else D
%   on an element by element basis.
%
%   Remarks:
%   If all of A,B,C,D are scalars then OUT will be scalar.
%   If some, but not all, of A,B,C,D are scalars then OUT will be vector
%


out=((a<=b) .* c) + ((a>b) .* d);

