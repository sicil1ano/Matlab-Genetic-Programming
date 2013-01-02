function hitvec=gppopvars(gp,top_frac)
%GPPOPVARS Displays the frequency of the input variables present in the
%best user specified fraction of the population.
%
%   HITVEC=GPPOPVARS(GP) displays and returns an input frequency 
%   vector for the best 5% of the population.
%
%   HITVEC=GPPOPVARS(GP,TOP_FRAC) displays and returns an input frequency 
%   vector for the best fraction TOP_FRAC of the population. TOP_FRAC must 
%   be > 0 and <= 1. 
%
%   Remarks:
%   Assumes lower fitnesses are better.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: GPMODELVARS


if nargin<2
    top_frac=0.05;
end

if top_frac<= 0 || top_frac>1
    disp('Supplied fraction must be greater than zero and less than or equal to 1.');
    return;
end


num2process = ceil(top_frac*gp.runcontrol.pop_size);

[fsort,sort_ind]=sort(gp.fitness.values);

sort_ind=sort_ind(1:num2process);

numx=gp.nodes.inputs.num_inp;
hitvec=zeros(1,numx);

%loop through population
for i=1:num2process

    model=gp.pop{sort_ind(i)};
    hitvec = hitvec+ scangenes(model,numx);

end

% plot results as barchart
h=figure;
set(h,'name','gppopvars','numbertitle','off');
a=gca;
bar(a,hitvec);
axis tight;
xlabel('Input number');
ylabel('Input frequency');
title(['Input frequency - best ' num2str(100*top_frac) '% of whole population']);
hitvec=hitvec';