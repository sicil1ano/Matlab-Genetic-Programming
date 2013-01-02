%GPDEMO2 GPTIPS demo of multiple gene regression on non-linear data.
%
%   Also demonstrates some post run analysis functions such as SUMMARY,
%   RUNTREE and POPBROWSER and the use of the Symbolic Math Toolbox to 
%   simplify expressions (if it is present).
% 
%   View this file to see how the symbolic toolbox has been used to create a 
%   single mathematical expression using the gene expressions and the gene
%   weighting coefficients.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also GPDEMO2_CONFIG, REGRESSMULTI_FITFUN, GPDEMO1, GPDEMO3, GPREFORMAT,
%   SUMMARY, RUNTREE, GPPRETTY

clc;
disp('GPTIPS Demo 2: multigene symbolic regression');
disp('-----------------------------------------');
disp('Multigene regression on 400 data points genenerated by the non-linear'); 
disp('function with 4 inputs y=exp(2*x1*sin(pi*x4)) + sin(x2*x3).');
disp(' ');
disp('The configuration file is gpdemo2_config.m and the raw data is in demo2data.mat');
disp('At the end of the run the predictions of the evolved model will be plotted'); 
disp('for the training data as well as for an independent test data set generated');
disp('from the same function.');
disp(' ');
disp('Here, 2 genes are used (plus a bias term) so the form of the model will be: ');
disp('ypred = c0 + c1*tree1 + c2*tree2');
disp('where c0 = bias and c1 and c2 are the weights.')
disp('The bias and weights (i.e. regression coefficients) are automatically'); 
disp('determined by a least squares procedure for each multigene individual.');
disp(' ');

disp('First, call GPTIPS program using the configuration in gpdemo2_config.m using:');
disp('>>gp=rungp(''gpdemo2_config'');');
disp('Press a key to continue');
disp(' ');
pause;

%Call GP program using the configuration in regressmulti.m
gp=rungp('gpdemo2_config');

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
    disp(' ');
    disp('Using the symbolic math toolbox it is possible to combine the gene');
    disp('expressions with the gene weights (regression coefficients) to display');
    disp('a single function that predicts the output using the inputs x1, x2, x3, x4.');
    
    
    
    
    disp('E.g. using the the GPPRETTY command on the best individual: ');
    disp('>>gppretty(gp,''best'')');
    disp(' ');
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
