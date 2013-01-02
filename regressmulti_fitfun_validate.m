function [fitness,gp,ypredval]=regressmulti_fitfun_validate(gp)
%REGRESSMULTI_FITFUN_VALIDATE For use with multigene non-linear symbolic
%regression. Evaluates current 'best' individual on user supplied 
%validation data set and stores the results.
%
%   
%   [FITNESS,GP,YPREDVAL]=REGRESSMULTI_FITFUN_VALIDATE(GP) returns the 
%   FITNESS of the the current 'best' multiple gene individual contained in
%   the GP data structure. FITNESS is the root mean squared prediction 
%   error on the validation ('holdout') data set.
%   
%   Remarks on the use of validation ('holdout') data:
%   This function is called at the end of each generation by
%   adding the following line to the user's run configuration file:
%   GP.USERDATA.USER_FCN=@REGRESSMULTI_FITFUN_VALIDATE
%
%   In addition, the user's GPTIPS configuration file should populate the 
%   following required fields for the training data assuming 'Nval' 
%   observations on the input and output data:
%   GP.USERDATA.XVAL should be a (Nval x n) matrix where the ith column
%   contains the Nval observations of the ith input variable xi.
%   GP.USERDATA.YVAL should be a (Nval x 1) vector containing the
%   corresponding observations of the response variable y.
%   
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also REGRESSMULTI_FITFUN, GP_USERFCN

% on first call, check that validation data is present
if (gp.state.count==1) && (~isfield(gp.userdata,'xval')) || (~isfield(gp.userdata,'yval')) || ...
   isempty(gp.userdata.xval) || isempty(gp.userdata.yval)
   error('Cannot perform holdout validation because no validation data was found.'); 
end


%get evalstr for current 'best' individual on training data
evalstr=gp.results.best.eval_individual;


% process evalstr with regex to allow direct access to data 
pat='x(\d+)';

%assign inputs and output
if gp.userdata.scale
y=gp.userdata.yvalS;
evalstr=regexprep(evalstr,pat,'gp.userdata.xvalS(:,$1)');
else
evalstr=regexprep(evalstr,pat,'gp.userdata.xval(:,$1)');
y=gp.userdata.yval;
end
num_data_points=size(y,1);
num_genes=length(evalstr);


%set up a matrix to store the tree outputs plus a bias column of ones
gene_outputs=ones(num_data_points,num_genes+1);



%eval each gene in the current individual
for i=1:num_genes
    ind=i+1;
    eval(['gene_outputs(:,ind)=' evalstr{i} ';']);

    %check for nonsensical answers and break out early with an 'inf' if so
    if  any(isnan(gene_outputs(:,ind))) || any(isinf(gene_outputs(:,ind)))
        fitness=Inf;
        return
    end

end


%retrieve regression weights
theta=gp.results.best.returnvalues;


%calc. prediction of validation data set using the retreived weights
ypredval=gene_outputs*theta;

%calculate RMS prediction error
fitness=sqrt(mean((y-ypredval).^2));

%Initialise validation set info in the GP structure
if gp.state.count==1
 gp.results.history.valfitness(1:gp.runcontrol.num_gen,1)=0; 
 gp.results.history.valfitness(1)=fitness;
 gp.results.valbest=gp.results.best;
 gp.results.valbest.valfitness=fitness;
 gp.results.best.valfitness=fitness;
end

gp.results.best.valfitness=fitness;
gp.results.history.valfitness(gp.state.count,1)=fitness;

%update 'best' validation if fitness is better or its the same with less
%nodes
if fitness<gp.results.valbest.valfitness || ... 
    (fitness==gp.results.valbest.valfitness && gp.results.best.numnodes<gp.results.valbest.numnodes)
gp.results.valbest=gp.results.best;
gp.results.valbest.valfitness=fitness;
end
