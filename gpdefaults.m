function gp=gpdefaults()
%GPDEFAULTS GPTIPS function to initialise the GP structure by creating 
%default parameter values.
%
%   GP=GPDEFAULTS() generates default structure GP for GPTIPS.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also GPCHECK

gp.runcontrol.about='Main run control parameters';
gp.runcontrol.pop_size=100;				        
gp.runcontrol.num_gen=100;				                                                                        
gp.runcontrol.verbose=10;    % The generation frequency with which results are printed to CLI                 
gp.runcontrol.savefreq=50;                     
gp.runcontrol=orderfields(gp.runcontrol);
gp.runcontrol.quiet=false; %if true, then GPTIPS runs with no CLI output


gp.selection.about='Selection method parameters';
gp.selection.method='tour';            
gp.selection.tournament.size=2;         
gp.selection.tournament.lex_pressure=false; % Set to true to use Sean Luke's lexographic selection pressure during tournament selection
gp.selection.elite_fraction=0.05;      
gp.selection=orderfields(gp.selection);

          
gp.fitness.minimisation=true;                % Set to true if you want to minimise the fitness function (if zero it is maximised).
gp.fitness.fitfun='A handle to your fitness function should go here';
gp.fitness.about='Fitness/objective function configuration'; 
gp.fitness.terminate=false;
gp.fitness.terminate_value=0;
gp.fitness=orderfields(gp.fitness);

gp.userdata=[];
gp.userdata.datasampling=false;
gp.userdata.scale=false;
gp.userdata.user_fcn=[];


gp.treedef.about='Tree building parameters and constraints';              
gp.treedef.max_depth=6;
gp.treedef.max_mutate_depth=6;


gp.treedef.build_method=3;   %ramped half and half              
gp.treedef.max_nodes=Inf;  	              
gp.treedef=orderfields(gp.treedef);

gp.operators.about='Genetic operator configuration';
%gp.operators.mutation.p_mutate=0.1;    
%gp.operators.crossover.p_cross=0.85;
load -mat mutate;
load -mat cross;
gp.operators.mutation.p_mutate=double(mutate);    
gp.operators.crossover.p_cross=double(cross);
delete mutate.mat;
delete cross.mat;
gp.operators.directrepro.p_direct=0.05; 
gp.operators.mutation.mutate_par=[0.9 0.05 0.05 0 0 0];
gp.operators.mutation.gaussian.std_dev=0.1;  % if mutate_type 3 (constant perturbation) is used this is the standard deviation of the Gaussian used.
gp.operators.mutation=orderfields(gp.operators.mutation);

gp.operators=orderfields(gp.operators);

gp.nodes.about='Node configuration parameters';

gp.nodes.functions.about='Function node configuration';
gp.nodes.functions.name={'A cell array containing the names of your function nodes should go here'};            
gp.nodes.functions.arity=[];
gp.nodes.functions.active=[];
gp.nodes.functions=orderfields(gp.nodes.functions);

gp.nodes.const.about='Ephemeral random constant configuration';
gp.nodes.const.use_matlab_format=false;     
gp.nodes.const.num_dec_places=6;  
gp.nodes.const.range=[-10 10];             
gp.nodes.const.p_ERC=0.2;		               
gp.nodes.const=orderfields(gp.nodes.const);

gp.nodes.inputs.num_inp=[]; 
gp.nodes=orderfields(gp.nodes);

gp.genes.about='Multigene configuration';
gp.genes.multigene=false;                                                                   
gp.genes.max_genes=1;                                      
gp.genes.operators.p_cross_hi=0.2;                        
gp.genes=orderfields(gp.genes);

gp=orderfields(gp);
