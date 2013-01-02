function xhits=scangenes(genes, numx)
%SCANGENES Utility function to scan a single multigene individual for all inputs
%and return a frequency vector.
%
%    XHITS=SCANGENES(GENES, NUMX) scans the cell array GENES for NUMX
%    input variables and returns the frequency vector XHITS.
%
%   See also: GPMODELVARS  
%
%   (c) Dominic Searson 2009
%
%   v1.0

numgenes=length(genes);

xhits=zeros(1,numx);

%loop through inputs
for i=1:numx
    k1=[];
    k2=[];
    istr=int2str(i);

    %loop through genes, look for current input
    for j=1:numgenes
        k1 = strfind(genes{j}, ['x' istr ',']);
        k2 = strfind(genes{j},['x' istr ')']);
        if ~isempty(k1)
            xhits(i)=xhits(i)+length(k1);
        end
        
        if ~isempty(k2)
            xhits(i)=xhits(i)+length(k2);
        end

    end

end