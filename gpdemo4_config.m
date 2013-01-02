function [gp]=gpdemo4_config(gp)
%GPDEMO4_CONFIG Example GPTIPS configuration file demonstrating multiple 
%gene symbolic regression on a concrete compressive strength data set.
%  
%   This is the configuration file that GPDEMO4 calls.   
%
%   [GP]=GPDEMO4_CONFIG(GP) generates a parameter structure GP that 
%   specifies the GPTIPS run settings.
%
%   Remarks:
%   The data used in this example was retrieved from the UCI Machine 
%   Learning Repository:
%    
%   http://archive.ics.uci.edu/ml/datasets/Concrete+Compressive+Strength
%
%   The output being modelled is concrete compressive strength (MPa) and
%   the dependent variables are:
%
%   Cement (x1) - kg in a m3 mixture
%   Blast furnace slag (x2) - kg in a m3 mixture 
%   Fly ash (x3) - kg in a m3 mixture
%   Water (x4) - kg in a m3 mixture
%   Superplasticiser (x5) - kg in a m3 mixture
%   Coarse aggregate (x6) - kg in a m3 mixture 
%   Fine aggregate (x7) - kg in a m3 mixture
%   Age (x8) - range 1 - 365 days 
%
% 
%   Example:
%   [GP]=RUNGP('gpdemo4_config') uses this configuration file to perform 
%   symbolic regression with multiple gene individuals on the concrete data. 
%   The results and parameters used are stored in fields of the returned GP
%   structure.
%
%   Further remarks:
%   The demo configuration is show that a linear combination of shallow
%   trees comprising low order linear transforms can adequately explain 
%   much  of the variation in the data. More 'accurate' models can be 
%   obtained by increasing the number of genes and the tree depth, although 
%   this is likely to evolve less transparent, more complex models.
%
%   This configuration file also demonstrates the use of the GPSCALE 
%   function for pre-scaling the data prior to modelling.
%   
%
%   (C) Dominic Searson 2009
%
%   v1.0
%
%   See also: REGRESSMULTI_FITFUN, GPDEMO4, GPDEMO3 GPDEMO2, GPDEMO1,
%   RUNGP, GPSCALE



% Main run control parameters
% --------------------------

gp.runcontrol.pop_size=400;				   % Population size

gp.runcontrol.num_gen=150;				   % Number of generations to run for including generation zero

gp.runcontrol.verbose=5;                  % Set to n to display run information to screen every n generations



% Selection method options
% -------------------------


gp.selection.tournament.size=7;

gp.selection.tournament.lex_pressure=true; % True to use Luke & Panait's plain lexicographic tournament selection



% Fitness function specification
%-------------------------------

gp.fitness.fitfun=@regressmulti_fitfun;      % Function handle to name of the user's fitness function (filename with no .m extension).

gp.fitness.minimisation=true;                % Set to true if you want to minimise the fitness function (if false it is maximised).

gp.fitness.terminate=true;  %terminate run if fitness below acheived
gp.fitness.terminate_value=6.75 ;



% Set up user data
% ----------------
load concrete

%allocate to train, validation and test groups
gp.userdata.xtrain=Concrete_Data(tr_ind,1:8);
gp.userdata.ytrain=Concrete_Data(tr_ind,9);

gp.userdata.ytest=Concrete_Data(te_ind,9);
gp.userdata.xtest=Concrete_Data(te_ind,1:8);

gp.userdata.xval=gp.userdata.xtrain(val_ind,1:8);
gp.userdata.yval=gp.userdata.ytrain(val_ind);

gp.userdata.xtrain=gp.userdata.xtrain(tr_ind2,:);
gp.userdata.ytrain=gp.userdata.ytrain(tr_ind2);

%add noise variables to make problem harder
gp.userdata.xtrain = [gp.userdata.xtrain randn(size(gp.userdata.xtrain,1),300) ];
gp.userdata.xtest = [gp.userdata.xtest randn(size(gp.userdata.xtest,1),300) ];
gp.userdata.xval = [gp.userdata.xval randn(size(gp.userdata.xval,1),300) ];


  
%scale data to zero mean and unit variance
gp=gpscale(gp);

gp.userdata.datasampling = true;
gp.userdata.user_fcn=@regressmulti_fitfun_validate; %enables hold out validation set


% Input configuration
% -------------------

gp.nodes.inputs.num_inp=size(gp.userdata.xtrain,2);  % This sets the number of inputs (i.e. the size of the terminal set NOT including constants)



% Tree build options
% ------------------


gp.treedef.max_depth=5;                % Maximum depth of trees 

          

% Multiple gene settings
% ----------------------

gp.genes.multigene=true;               % Set to true to use multigene individuals and false to use ordinary single gene individuals.


gp.genes.max_genes=4;                  % The absolute maximum number of genes allowed in an individual.



% Define functions
% ----------------
%
%   (Below are some definitions of functions that have been used for symbolic regression problems)
%
%         Function name                                     Number of arguments
%   (must be an mfile on the path)
          
gp.nodes.functions.name{1}='times'      ;           
gp.nodes.functions.name{2}='minus'      ;               
gp.nodes.functions.name{3}='plus'       ;             
gp.nodes.functions.name{4}='rdivide'    ;            % unprotected divide (may cause NaNs)
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
gp.nodes.functions.active(11)=1;
gp.nodes.functions.active(12)=0;
gp.nodes.functions.active(13)=0;

