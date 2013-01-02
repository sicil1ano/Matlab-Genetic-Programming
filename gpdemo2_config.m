function [gp]=gpdemo2_config(gp);
%REGRESSMULTI GPTIPS configuration file demonstrating multiple gene symbolic 
%regression on data (y) generated from a non-linear function of 4 inputs (x1, x2, x3, x4).
%
%   [GP]=GPDEMO2_CONFIG(GP) returns a parameter structure GP containing the settings
%   for GPDEMO2 (multigene symbolic regression using genetic programming). 
% 
%   Remarks:
%   There is one output y which is a non-linear
%   function of the four inputs y=exp(2*x1*sin(pi*x4)) + sin(x2*x3).
%   The objective of a GP run is to evolve a multiple gene symbolic
%   function of x1, x2, x3 and x4 that closely approximates y.
%
%   This function was described by:
%   Cherkassky, V., Gehring, D., Mulier F, Comparison of adaptive methods for function
%   estimation from samples, IEEE Transactions on Neural Networks, 7 (4), pp. 969-
%   984, 1996. (Function 10 in Appendix 1)
%   
%   Example:
%   [GP]=RUNGP('gpdemo2_config') uses this configuration file to perform symbolic
%   regression with multiple gene individuals on the data from the above function.   
%
%   (C) Dominic Searson 2009
% 
%   v1.0
%
%   See also: GPDEMO2, GPDEMO3_CONFIG, GPDEMO4, GPDEM03, GPDEMO1, REGRESSMULTI_FITFUN



% Main run control parameters
% --------------------------
gp.runcontrol.pop_size=100;                     % Population size
gp.runcontrol.num_gen=100;				        % Number of generations to run for including generation zero
                                                % (i.e. if set to 100, it'll finish after generation 99).
gp.runcontrol.verbose=10;                       % Set to n to display run information to screen every n generations 




% Selection method options
% -------------------------
gp.selection.method='tour';                 % Only tournament selection is currently supported.											 
gp.selection.tournament.size=3;                                                                                         
gp.selection.tournament.lex_pressure=true;  % True to use Luke and Panait's plain lexicographic tournament selection

 
             

% Fitness function specification 
% -------------------------------
gp.fitness.fitfun=@regressmulti_fitfun;                % Function handle of the fitness function (filename with no .m extension).
gp.fitness.minimisation=true;                          % Set to true if you want to minimise the fitness function (if false it is maximised).
gp.fitness.terminate=true;
gp.fitness.terminate_value=0.01;



% Set up user data
% ----------------

%load in the raw x and y data
load demo2data 
 
gp.userdata.xtrain=x(101:500,:); %training set (inputs)
gp.userdata.ytrain=y(101:500,1); %training set (output)
gp.userdata.xtest=x(1:100,:); %testing set (inputs)
gp.userdata.ytest=y(1:100,1); %testing set (output)




% Input configuration
% -------------------
gp.nodes.inputs.num_inp=size(gp.userdata.xtrain,2); 		    % This sets the number of inputs (i.e. the size of the terminal set NOT including constants)



% Tree build options
% ----------------------

                         
gp.treedef.max_depth=5;                    % Maximum depth of trees                     

                                        
                                    

% Multiple gene settings
% ----------------------
gp.genes.multigene=true;                                    % True=use multigene individuals False=use ordinary single gene individuals.
gp.genes.max_genes=2;                                       % The absolute maximum number of genes allowed in an individual.                              

    


% Define functions
% ----------------  
%   (Below are some definitions of functions that have been used for symbolic regression problems) 

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
gp.nodes.functions.active(8)=0;                           
gp.nodes.functions.active(9)=0;                         
gp.nodes.functions.active(10)=0;                         
gp.nodes.functions.active(11)=0;                         
gp.nodes.functions.active(12)=0;  
gp.nodes.functions.active(13)=0;

                                     
                                   

