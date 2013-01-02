function [gp]=popbuild(gp)
%POPBUILD Constructs the next population of (possibly multigene)
%individuals based on fitness values.
%
%   [GP]=POPBUILD(GP) uses the current population (stored in GP.POP) and
%   their fitnesses (stored in GP.FITNESS.VALUES) to create the next
%   generation of individuals.
%
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: INITBUILD


% Initialise new population
new_pop=cell(gp.runcontrol.pop_size,1);


num2build=floor((1-gp.selection.elite_fraction)*gp.runcontrol.pop_size);   %the number of new members to be constructed after elitism is accounted for
num2skim=gp.runcontrol.pop_size-num2build;
p_mutate=gp.operators.mutation.p_mutate;
p_direct=gp.operators.directrepro.p_direct;
max_depth=gp.treedef.max_depth;
max_nodes=gp.treedef.max_nodes;
p_cross_hi=gp.genes.operators.p_cross_hi;
use_multi=gp.genes.multigene;

pmd=p_mutate+p_direct;


%update gen counter
gp.state.count=gp.state.count+1;

ii=0;

%Loop until the required number of new individuals has been built.
while ii<num2build;

    ii=ii+1;

    %probabilistically select a genetic operator
    p_gen=rand;

    if p_gen < p_mutate, % select mutation

        op_type=1;

    elseif p_gen<(pmd)   %direct reproduction

        op_type=2;

    else  %crossover

        op_type=3;

    end


    %Gene mutation (First select a individual, then a gene, then do ordinary mutate)
    if op_type==1

        mem_index=selection(gp);  %pick the population index of a parent individual using selection operator
        parent=gp.pop{mem_index};

        if use_multi %if using multigene, extract a target gene
            parent_gene_num=size(parent,2);
            target_gene_num=ceil(rand*parent_gene_num); %randomly select a gene from parent
            target_gene=parent{1,target_gene_num}; %extract it
        else
            target_gene_num=1;
            target_gene=parent{1};
        end


        mutate_success=false;
        for loop=1:5	%loop until a successful mutation occurs  (max loops=5)

            mutated_gene = mutate(target_gene,gp);
            newstr_depth=getdepth(mutated_gene);

            if newstr_depth<=max_depth
                newstr_nodes=getnumnodes(mutated_gene);
                if newstr_nodes<=max_nodes
                    %if constraints not exceeded
                    %then ok to accept
                    mutate_success=true;
                    try 
                        
                        parent{1,target_gene_num}=mutated_gene;
                        evalstr=tree2evalstr(parent,gp);
                        
                        feval(gp.fitness.fitfun,evalstr,gp);
                    catch
                        disp('ciao')
                        mutate_success=false;
                    end
                    
                    break;
                end
            end %end of  constraint check
        end  %end of mutate for loop


        %If no success then use parent gene
        if ~mutate_success
            mutated_gene=target_gene;
        end


        %add the mutated individual to new pop
        %parent{1,target_gene_num}=mutated_gene;
        new_pop{ii,1}=parent;



        %direct repro operator-reproduces individual (all genes);
    elseif op_type==2

        mem_index=selection(gp);  %pick a parent
        parent=gp.pop{mem_index};

        %copy to new population
        new_pop{ii}=parent;

        % Xover operator -can either pick High Level Xover
        %(crosses over entire genes-no tree alteration) or Low Level
        % (crosses over individual genes at the tree level)
    elseif op_type==3

        use_high=0;

        if use_multi
            %Probabilistically select Xover type if multigene enabled
            r=rand;

            if r < p_cross_hi, % select high level crossover
                use_high=1;
            end

        end


        %Select Parents
        mem_index=selection(gp);  %pick a parent
        dad=gp.pop{mem_index};
        dad_gene_num=numel(dad);

        mem_index=selection(gp);  %pick a parent
        mum = gp.pop{mem_index};
        mum_gene_num=numel(mum);

        if use_high
            if (mum_gene_num>1 || dad_gene_num>1)
                % High level Crossover (only use if either parent has more than one gene)
                % -picks two crossover points in each parent and swaps the enclosed genes
                % -doesn't allow certain illegal crossovers, e.g. those that result in a no gene individual etc.
                % -if resulting individual(s) have more than the max allowed genes then the extra ones are randomly chopped out

                %Pick crossover points
                dad_num_points=dad_gene_num+1;
                mum_num_points=mum_gene_num+1;

                dad_xover1=ceil(rand*dad_gene_num); %pick left hand xover point (disallow extreme righthand point)
                mum_xover1=ceil(rand*mum_gene_num);

                dad_xover2=ceil(rand*(dad_num_points-dad_xover1))+dad_xover1; %pick right hand xover point
                mum_xover2=ceil(rand*(mum_num_points-mum_xover1))+mum_xover1;

                %Extract gene sequences
                mum_xchange=mum(mum_xover1:(mum_xover2-1));
                dad_xchange=dad(dad_xover1:(dad_xover2-1));

                %Construct offspring
                if mum_xover1==1
                    mum_off_lhs=[];
                else
                    mum_off_lhs=mum(1:mum_xover1-1);
                end

                if dad_xover1==1
                    dad_off_lhs=[];
                else
                    dad_off_lhs=dad(1:dad_xover1-1);
                end

                mum_off=[mum_off_lhs dad_xchange mum(mum_xover2:end)];
                dad_off=[dad_off_lhs mum_xchange dad(dad_xover2:end)];

                %Curtail offspring longer than the max allowed number of genes
                % before writing to new population (only write 1 if no space for 2 offspring)
                new_pop{ii,1}=mum_off(1:(min(end,gp.genes.max_genes)));
                ii=ii+1;

                if ii<=num2build
                    new_pop{ii,1}=dad_off(1:(min(end,gp.genes.max_genes)));
                end

            else
                use_high=0;
            end
        end %end of high level crossover section


        % Low level crossover: picks a random gene from each parent and crosses them
        % The offspring replace the original target genes
        if ~use_high

            if use_multi %if multigene then select target genes
                dad_target_gene_num=ceil(rand*dad_gene_num); %randomly select a gene from dad
                mum_target_gene_num=ceil(rand*mum_gene_num); %randomly select a gene from mum
                dad_target_gene=dad{1,dad_target_gene_num};
                mum_target_gene=mum{1,mum_target_gene_num};
            else
                dad_target_gene_num=1;
                mum_target_gene_num=1;
                dad_target_gene=dad{1};
                mum_target_gene=mum{1};
            end



            for loop=1:5  %Loop (max 5 times) until both children meet size constraints

                %produce 2 offspring
                [son,daughter]=crossover(mum_target_gene,dad_target_gene,gp);
                son_depth=getdepth(son);

                % Staggered If statements
                % to see if both children meet size and depth constraints
                % if true then break out of while loop and proceed
                cross_success=false;
                if son_depth<=max_depth
                    daughter_depth=getdepth(daughter);
                    if daughter_depth<=max_depth
                        son_nodes=getnumnodes(son);
                        if son_nodes<=max_nodes
                            daughter_nodes=getnumnodes(daughter);
                            if  daughter_nodes<=max_nodes
                                 cross_success=true;
                                 try
                                  evalstr=tree2evalstr(son,gp);
                                  feval(gp.fitness.fitfun,evalstr,gp);
                                 catch
                                 cross_success=false;
                                 end
                                break;
                            end;
                        end
                    end
                end

            end


            %If no success then re-insert parents
           if ~cross_success
                son=dad_target_gene;
                daughter=mum_target_gene;
            end

            %write offspring back to right gene positions in parents and write to population
            dad{1,dad_target_gene_num}=son;
            new_pop{ii}=dad;

            ii=ii+1;


            if ii<=num2build
                mum{1,mum_target_gene_num}=daughter;
                new_pop{ii}=mum;
            end


        end %end of if ~use_high


    end % end of op_type if


end %end of ii-->num2build  for



% Next, skim off the existing elite individuals and stick them on the end
% of the new matrix.
% When sorting there may be many individuals with the same fitness.
% However, some of these have fewer nodes than others, so skim off the first
% one as the existing member with the fewest nodes.
% This should exert a degree of parsimony pressure.


%get indices of best num2skim individuals
[vals,sort_index]=sort(gp.fitness.values);

%if maximising need to flip vectors
if ~gp.fitness.minimisation
    sort_index=flipud(sort_index);
end


for g=1:1:num2skim

    pop_index=sort_index(g);

    %for the first individual to skim off, pick the 'best' member with the lowest number
    %of nodes
    if g==1
        b_inds=find(gp.fitness.values==gp.fitness.values(pop_index));
        [n,node_sort_index]=sort(gp.fitness.numnodes(b_inds));
        node_sort_index=b_inds(node_sort_index(1)); %if more than one with same num nodes , just pick the first
        skim=gp.pop{node_sort_index,1};
    else
        skim=gp.pop{pop_index,1};
    end

    new_pop{num2build+g,1}=skim;

end

% replace old population with new in gp structure
gp.pop=new_pop;

