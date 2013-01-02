function [main_tree,sub_tree]=extract(i,x)
%EXTRACT GPTIPS function to extract a subtree from a symbolic expression.
%
%   [MAIN_TREE,SUB_TREE]=EXTRACT(I,X)
%
%   Input args: X (the parent string expression)  
%               I (the index in X of the root node of the subtree to be extracted)
%         
%   Output args: MAIN_TREE (X with the removed subtree replaced by the symbol '$')
%                 SUB_TREE  (the extracted subtree)
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: PICKNODE, GETDEPTH


cnode=x(i);
iplus=i+1;
iminus=i-1;
endpos=numel(x);

if cnode=='x'  % Check if we are extracting an input terminal (x1, x2 etc.)
    
    % look right across remainder of string to find either a ')' or a ',' 
    % which signifies the end of the terminal
    inp_brack_ind=findstr(x(iplus:endpos),',');
    inp_comma_ind=findstr(x(iplus:endpos),')');
    
    %if none found then string must consist of single input
    if isempty(inp_brack_ind) && isempty(inp_comma_ind)
        main_tree='$';
        sub_tree=x;
    else
        
        inp_ind=sort([inp_brack_ind inp_comma_ind]);
        final_ind=inp_ind(1)+i;
        sub_tree=x(i:final_ind-1);
        main_tree=[x(1:iminus) '$' x(final_ind:endpos)];
    end
    
    return
    
elseif cnode=='[' %or a constant...
    %look right across the remainder of the string for first closing square
    %bracket
    
    cl_sbr=findstr(x(iplus:endpos),']');
    final_ind=cl_sbr(1)+i;
    sub_tree=x(i:final_ind);
    main_tree=[x(1:iminus) '$' x(final_ind+1:endpos)];
    
    return
    
elseif cnode=='?' % or a constant token....
    sub_tree=cnode;
    main_tree=x;
    main_tree(i)='$';
    return
    
else %otherwise extract a tree with a function node as root 
    
    % Vectorised version 
    % Subtree defined when number open brackets=number of closed brackets
    
    search_seg=x(i:endpos);
    
    %get indices of open brackets
    op=findstr(search_seg,'(');
    cl=findstr(search_seg,')');
    
    %compare indices to determine point where num_open=num_closed
    tr_op=op(2:end);
    l_tr_op=length(tr_op);
    
    hibvec=tr_op-cl(1:l_tr_op);
    
    cl_ind=find(hibvec>0);
    
    if isempty(cl_ind)
        j=cl(length(op));
    else
        
        cl_ind=cl_ind(1);
        j=cl(cl_ind);
    end
    
    
    sub_tree=search_seg(1:j);
    
    
    main_tree=[x(1:iminus) '$'  x(j+i:endpos)];
    return
end
