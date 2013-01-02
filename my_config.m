function gp=my_config(gp);
%Example of a GPTIPS configuration file for multiple gene
%symbolic regression. 
%
%   Note that the mydata MAT file does not exist
%   and must be provided by the user!
%
%   v1.0

%Define population size, number of generations, fitness function name and
%optimisation type.
gp.runcontrol.pop_size=100;                     
gp.runcontrol.num_gen=100;				                                                       
gp.fitness.fitfun=@regressmulti_fitfun;               
gp.fitness.minimisation=true; 

%Load the variables xtrain, ytrain, xtest and ytest and assign to gp structure
load mydata
gp.userdata.xtrain=xtrain;
gp.userdata.ytrain=ytrain;
gp.userdata.xtest=xtest;
gp.userdata.ytest=ytest;


%Define the number of inputs
gp.nodes.inputs.num_inp=size(gp.userdata.xtrain,2);

%Enable multiple gene mode and set max number of genes per individual.
gp.genes.multigene=true;              
gp.genes.max_genes=4;
gp.genes.max_depth=5;

%Define function nodes
gp.nodes.functions.name={'times','minus','plus'};