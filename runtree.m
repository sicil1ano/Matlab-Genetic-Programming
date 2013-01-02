function [fitness]=runtree(gp,ind,knockout)
%RUNTREE GPTIPS function to run the fitness function on an individual
%in the current population.
%
%   RUNTREE(GP,IND) runs the fitness function using a user selected
%   individual with population index IND from the current population.
%
%   RUNTREE(GP,'BEST') runs the fitness function using the 'best'
%   individual in the current population.
%
%   RUNTREE(GP,'VALBEST') runs the fitness function using the best
%   individual on the validation data set (if it exists - for symbolic
%   regression problems that use the fitness function REGRESSMULTI_FITFUN).
%
%   [FITNESS]=RUNTREE(GP,IND) also returns the FITNESS value as returned by
%   the fitness function.
%
%   Additional functionality:
%   RUNTREE can also  accept an optional third argument KNOCKOUT which
%   should be a boolean vector the with same number of entries as genes in
%   the individual to be run. This evaluates the individual with the
%   indicated genes removed ('knocked out').
%   E.g. RUNTREE(GP,'BEST',[1 0 0 1]) knocks out the 1st and 4th genes from
%   the best individual of run. In the case of multigene symbolic
%   regression (i.e. if the fitness function is REGRESSMULTI_FITFUN) the
%   weights for the remaining genes are recomputed by least squares
%   regression on the training data.
%
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: SUMMARY, POPBROWSER

if nargin<2
    disp('Usage is RUNTREE(GP,IND) where IND is the population index of the selected individual.');
    disp('or RUNTREE(GP,''best'') to run the best individual in the population.');
    return;
elseif nargin<3
    doknockout=false;
else
    doknockout=true;
end

i=ind;

if isnumeric(ind)


    if ~isempty(i) && isnumeric(i) && ~mod(i,1) && i>0 && i<=gp.runcontrol.pop_size

        gp.state.current_individual=i; %need to set this in case the fitness function needs to retrieve the right returnvalues
        treestrs=tree2evalstr(gp.pop{i},gp);

        %if genes are being knocked out then remove appropriate gene
        if doknockout
            treestrs=kogene(treestrs, knockout);
            gp.state.run_completed=false; %need to recompute gene weights if doing symbolic regression
            gp.userdata.showgraphs=true; %if using symbolic regression, plot graphs
        end

        fitness=feval(gp.fitness.fitfun,treestrs,gp);


    else
        error('A valid population member index must be entered');
    end

elseif ischar(ind) && strcmpi(ind,'best')


    %copy "best" return values to a slot in the "current" return values
    %(this is to fool the fitness function into thinking it is evaluating
    %a member of the current population, rather than the best of run
    %individual)
    gp.fitness.returnvalues{gp.state.current_individual}=gp.results.best.returnvalues;


    %send best to fitness function
    treestrs=gp.results.best.eval_individual;

    %if genes are being knocked out then remove appropriate gene
    if doknockout
        treestrs=kogene(treestrs, knockout);
        gp.state.run_completed=false; %need to recompute gene weights if doing symbolic regression
        gp.userdata.showgraphs=true; %if using symbolic regression, plot graphs
    end
    fitness=feval(gp.fitness.fitfun,treestrs,gp);



elseif ischar(ind) && strcmpi(ind,'valbest')


    % check that validation data is present
    if (~isfield(gp.userdata,'xval')) || (~isfield(gp.userdata,'yval')) || ...
            isempty(gp.userdata.xval) || isempty(gp.userdata.yval)
        error('No validation data was found. Try runtree(gp,''best'') instead.');
    end


    %copy "best" return values to a slot in the "current" return values
    gp.fitness.returnvalues{gp.state.current_individual}=gp.results.valbest.returnvalues;


    %send best to fitness function
    treestrs=gp.results.valbest.eval_individual;

    %if genes are being knocked out then remove appropriate gene
    if doknockout
        treestrs=kogene(treestrs, knockout);
        gp.state.run_completed=false; %need to recompute gene weights if doing symbolic regression
        gp.userdata.showgraphs=true; %if using symbolic regression, plot graphs
    end

    fitness=feval(gp.fitness.fitfun,treestrs,gp);

else
    error('Invalid option.');
end

