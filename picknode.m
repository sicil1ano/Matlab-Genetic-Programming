function [position]=picknode(expr,node_type,gp)
%PICKNODE Randomly select a node of specified type from a GPTIPS encoded
%prefix expression and return its position in the expression.
%
%    [POSITION]=PICKNODE(EXPR,NODE_TYPE,GP) returns the POSITION where
%    EXPR is the symbolic expression, NODE_TYPE is the specified node type
%    and GP is the GPTIPS data structure.
%
%    Remarks:
%    For NODE_TYPEs 1 to 4 this function returns the string POSITION of the
%    node or -1 if no appropriate node can be found. If NODE_TYPE is 5 or 6
%    then POSITION is a vector of sorted node indices.
%
%    Set NODE_TYPE argument as follows:
%    0 = any node
%    3 = constant (ERC) selection only
%    4 = input selection only
%    5 = indices of nodes with a builtin MATLAB infix representation,
%    sorted left to right
%    6 = indices of all nodes, sorted left to right
%
%    (c) Dominic Searson 2009
%
%    v1.0
%
%    See also EXTRACT


%mask some symbols that would screw stuff up
if gp.nodes.const.use_matlab_format
    expr=strrep(expr,'e+','##');    %standard form
    expr=strrep(expr,'e-','##');     %standard form
end

x=strrep(expr,'[-','[#');    %negative constants

ind=[];
temp_ind=[];



if node_type==0 || node_type==6 %pick any node

    %get indices of function and input locations
    temp_ind=find(double(x)<=122 & double(x)>=97);


    %add indices of constant locations
    ind=[temp_ind findstr(x,'[')];

    if node_type==6
        position=sort(ind);
        return
    end


elseif node_type==3  %just constants

    ind=findstr(x,'[');


elseif node_type==4 %just inputs
    ind=findstr(x,'x');


elseif node_type==5 %special option, only selects plus, minus, times,rdivide,power (intended for offline use)

    idcount=0;
    for i=1:length(gp.nodes.functions.name)

        if gp.nodes.functions.active(i)
            idcount=idcount+1;
            func=gp.nodes.functions.name{i};

            if strcmpi(func,'times') || strcmpi(func,'plus') || strcmpi(func,'minus') || strcmpi(func,'rdivide') || strcmpi(func,'power')
                id=gp.nodes.functions.afid(idcount);
                %look for id in string and concatenate to indices vector
                ind=[ind findstr(x,id)];
            end

        end
    end
    position=sort(ind);
    return
end


%count legal nodes
num_nodes=length(ind);

%if none legal, return -1
if ~num_nodes
    position=-1;

else
    %select a random node from those indexed
    fun_choice=ceil(rand*num_nodes);
    position=ind(fun_choice);
end


