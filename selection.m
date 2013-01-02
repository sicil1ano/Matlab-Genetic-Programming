function [ind]=selection(gp)
%SELECTION GPTIPS function to probabilistically select an individual from 
%the current population based on fitness. Currently, only tournament selection 
%is implemented.
%   
%   [IND]=SELECTION(GP) returns the index IND in GP.POP of the selected 
%   individual. 
%
%   Remarks:
%   For a tournament of size N:
%
%   1) N individuals are randomly selected from the population with
%   reselection allowed.
%   2) The population index of the best individual in the tournament is
%   returned.
%   3) If one or more individuals have the same fitness then one of these
%   is selected randomly unless GP.SELECTION.TOURNAMENT.LEX_PRESSURE is 
%   set to true. In this case the one with the fewest nodes is selected 
%   (if there is more than one individual with the best fitness and the 
%   same number of nodes then one of these individuals is randomly 
%   selected.)
%
%   (c) Dominic Searson 2009
%
%   1.0
%
%   See also: POPBUILD, INITBUILD
 
    %pick N individuals at random 
    tour_ind=ceil(rand(gp.selection.tournament.size,1)*gp.runcontrol.pop_size);
       
    % Retrieve fitness values of tournament members
    tour_fitness=gp.fitness.values(tour_ind);
    
    %check if max or min problem
    if gp.fitness.minimisation
        bestfitness=min(tour_fitness);
    else
        bestfitness=max(tour_fitness);
    end
    
    
    %locate indices of best individuals in tournament 
    bestfitness_tour_ind=find(tour_fitness==bestfitness);
    
    
    number_of_best=numel(bestfitness_tour_ind);
    
        
        %Use plain lexicographic parsimony pressure a la Sean Luke
        %and Livui Panait (Lexicographic Parsimony Pressure, GECCO 2002, pp. 829-836).
        %According to them this works best when limiting depth of trees as well.
         if number_of_best>1 && gp.selection.tournament.lex_pressure
            
            %each individual may consist of more than one gene so add up
            %the number of nodes of each gene
            lowest_tnodes=inf;
            for i=1:number_of_best
                
               tnodes=0;
               for j=1:numel(gp.pop{tour_ind(bestfitness_tour_ind(i))})
                   tnodes=tnodes+getnumnodes(gp.pop{tour_ind(bestfitness_tour_ind(i))}{j});
               end
                
               if tnodes<lowest_tnodes
                 smallest_indiv_ind=bestfitness_tour_ind(i);  
                 lowest_tnodes=tnodes;
               end
                   
            end
            bestfitness_tour_ind=smallest_indiv_ind;
            
        else    %otherwise randomly pick one
        bestfitness_tour_ind=bestfitness_tour_ind(ceil(rand*number_of_best));
        end
    
    
 ind=tour_ind(bestfitness_tour_ind);
    

