% GPDEMO3 GPTIPS demo of multiple gene regression on non-linear data.
% 
%    Also demonstrates some post run analysis functions such as SUMMARY 
%    and RUNTREE  and the use of the Symbolic Math Toolbox to simplify 
%    expressions (if it is present).
% 
%    View this file to see how the symbolic toolbox has been used to create
%    a single mathematical expression using the gene expressions and the 
%    gene weighting coefficients
%
%    (c) Dominic Searson 2009
%
%    v1.0
%
%    See also GPDEMO1, GPDEMO2, GPDEMO4, SUMMARY, RUNTREE, GPPRETTY

clc;
disp('GPTIPS Demo 3: multigene symbolic regression on pH data');
disp('------------------------------------------------------- ');
disp('In this example, the training data is 700 steady state data points'); 
disp('from a simulation of a pH neutralisation process.');
disp(' ');
disp('The output y has an unknown non-linear dependence on the 4 inputs x1, x2, x3 and x4.');
disp('300 data points are available as a test set to validate the evolved model(s).');
disp('The configuration file is gpdemo3_config.m and the raw data is in ph2data.mat');
disp(' ');
disp('Here, 4 genes are used (plus a bias term) so the form of the model will be: ');
disp('ypred = c0 + c1*tree1 + ...+ c4*tree4');
disp('where c0 = bias and c1,...,c4 are the gene weights.')
disp(' ');
disp('Plain lexicographic parsimony pressure is enabled and genes are limited'); 
disp('to a depth of 4.');
disp('The function nodes used are:  plus, minus, times and tanh.');
disp(' ');
disp('First, call GPTIPS program using the configuration in gpdemo3_config.m using:');
disp('>>gp=rungp(''gpdemo3_config'');');
disp('Press a key to continue');
disp(' ');
pause;

%Call GP program using the configuration in gpdemo3_config.m
gp=rungp('gpdemo3_config');

%Plot summary information of run
disp('Plot summary information of run using:');
disp('>>summary(gp)');


disp('Press a key to continue');
disp(' ');
pause;
summary(gp);

%Run the best individual of the run on the fitness function
disp('Run the best individual of the run on the fitness function using:');
disp('>>runtree(gp,''best'');');


disp('Press a key to continue');
disp(' ');
pause;
runtree(gp,'best');



%If Symbolic Math toolbox is present
if license('test','symbolic_toolbox')
    
    
    disp(' ');
    disp('Using the symbolic math toolbox it is possible to combine the gene'); 
    disp('expressions with the gene weights (regression coefficients) to ');
    disp('display a single function that predicts the output'); 
    disp('using the inputs x1, x2, x3, x4.');
    disp('E.g. using the the GPPRETTY command on the best individual: ');
    disp('>>gppretty(gp,''best'')');
   
    disp('Press a key to continue');
    disp(' ');
    pause;
    
    gppretty(gp,'best');
    disp(' ');

end


disp(' ');
disp('Finally, the POPBROWSER function may be used to display the population'); 
disp('of evolved models in terms of their complexity (number of nodes)');
disp('as well as their fitness. The POPBROWSER can be used to identify models');
disp('that perform relatively well and are much less complex than the "best" model');
disp('in the population (which is highlighted with a red circle).');
disp(' ');
disp('>>popbrowser(gp)');
disp(' ');
disp(' Press any key to launch the POPBROWSER. ' );
pause;
popbrowser(gp);
