function displaystats(gp)
%DISPLAYSTATS GPTIPS function to display run stats periodically.
%
%   DISPLAYSTATS(GP) updates the screen with run stats at the interval
%   specified in GP.RUN.VERBOSE
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: UPDATESTATS


%only display info if required
if  ~gp.runcontrol.verbose || gp.runcontrol.quiet || mod(gp.state.count-1,gp.runcontrol.verbose)
    return
end

gen=gp.state.count-1;

disp(['Generation ' num2str(gen)]);
disp(['Best fitness:   ' num2str(gp.results.best.fitness)]);
disp(['Mean fitness:   ' num2str(gp.state.meanfitness)]);
disp(['Best nodecount: ' num2str(gp.results.best.numnodes)]);
disp(' ');

