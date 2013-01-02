function hitvec=gpmodelvars(gp,ind)
%GPMODELVARS Displays the frequency of the input variables present in the 
%specified individual in the population and returns the corresponding 
%frequency vector.
%
%   HITVEC=GPMODELVARS(GP,IND) operates on the population member with 
%   population index IND in the GPTIPS datastructure GP.
%
%   HITVEC=GPMODELVARS(GP,''BEST'') operates on the best individual of the 
%   run.
%
%   HITVEC=GPMODELVARS(GP,''VALBEST'') operates on the individual that 
%   performed best on the validation data (if it exists).
%
%   (c) Dominic Searson 2009
%
%   v1.0


if nargin<2
    disp('Usage is GPMODELVARS(GP,IND) where IND is the population index of the selected individual.');
    disp('or GPMODELVARS(GP,''best'') to run the best individual in the population.');
    return;
end

%get a specified individual from the population and
% scan it for input variables
if isnumeric(ind)

    model=gp.pop{ind};
    title_str=['gpmodelvars: input frequency in individual with index: ' int2str(ind)];

elseif ischar(ind) && strcmpi(ind,'best')
    
    model=gp.results.best.individual;
    title_str='gpmodelvars: input frequency in best individual.';

elseif ischar(ind) && strcmpi(ind,'valbest')

    % check that validation data is present
    if (~isfield(gp.userdata,'xval')) || (~isfield(gp.userdata,'yval')) || ...
            isempty(gp.userdata.xval) || isempty(gp.userdata.yval)
        disp('No validation data was found. Try gpmodelvars(gp,''best'') instead.');
        return;
    end

    model=gp.results.valbest.individual;
    title_str='gpmodelvars: input frequency in best validation individual.';
    
else


    error('Illegal argument');

end

%perform scan
numx=gp.nodes.inputs.num_inp;
hitvec=scangenes(model,numx);

% plot results as barchart
h=figure;
set(h,'name','gpmodelvars','numbertitle','off');
a=gca;
bar(a,hitvec);
axis tight;
xlabel('Input number');
ylabel('Input frequency');
title(title_str);
grid on;
hitvec=hitvec';
