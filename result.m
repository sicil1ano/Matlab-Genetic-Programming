function [X] = result(gp,F)
%RESULT Summary of this function goes here
%   Detailed explanation goes here
x1=tf('s');
 str=gp.results.best.eval_individual{1};
 str=strrep(str,'x1.^','x1^');
X=eval(str);
bode(F,'r',X,'gx');

end

function [x] = rdivide(a,b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=a/b;

end

function [x] = times(a,b)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=a*b;

end