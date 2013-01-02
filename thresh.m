function out=thresh(a,b)
%THRESH A threshold function that returns 1 if the first argument is 
%greater than or equal to the second argument and returns 0 otherwise.

%   [OUT]=THRESH(A,B)
%
%   This performs: 
%   If A>=B then 1 else 0
%   on an element by element basis.
%
%   Remarks:
%   If both of A,B are scalars then OUT will be scalar.
%   If one but not both of A,B then OUT will be vector
%


out=((a>=b) .* 1) + ((b>a) .* 0);

