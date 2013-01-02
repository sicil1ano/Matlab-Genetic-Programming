function [gp]=gpdemo3_config(gp)
%GPDEMO3_CONFIG Example GPTIPS configuration file demonstrating multiple 
%gene symbolic regression on data from a simulated pH neutralisation process.
%  
%   This is the configuration file that GPDEMO3 calls.   
%
%   [GP]=GPDEMO3_CONFIG(GP) generates a parameter structure GP that 
%   specifies the GPTIPS run settings.
%
%   Remarks:
%   The data in this example is taken a simulation of a pH neutralisation
%   process with one output (pH), which is a non-linear function of the 
%   four inputs.
%
%   Example:
%   [GP]=RUNGP('gpdemo3_config') uses this configuration file to perform 
%   symbolic regression with multiple gene individuals on the pH data. The 
%   results and parameters used are stored in fields of the returned GP 
%   structure.
%
%   (C) Dominic Searson 2009
%
%   v1.0
%
%   See also: REGRESSMULTI_FITFUN, GPDEMO4, GPDEMO3 GPDEMO2, GPDEMO1, RUNGP



% Main run control parameters
% --------------------------

gp.runcontrol.pop_size=150;				   % Population size

gp.runcontrol.num_gen=150;				   % Number of generations to run for including generation zero

gp.runcontrol.verbose=10;                  % Set to n to display run information to screen every n generations



% Selection method options
% -------------------------


gp.selection.tournament.size=4;

gp.selection.tournament.lex_pressure=true; % True to use Luke & Panait's plain lexicographic tournament selection

gp.selection.elite_fraction=0.02;       %  Elitist selection.
                                        %  Fraction of population to copy
                                        %  directly to next generation without modification.



% Fitness function specification
% ------------------------------

gp.fitness.fitfun=@regressmulti_fitfun;      % Function handle to name of the user's fitness function (filename with no .m extension).

gp.fitness.minimisation=true;                % Set to true if you want to minimise the fitness function (if false it is maximised).

gp.fitness.terminate=true;

gp.fitness.terminate_value=0.25;



% Set up user data
% ----------------

load ph2data %load in the raw x and y data from a simulation of a pH neutralisation process


gp.userdata.xtest=nx; %testing set (inputs)

gp.userdata.ytest=ny; %testing set (output)

gp.userdata.xtrain=x; %training set (inputs)
 
gp.userdata.ytrain=y; %training set (output)



% Input configuration
% -------------------

gp.nodes.inputs.num_inp=size(gp.userdata.xtrain,2); 		    % This sets the number of inputs (i.e. the size of the terminal set NOT including constants)



% Tree build options
% ------------------


gp.treedef.max_depth=4;                    % Maximum depth of trees 
  



% Multiple gene settings
% ----------------------

gp.genes.multigene=true;               % Set to true to use multigene individuals and false to use ordinary single gene individuals.


gp.genes.max_genes=4;                  % The absolute maximum number of genes allowed in an individual.




% Define functions
% ----------------
%
%   (Below are some definitions of functions that have been used for symbolic regression problems)
%
%         Function name (must be an mfile or builtin function on the path).
          
gp.nodes.functions.name{1}='times'      ;           
gp.nodes.functions.name{2}='minus'      ;               
gp.nodes.functions.name{3}='plus'       ;             
gp.nodes.functions.name{4}='rdivide'    ;            % unprotected divide
gp.nodes.functions.name{5}='psqroot'    ;            % protected sqrt
gp.nodes.functions.name{6}='plog'       ;            % protected natural log
gp.nodes.functions.name{7}='square'     ;            % .^2 square
gp.nodes.functions.name{8}='tanh'       ;            % tanh function
gp.nodes.functions.name{9}='pdivide'   ;            % protected divide function
gp.nodes.functions.name{10}='iflte'     ;            % IF-THEN-ELSE function
gp.nodes.functions.name{11}='sin'       ;            
gp.nodes.functions.name{12}='cos'       ;           
gp.nodes.functions.name{13}='exp'       ;              



% Active functions
% ----------------
%
% Manually setting a function node to inactive allows you to exclude a function node in a 
% particular run.
gp.nodes.functions.active(1)=1;
gp.nodes.functions.active(2)=1;
gp.nodes.functions.active(3)=1;
gp.nodes.functions.active(4)=0;
gp.nodes.functions.active(5)=0;
gp.nodes.functions.active(6)=0;
gp.nodes.functions.active(7)=0;
gp.nodes.functions.active(8)=1;
gp.nodes.functions.active(9)=0;
gp.nodes.functions.active(10)=0;
gp.nodes.functions.active(11)=0;
gp.nodes.functions.active(12)=0;
gp.nodes.functions.active(13)=0;


