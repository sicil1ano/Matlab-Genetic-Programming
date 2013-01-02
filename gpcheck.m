function gp=gpcheck(gp)
%GPCHECK GPTIPS function to perform pre-run error checks.
%
%   [GP]=GPCHECK(GP)
%   This function configures additional fields in the GP
%   structure and performs some error checking prior to a run.
%
%   (C) Dominic Searson 2009
%
%   v1.0
%
%   See also GPDEFAULTS, GPINIT

% set log/divide by zero warning states to off for duration of run
% and store current states so that they can be set back after run
gp.info.log0state=warning('query','MATLAB:log:logOfZero');
warning('off','MATLAB:log:logOfZero')
gp.info.div0state=warning('query','MATLAB:divideByZero');
warning('off','MATLAB:divideByZero');

% some error checks (not very comprehensive)
gp.runcontrol.pop_size=ceil(gp.runcontrol.pop_size);
if gp.runcontrol.pop_size<2
    error('Population size must be at least 2. Set gp.runcontrol.pop_size>=2')
end

gp.runcontrol.num_gen=ceil(gp.runcontrol.num_gen);
if gp.runcontrol.num_gen<1
    error('GPTIPS must run for at least one generation. Set gp.runcontrol.num_gen>=1');
end

gp.treedef.max_depth=ceil(gp.treedef.max_depth);
if gp.treedef.max_depth<1
    error('gp.treedef.max_depth must be >=1');
end

gp.treedef.max_mutate_depth=ceil(gp.treedef.max_mutate_depth);
if gp.treedef.max_mutate_depth<1
    error('gp.treedef.max_mutate_depth must be >=1');
end


if gp.treedef.max_mutate_depth > gp.treedef.max_depth
    gp.treedef.max_mutate_depth=gp.treedef.max_depth;
end


if ischar(gp.fitness.fitfun)
    gp.fitness.fitfun=str2func(gp.fitness.fitfun);
end


gp.treedef.max_nodes=ceil(gp.treedef.max_nodes);
if gp.treedef.max_nodes<1
    error('gp.treedef.max_nodes must be >=1');
end


gp.treedef.build_method=ceil(gp.treedef.build_method);
if gp.treedef.build_method<1 || gp.treedef.build_method>3
    error('gp.treedef.build_method must be set as one of the following: 1=full 2=grow 3=ramped half and half.');
end

if gp.selection.elite_fraction<0 || gp.selection.elite_fraction>1
    error('gp.selection.elite_fraction must be in the range 0 -> 1');
end


if sum([gp.operators.mutation.p_mutate gp.operators.crossover.p_cross gp.operators.directrepro.p_direct])~=1
    error('gp crossover, mutation and direct reproduction probabilities must add up to 1');
end


if sum(gp.operators.mutation.mutate_par)~=1
    error('The probabilities in gp.operators.mutation.mutate_par must add up to 1');
end


if gp.fitness.minimisation
    gp.fitness.minimisation=true;
end




if gp.nodes.const.p_ERC<0 || gp.nodes.const.p_ERC>1
    error('gp.treedef.use_ERC must be in the range [0 1]');
end

gp.runcontrol.savefreq=ceil(gp.runcontrol.savefreq);
if gp.runcontrol.savefreq<0
    error('gp.runcontrol.savefreq must be >=0');
end


gp.nodes.inputs.num_inp=ceil(gp.nodes.inputs.num_inp);
if gp.nodes.inputs.num_inp<0
    error('gp.nodes.inputs.num_inp must be >=0');
end

gp.nodes.const.num_dec_places=ceil(gp.nodes.const.num_dec_places);

if gp.nodes.const.num_dec_places<0
    error('gp.nodes.const.num_dec_places must be >=0');
end

if any(size(gp.nodes.const.range)~=[1 2])
    error('gp.nodes.const.range must be a 2 element vector');
end

if gp.nodes.const.range(1)>gp.nodes.const.range(2)
    error('Invalid range set in gp.nodes.const.range');
end


% If no inputs are defined then the probability of using an
% ERCs must be is set to 1 (if it is to be used at all).
if  gp.nodes.inputs.num_inp==0 && gp.nodes.const.p_ERC>0 
    gp.nodes.const.p_ERC=1;
end


%check that function node filenames have been supplied
if ~isfield(gp.nodes.functions,'name') || isempty(gp.nodes.functions.name) || ~iscell(gp.nodes.functions.name)
   error('Filenames for function nodes must be defined as a cell array in gp.nodes.functions.name '); 
end

% loop through function nodes and check each is valid
for i=1:length(gp.nodes.functions.name)

    status=exist(gp.nodes.functions.name{i});
    if (status ~= 2) && (status ~=3 ) && (status ~=5) && (status ~=6)
       error(['The function node "' gp.nodes.functions.name{i} '" cannot be found on the current path. Check your config file.']);
    end
    
end


%generate a function handle to the user defined fitness function
checkfile=exist(func2str(gp.fitness.fitfun),'file');
if ~(checkfile==2) &&  ~(checkfile==3) && ~(checkfile==5) && ~(checkfile==6)
    error('Cannot find user defined fitness function in gp.fitness.fitfun');
end

if ~gp.nodes.const.use_matlab_format
    gp.nodes.const.format=[ '%0.' sprintf('%d',gp.nodes.const.num_dec_places) 'f' ];  %constant format control string
else
    gp.nodes.const.format='Matlab default';
end

if gp.genes.max_genes<1
 error('gp.genes.max_genes must be >0');
end

