function [gp]=evalfitness(gp)
%EVALFITNESS GPTIPS function to call the user specified fitness function.
%
%    [GP]=EVALFITNESS(GP) evaluates the the fitnesses of individuals stored 
%    in the GP structure and updates various other fields of GP accordingly.
%
%    (c) Dominic Searson 2009
%
%    v1.0
%
%    See also TREE2EVALSTR

% Loop through population and calculate fitnesses

for i=1:gp.runcontrol.pop_size

    % update state to reflect the index of the individual that is about to
    % be evaluated
    gp.state.current_individual=i;

   
    %First preprocess the cell array of string expressions into a form that
    %Matlab can evaluate
    evalstr=tree2evalstr(gp.pop{i},gp);

    %store number of nodes (sum total for all genes)
    gp.fitness.numnodes(i,1)=getnumnodes(gp.pop{i});



    % Evaluate gp individual using fitness function
    % (the try catch is to assign a poor fitness value
    % to trees that violate Matlab's
    % daft 'Nesting of {, [, and ( cannot exceed a depth of 32.' error.
    try
        
        [fitness,gp]=feval(gp.fitness.fitfun,evalstr,gp);
        gp.fitness.values(i)=fitness;
    catch
        if ~strncmpi(lasterr,'Nesting of {',12);
            error(lasterr);
        end
        if gp.fitness.minimisation
            gp.fitness.values(i)=Inf;
        else
            gp.fitness.values(i)=-Inf;
        end
    end
    

end



