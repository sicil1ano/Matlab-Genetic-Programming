function treestrs=kogene(treestrs, knockout)
%KOGENE Utility function to knock out "genes" from a cell array of GP expressions.
%
%   TREESTRS=KOGENE(TREESTRS, KNOCKOUT) removes genes from the cell array
%   TREESTRS with a boolean vector KNOCKOUT which must be the same length
%   as TREESTRS. GENES corresponding to a an entry of 'true' are removed.
%
%
%  (c) Dominic Searson 2009
%
%   v1.0

 if numel(knockout)~=numel(treestrs)
                error('Knockout must be a vector the same length as the number of genes in the supplied individual');
 end
 
 knockout=boolean(knockout);
 
 treestrs(knockout)=[];
 
 if isempty(treestrs)
    error('Cannot perform knockout. There are no genes left in the selected individual.'); 
 end
 