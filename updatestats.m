function gp=updatestats(gp)
%UPDATESTATS GPTIPS function to update run statistics such as best fitness, 
%number of nodes etc.
%
%   [GP]=UPDATESTATS(GP) updates the stats of the GP structure.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also DISPLAYSTATS

% First, check for NaN fitness values
nan_ind=isnan(gp.fitness.values);

% write best fitness of current generation to gp struct
if gp.fitness.minimisation

    gp.fitness.values(nan_ind)=Inf;
    best_fitness=min(gp.fitness.values);

else %maximisation of fitness function

    % replace Inf and NaN with -Inf
    inf_ind=isinf(gp.fitness.values);
    gp.fitness.values(inf_ind)=-Inf;
    gp.fitness.values(nan_ind)=-Inf;
    best_fitness=max(gp.fitness.values);


end


% There may be more than one individual with best fitness.
% If so designate as "best" the one with the fewest nodes.
% If there is more than one with the same number of nodes
% then just pick the first one (effectively a random selection).
% This doesn't affect the GP run, it
% only affects the reporting of which individual is currently
% considered "best".
best_inds=find(gp.fitness.values==best_fitness);
nodes=gp.fitness.numnodes(best_inds);
[lnodes,ind]=min(nodes);
best_ind=best_inds(ind);



%store best of current population
gp.state.best.fitness=best_fitness;
gp.state.best.individual=gp.pop{best_ind};
gp.state.best.returnvalues=gp.fitness.returnvalues{best_ind};
gp.state.best.numnodes=gp.fitness.numnodes(best_ind);
gp.results.history.bestfitness(gp.state.count,1)=best_fitness;
gp.state.best.index=best_ind;

%calc. mean and std. dev. fitness (exc. inf values)
notinf_ind=find(~isinf(gp.fitness.values));
gp.state.meanfitness=mean(gp.fitness.values(notinf_ind));
gp.state.std_devfitness=std(gp.fitness.values(notinf_ind));
gp.results.history.meanfitness(gp.state.count,1)=gp.state.meanfitness;
gp.results.history.std_devfitness(gp.state.count,1)=gp.state.std_devfitness;



%update best of run so far if using a static fitness function
if gp.state.count==1 %if first gen then "best of run" is best of current gen

    gp.results.best.fitness=gp.state.best.fitness;
    gp.results.best.individual=gp.state.best.individual;
    gp.results.best.returnvalues=gp.state.best.returnvalues;
    gp.results.best.numnodes=gp.state.best.numnodes;
    gp.results.best.foundatgen=0;
    gp.results.best.eval_individual=tree2evalstr(gp.state.best.individual,gp);
   

    % Update run "best" fitness if current gen best fitness is better (or
    % the same but with less nodes) 
else

    update=false;
    if gp.fitness.minimisation %if minimising fitness function
        
        if gp.state.best.fitness<gp.results.best.fitness ...
                || (gp.state.best.numnodes<gp.results.best.numnodes && gp.state.best.fitness==gp.results.best.fitness)...
            update=true;
        end

    else %if maximising fitness function

        if gp.state.best.fitness>gp.results.best.fitness ...
                || (gp.state.best.numnodes<gp.results.best.numnodes && gp.state.best.fitness==gp.results.best.fitness)...
                
            update=true;
        end



    end

    if update
        gp.results.best.fitness=gp.state.best.fitness;
        gp.results.best.individual=gp.state.best.individual;
        gp.results.best.returnvalues=gp.state.best.returnvalues;
        gp.results.best.numnodes=gp.state.best.numnodes;
        gp.results.best.foundatgen=gp.state.count-1;
        gp.results.best.eval_individual=tree2evalstr(gp.state.best.individual,gp);
       
    end

end


gp.results.history.runningbestfitness(gp.state.count,1)=gp.results.best.fitness;

%check if termination criterion met
if gp.fitness.terminate

    if gp.fitness.minimisation
        if gp.results.best.fitness<=gp.fitness.terminate_value
            gp.state.terminate=true;
        end
    else
        if gp.results.best.fitness>=gp.fitness.terminate_value;
            gp.state.terminate=true;
        end
    end
end

