function [array_out]=tree2evalstr(array_in,gp)
%TREE2EVALSTR GPTIPS function to process evolvable expressions into 
%expressions that Matlab can evaluate directly.
%
%   [ARRAY_OUT]=TREE2EVALSTR(ARRAY_IN,GP) processes the encoded symbolic 
%   expressions in the cell array ARRAY_IN and creates a cell array
%   ARRAY_OUT, each element of which is an evaluable Matlab expression.
%
%   Remarks:
%   GPTIPS uses a encoded string representation of expressions which is
%   not very human readable but is fairly compact and makes events like
%   crossover and mutation easier to handle. An example of such an 
%   expression is a(b(x1,a(x4,x3)),c(x2,x1)). However, before an expression
%   is evaluated it is converted using TREE2EVALSTR to produce an evaluable
%   expression, e.g. times(minus(x1,times(x4,x3)),plus(x2,x1)).
%
%  
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also EVALFITNESS

len=numel(array_in);
array_out=cell(1,len);
num_fun=gp.nodes.functions.num_active;


%loop through active function list
% and replace with function names
for i=1:len
    temp_str=array_in{i};

    for j=1:num_fun
        temp_str=strrep(temp_str,gp.nodes.functions.afid(j),gp.nodes.functions.active_name_UC{j});
    end

    array_out{i}=lower(temp_str);

end




