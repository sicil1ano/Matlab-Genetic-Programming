function [fitness,gp]=quartic_fitfun(evalstr,gp)
%QUARTIC_FITFUN GPTIPS fitness function for simple symbolic regression on 
%the quartic polynomial y=x+x^2+x^3+x^4. 
%   
%   [FITNESS,GP]=QUARTIC_FITFUN(EVALSTR,GP) returns the FITNESS value of 
%   the symbolic expression(s) contained within the cell array EVALSTR 
%   using the information in the GP structure.
%   
%
%    (c) Dominic Searson 2009
%
%    v1.0
%
%    See also: GPDEMO1_CONFIG, GPDEMO1

% Extract x and y data from GP struct
x1=gp.userdata.x;
mag1=gp.userdata.mag;
fase1=gp.userdata.fase;

% Evaluate the tree (assuming only 1 gene is suppled in this case - if the
% user specified multigene config then only the first gene encountered will be used)

eval(['out=' evalstr{1} ';']);

% Fitness is sum of absolute differences between actual and predicted y
fitness=sum(abs(out-mag1)+(mod(abs(angle(out)-fase1*pi/180)),360)/360);

% If this is a post run call to this function then plot graphs
%if gp.state.run_completed
%    figure
%    plot(x1,y,'o-');hold on;
%    plot(x1,out,'rx-');
%    legend('y','predicted y');
%    title('Prediction of quartic polynomial over range [-1 1]');
%    hold off;
% end
    
