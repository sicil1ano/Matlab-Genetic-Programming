function depth=getdepth(expr)
%GETDEPTH GPTIPS function to returns the tree depth of a GP expression.
%
%   [DEPTH]=GETDEPTH(EXPR) returns the DEPTH of the tree expression EXPR.
%
%   Remarks:
%   A single node is considered to be a tree of depth 1.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also GETNUMNODES


% workaround for arity zero functions, which are represented by f()
% string replace '()' with the empty string
expr=strrep(expr,'()','');
open_br=findstr(expr,'(');
close_br=findstr(expr,')');
num_open=numel(open_br);


if ~num_open  %i.e. a single node
    depth=1;
    return
elseif num_open==1
    depth=2;
    return
else
    
    %depth = max consecutive number of open brackets+1    
    br_vec=zeros(1,length(expr));
    br_vec(open_br)=1;
    br_vec(close_br)=-1;
    
    depth=max(cumsum(br_vec))+1;
    
end


