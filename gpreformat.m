function [out]=gpreformat(GP,expr)
%GPREFORMAT Utility function to reformat GPTIPS encoded prefix expression(s) 
%for slightly better readability.
%
%   [OUT]=GPREFORMAT(GP,EXPR) reformats EXPR which must be a prefix
%   expression or a linear cell array of such expressions.
%
%   (c) Dominic Searson 2009
% 
%   v1.0
%
%   Remarks:
%   Genes are accessed as elements of the cell arrays that comprise the
%   population. The jth gene of the ith individual is accessed as 
%   GP.POP{i}{j}. 
%  
%   Example:
%   To reformat the 1st gene of population member 12 use
%   gpreformat(gp,gp.pop{12}{1})
%   
%   See also: GPPRETTY

if nargin<2
    disp('Usage is GPREFORMAT(GP,EXPR) where EXPR is a GP expression or a cell array of such expresssions');
    return;
end

if ~iscell(expr)
    array_in={expr};
else
    array_in=expr;
end



len=length(array_in);
out=cell(1,len);


for j=1:len

    temp_str=array_in{j};

    %Convert some prefix nodes to infix format
    temp_str=pref2inf(temp_str,GP);

    %locate function identifiers of infix nodes and replace with +,- etc
    idcount=0;
    for i=1:length(GP.nodes.functions.name)
        
        if GP.nodes.functions.active(i)
            func=GP.nodes.functions.name{i};
            idcount=idcount+1;
            if idcount>numel(GP.nodes.functions.afid);
                break
            end
            id=GP.nodes.functions.afid(idcount);

            if strcmpi(func,'times')
                temp_str=strrep(temp_str,id,'*');
            elseif strcmpi(func,'minus')
                temp_str=strrep(temp_str,id,'-');
            elseif strcmpi(func,'plus')
                temp_str=strrep(temp_str,id,'+');
            elseif strcmpi(func,'rdivide')
                temp_str=strrep(temp_str,id,'/');
            end

        end
    end

    %replace remaining function identifiers with function names
    [temp_str]=tree2evalstr({temp_str},GP);
    temp_str=temp_str{1};

    %replace square brackets
    temp_str=strrep(temp_str,'[','(');
    temp_str=strrep(temp_str,']',')');
    out{j}=temp_str;

end


if ~iscell(expr)
    out=out{1};
end
