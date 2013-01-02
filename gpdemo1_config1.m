function [gp]=gpdemo1_config(gp);
%GPDEMO1_CONFIG example configuration file demonstrating simple symbolic 
%regression.
%
%   The simple quartic polynomial (y=x+x^2+x^3+x^4) from John Koza's 1992 
%   Genetic Programming book is used.
%
%   [GP]=GPDEMO1_CONFIG(GP) returns the user specified parameter structure 
%   GP for the quartic polynomial problem.
%   
%   Example:
%   GP=GPTIPS('GPDEMO1_CONFIG') performs a GPTIPS run using this 
%   configuration file and returns the results in a structure called GP.
%
%   v1.0
%
%   (C) Dominic Searson 2009
% 
%   See also QUARTIC_FITFUN, GPDEMO1





% Main run control parameters
% ---------------------------
load p;
load g;
delete p.mat;
delete g.mat;
gp.runcontrol.pop_size=p;			% Population size
gp.runcontrol.num_gen=g;			% Number of generations to run for including generation zero
                                    % (i.e. if set to 100, it'll finish after generation 99).
gp.runcontrol.verbose=5;           % Set to n to display run information to screen every n generations







% Selection method options
% -------------------------

gp.selection.tournament.size=2;        
gp.selection.elite_fraction=0.2;      



% Fitness function and optimisation specification 
% ------------------------------------------------
gp.fitness.fitfun=@quartic_fitfun1;           % Function handle of the user's fitness function (filename with no .m extension).
gp.fitness.minimisation=true;                % True if to minimise the fitness function (if false it is maximised).
gp.fitness.terminate=true;                   % True to terminate run early if fitness threshold met
gp.fitness.terminate_value=1e-3;

% User data specification (sets up quartic polynomial data)  
% ----------------------------------------------------------------
%x=linspace(1,20,100)'; %generate 20 data points in the range [-1 1]

load w;
load mag;
load fas;
gp.userdata.x=w*i;
gp.userdata.mag=mag;
gp.userdata.fase=fas;
%gp.userdata.y=2*x.^2+2; %generate y



% Input configuration
% --------------------
% This sets the number of inputs 
gp.nodes.inputs.num_inp=1; 		         



% Constants
% ---------

% When building a tree this is
% the probability with which a constant will
% be selected instead of a terminal.
% [1=all ERCs, 0.5=1/2 ERCs 1/2 inputs, 0=no ERCs]
gp.nodes.const.p_ERC=0.3;		   % quartic example doesn't need constants            
if exist('rangeCostInf.mat') == 0 
	rangeCostInf = 0;
else 
	load rangeCostInf;
	delete rangeCostInf.mat;
end
if exist('rangeCostSup.mat') == 0 
	rangeCostSup = 10;
else
	load rangeCostSup;
	delete rangeCostSup.mat;
end
gp.nodes.const.range=[rangeCostInf,rangeCostSup];
gp.nodes.const.format='%d';

% Tree build options
% -------------------
             
% Maximum depth of trees 
gp.treedef.max_depth=2; 
 	              
% Maximum depth of sub-trees created by mutation operator
gp.treedef.max_mutate_depth=1;



% Define function nodes
% ---------------------

gp.nodes.functions.name{1}='times';
gp.nodes.functions.name{2}='minus';
gp.nodes.functions.name{3}='plus';
gp.nodes.functions.name{4}='rdivide';

if exist('activeTIMES.mat') == 0 
	activeTIMES = 0;
else 
	load activeTIMES;
	delete activeTIMES.mat;
end
if exist('activeMINUS.mat') == 0 
	activeMINUS = 0;
else 
	load activeMINUS;
	delete activeMINUS.mat;
end
if exist('activePLUS.mat') == 0 
	activePLUS = 0;
else 
	load activePLUS;
	delete activePLUS.mat;
end
if exist('activeDIVIDE.mat') == 0 
	activeDIVIDE = 0;
else 
	load activeDIVIDE;
	delete activeDIVIDE.mat;
end

% default function sets
if (activeDIVIDE == 0)
    activeDIVIDE = 1;
end
if(activeTIMES == 0)
    activeTIMES = 1;
end
% end default function sets block

gp.nodes.functions.active(1)=activeTIMES;                          
gp.nodes.functions.active(2)=activeMINUS;                          
gp.nodes.functions.active(3)=activePLUS;                          
gp.nodes.functions.active(4)=activeDIVIDE;

