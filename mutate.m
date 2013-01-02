function [xmut]=mutate(x,gp)
%MUTATE GPTIPS function to mutate a symbolic expression. 
%
%   [XMUT]=MUTATE(X,GP) mutates the symbolic expression X using the 
%   parameters in GP to produce expression XMUT.   
%
%   Remarks:
%   This function uses the GP.OPERATORS.MUTATION.MUTATE_PAR field to 
%   determine probabilistically which type of mutation to use. 
%   
%   The types are:
%
%   mutate_type=1 (Default) Ordinary Koza style subtree mutation
%   mutate_type=2 Mutate a non-constant terminal to another non_constant
%   terminal.
%   mutate_type=3 Constant perturbation. Generate small number using 
%   Gaussian and add to existing constant.   
%   mutate_type=4 Zero constant. Sets the selected constant to zero.
%   mutate_type=5 Randomise constant. Substitutes a random new value for 
%   the selected constant.
%   mutate_type=6 Unity constant. Sets the selected constant to 1.   
%      
%   The probabilities of each mutate_type being selected are stored in the 
%   GP.OPERATORS.MUTATION.MUTATE_PAR field which must be a row vector of 
%   length 5.
%   I.e.:
%   GP.OPERATORS.MUTATION.MUTATE_PAR = [p_1 p_2 p_3 p_4 p_5 p_6]
%             
%              where p_1 = probability of mutate_type 1 being used
%                    p_2=     "         "    "        2  "      "
%                    
%              and so on.
%   Example:
%   If GP.OPERATORS.MUTATION.MUTATE_PAR=[0.5 0.25 0.25 0 0] then approx. 
%   1/2 of mutation events will be ordinary subtree mutations, 
%   1/4 will be Gaussian perturbations of a constant and 1/4 will be 
%   setting a constant to zero.
%
%   Note:
%   If a mutation of a certain type cannot be performed (e.g. there are no
%   constants in the tree) then a default subtree mutation is performed
%   instead.
%   
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also CROSSOVER


range=gp.nodes.const.range;      
use_mformat=gp.nodes.const.use_matlab_format; %Set to 1 if using matlab defaults for formatting numeric strings (slower, but may be necessary for some problems)
fi =gp.nodes.const.format;

%Pick a mutation type based on the weights in mutate_par
rnum=rand;



while true %loop until a mutation occurs
    
    % Ordinary subtree mutation
    if rnum<=gp.operators.mutation.cumsum_mutate_par(1)
         
        
        %First get the string position of the node 
        position=picknode(x,0,gp);  
        
        %Remove the logical subtree for the selected node
        % and return the main tree with '$' replacing the extracted subtree
        main_tree=extract(position,x);
        
        %Generate a new tree to replace the old
        % Pick a depth between 1 and gp.treedef.max_mutate_depth;
        depth=ceil(rand*gp.treedef.max_mutate_depth);
        new_tree=treegen(gp,depth);
        
       
        %Replace the '$' with the new tree
        xmut=strrep(main_tree,'$',new_tree);
        
        
        break
        
        
        
         %substitute terminals  
    elseif rnum<=gp.operators.mutation.cumsum_mutate_par(2) 
        
        position=picknode(x,4,gp);
        
        if position==-1
            rnum=0;
            continue;
        else
            main_tree=extract(position,x); %extract the constant
            xmut=strrep(main_tree,'$',['x' sprintf('%d',ceil(rand*gp.nodes.inputs.num_inp))]); %replace it with random terminal
            break
        end
        
        
        
      
     %Constant perturbation  
    elseif rnum<=gp.operators.mutation.cumsum_mutate_par(3)
        
        
        position=picknode(x,3,gp);
        
        if position==-1
            rnum=0;
            continue;
        else
            
            [main_tree,sub_tree]=extract(position,x);
            
            %process constant
            old_const=sscanf(sub_tree(2:end-1),'%f');  
            
            new_const=old_const+(randn*gp.operators.mutation.gaussian.std_dev);  
            
            
            
            %use appropriate string formatting for new constant
            if use_mformat
                new_tree=['[' num2str(new_const) ']'];
            else
                
                if new_const==fix(new_const)
                    new_tree=['[' sprintf('%.0f',new_const) ']'];
                else
                    new_tree=['[' sprintf(fi,new_const) ']'];
                end
            end
            
            
            
            
            
            %Replace the '$' with the new tree
            
            xmut=strrep(main_tree,'$',new_tree);
            
            break
            
        end

        
        
        
        
    %make constant zero
    elseif rnum<=gp.operators.mutation.cumsum_mutate_par(4) 
        
        position=picknode(x,3,gp);
        
        if position==-1
            rnum=0;
            continue;
        else
            main_tree=extract(position,x); %extract the constant
            xmut=strrep(main_tree,'$','[0]'); %replace it with zero
            break
        end
        
    %randomise constant    
    elseif rnum<=gp.operators.mutation.cumsum_mutate_par(5)		
        position=picknode(x,3,gp);
        
        if position==-1
            rnum=0;
            continue;
        else
            main_tree=extract(position,x); %extract the constant
            
            
            %Generate a constant in the range:
            const=rand*(range(2)-range(1))+range(1);
            
            %Convert the constant to square bracketed string form:
            if use_mformat
                arg=['[' num2str(const) ']'];
            else
                
                if const==fix(const)
                    arg=['[' sprintf('%.0f',const) ']'];
                else
                    arg=['[' sprintf(fi,const) ']'];
                end
            end
            
            
            xmut=strrep(main_tree,'$',arg); %insert new constant
            break
        end
        
    %set a constant to 1   
    elseif rnum<=gp.operators.mutation.cumsum_mutate_par(6) 
        
        position=picknode(x,3,gp);
        
        if position==-1
            rnum=0;
            continue;
        else
            main_tree=extract(position,x); %extract the constant
            xmut=strrep(main_tree,'$','[1]'); %replace it with one
            break
        end
     
        
    end 
    
    
end     





