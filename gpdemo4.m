% GPDEMO4 GPTIPS demo of multiple gene regression on a concrete compressive
% strength data set.
% 
%    Also demonstrates some post run analysis functions such as SUMMARY, RUNTREE and GPREFORMAT and the use
%    of the Symbolic Math Toolbox to simplify expressions (if it is present).
%
%    (c) Dominic Searson 2009
%
%   v1.0
%
%    See also GPDEMO1, GPDEMO3, GPDEMO4, SUMMARY, RUNTREE, GPPRETTY,
%    GPSCALE


clc;
disp('GPTIPS Demo 4: multigene symbolic modelling of concrete compressive strength data set');
disp('-------------------------------------------------------------------------------------');
disp('The output being modelled is concrete compressive strength (MPa) and');
disp('the input variables are:');
disp(' ');
disp('   Cement (x1) - kg in a m3 mixture');
disp('   Blast furnace slag (x2) - kg in a m3 mixture'); 
disp('   Fly ash (x3) - kg in a m3 mixture');
disp('   Water (x4) - kg in a m3 mixture');
disp('   Superplasticiser (x5) - kg in a m3 mixture');
disp('   Coarse aggregate (x6) - kg in a m3 mixture'); 
disp('   Fine aggregate (x7) - kg in a m3 mixture');
disp('   Age (x8) - range 1 - 365 days');  
disp(' ');
disp('To make things a little more interesting, and to show that GPTIPS can often');
disp('select relevant variables, another 300 variables consisting of normally ');
disp('distributed noise have been added to form the input variables x9');
disp('to x308. All data is then scaled to zero mean and unit variance');
disp('using the GPSCALE function.');
disp(' ');
disp('The configuration file is gpdemo4_config.m and the raw data is in concrete.mat');
disp(' ');
disp('The data has been divided into a training set, a holdout validation set');
disp('and a testing set.');
disp(' ');
disp('Press a key to evolve multigene models using GPTIPS.'); 
disp(' ');
pause;

%Call GP program using the configuration in gpdemo4_config.m
gp=rungp('gpdemo4_config');


%Run the best individual of the run on the fitness function
disp('The run is complete. Evaluate the best holdout validation individual of');
disp('the run on the fitness function using:');
disp('>>runtree(gp,''valbest'');');


disp('Press a key to continue');
disp(' ');
pause;
runtree(gp,'valbest');

pause;

%If Symbolic Math toolbox is present
if license('test','symbolic_toolbox')
    
    disp(' ');
    disp('Next, use the the GPPRETTY command on the best holdout validation individual: ');
    disp('>>gppretty(gp,''valbest'')');
    disp('Press a key to continue');
    disp(' ');
    pause;

   
    gppretty(gp,'valbest');
    disp(' ');
    disp('If the run has been very successful, the only variables present in ');
    disp('the model should be in the range x1 to x8.');
    disp('Less successful runs may contain the noise variables x9 - x308.');
    disp('If the results seem poor, try running the demo again.');
    disp(' ');
    disp('Press a key to continue');
    disp(' ');
    pause;
end



disp('To look at the frequency distribution of variables in the top 5% of');
disp('the final population use: ');
disp('>>gppopvars(gp);');

disp(' ');
disp('In practice, multiple runs are required to get a good picture of which variables');
disp('have the greatest influence on the output.');
disp(' ');
disp('Press a key to continue');
disp(' ');
pause
gppopvars(gp);

disp(' ');