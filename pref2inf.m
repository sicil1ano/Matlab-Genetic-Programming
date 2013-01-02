function [sendup,sendup_status]=pref2inf(expr,gp)
%PREF2INF Utility function to recursively extract arguments from a prefix 
%expression and convert to infix where possible.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: PICKNODE, EXTRACT

%get indices of nodes of any type 
ind=picknode(expr,6,gp);
if isempty(ind)
    sendup=expr;%exits if current expression has no further extractable args
    sendup_status=0;
    return
end

%get first node
ind=ind(1);

%get number of arguments of node
try
    args=gp.nodes.functions.arity_argt0(findstr(gp.nodes.functions.afid,expr(ind)));

    if isempty(args)
        % if has zero arity then exit
        sendup=[expr];
        sendup_status=0;
        return;
    end
catch
    %also exit if error
    sendup=[expr];
    sendup_status=0;
    return;
end

if args==1

    %get subtree rooted in this node
    [main_tree,sub_tree]=extract(ind,expr);
    node=sub_tree(1);

    %get index of 2nd node in 'sub_tree' (i.e. first logical argument)
    keynode_ind=picknode(sub_tree,6,gp); %
    keynode_ind=keynode_ind(2);

    %extract the 1st argument expression
    [remainder,arg1]=extract(keynode_ind,sub_tree);

    [rec1,rec1_status]=pref2inf(arg1,gp);

    if rec1_status==1
        arg1=rec1;
    end

    sendup=[node '(' arg1 ')'];
    sendup_status=1;


elseif args>2
    %get subtree rooted in this node
    [main_tree,sub_tree]=extract(ind,expr);
    node=sub_tree(1);

    %get index of 2nd node in 'sub_tree' (i.e. first logical argument)
    keynode_ind=picknode(sub_tree,6,gp); %
    keynode_ind=keynode_ind(2);

    %extract the 1st argument expression
    [remainder,arg1]=extract(keynode_ind,sub_tree);

    %extract the second argument expression from the remainder
    % find the 1st node after $ in the remainder as this will be the
    % keynode of the 2nd argument we wish to extract
    keynode_ind=picknode(remainder,6,gp);
    token_ind=findstr(remainder,'$');

    hib=find(keynode_ind>token_ind);
    keynode_ind=keynode_ind(hib);
    keynode_ind_1=keynode_ind(1);
    [remainder2,arg2]=extract(keynode_ind_1,remainder);


    %extract the thirdargument expression from the remainder
    % find the 1st node after $ in remainder2 as this will be the keynode of
    % the 3nd argument we wish to extract
    keynode_ind=picknode(remainder2,6,gp);
    token_ind=findstr(remainder2,'$');

    hib=find(keynode_ind>max(token_ind));
    keynode_ind=keynode_ind(hib);
    keynode_ind_1=keynode_ind(1);
    [remainder3,arg3]=extract(keynode_ind_1,remainder2);

    [rec1,rec1_status]=pref2inf(arg1,gp);
    [rec2,rec2_status]=pref2inf(arg2,gp);
    [rec3,rec3_status]=pref2inf(arg3,gp);

    if rec1_status==1
        arg1=rec1;
    end

    if rec2_status==1
        arg2=rec2;
    end

    if rec3_status==1
        arg3=rec3;
    end

    sendup=[node '(' arg1 ',' arg2 ',' arg3 ')'];
    sendup_status=1;

    if args>3

        %extract the fourth argument expression from the remainder
        % find the 1st node after $ in remainder3 as this will be the keynode of
        % the 4nd argument we wish to extract
        keynode_ind=picknode(remainder3,6,gp);
        token_ind=findstr(remainder3,'$');

        hib=find(keynode_ind>max(token_ind));
        keynode_ind=keynode_ind(hib);
        keynode_ind_1=keynode_ind(1);
        [remainder4,arg4]=extract(keynode_ind_1,remainder3);
        [rec4,rec4_status]=pref2inf(arg4,gp);

        if rec4_status==1
            arg4=rec4;
        end

        sendup=[node '(' arg1 ',' arg2 ',' arg3 ',' arg4 ')'];
        sendup_status=1;
    end



else %must have exactly 2 args

    ind=picknode(expr,6,gp);
    %get subtree rooted in this node
    [main_tree,sub_tree]=extract(ind,expr);
    node=sub_tree(1);

    %get index of 2nd node in 'sub_tree' (i.e. first logical argument)
    keynode_ind=picknode(sub_tree,6,gp); %
    keynode_ind=keynode_ind(2);

    %extract the 1st argument expression
    [remainder,arg1]=extract(keynode_ind,sub_tree);

    %extract the second argument expression from the remainder
    % find the 1st node after $ in the remainder as this will be the
    % keynode of the 2nd argument we wish to extract
    keynode_ind=picknode(remainder,6,gp);
    token_ind=findstr(remainder,'$');

    hib=find(keynode_ind>token_ind);
    keynode_ind=keynode_ind(hib);
    keynode_ind_1=keynode_ind(1);
    [remainder2,arg2]=extract(keynode_ind_1,remainder);




    %process arguments of these arguments if any exist
    [rec1,rec1_status]=pref2inf(arg1,gp);
    [rec2,rec2_status]=pref2inf(arg2,gp);


    if rec1_status==1
        arg1=rec1;
    end

    if rec2_status==1
        arg2=rec2;
    end


    %If the node is of infix type (for Matlab symbolic purposes)
    % then send up the results differently
    afid_ind = findstr(node, gp.nodes.functions.afid);
    nodename = gp.nodes.functions.active_name_UC{afid_ind};

    if strcmpi(nodename,'times') || strcmpi(nodename,'minus') || strcmpi(nodename,'plus') || strcmpi(nodename,'rdivide')

        sendup=['(' arg1 ')' node '(' arg2 ')'];
    else
        sendup= [node '(' arg1 ',' arg2 ')'];
    end
    sendup=strrep(main_tree,'$',sendup);

    sendup_status=1; %i.e. ok
end