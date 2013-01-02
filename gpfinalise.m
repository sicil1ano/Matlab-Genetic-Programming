function gp=gpfinalise(gp)
%GPFINALISE GPTIPS function to finalise a run.
%
%   GP=GPFINALISE(GP)
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: RUNGP, GPINIT, GPCHECK

gp.info.stop_time=datestr(now,0);
gp.state.run_completed=true;

%make sure history fields are right size
gp.results.history.bestfitness=gp.results.history.bestfitness(1:gp.state.count);
gp.results.history.meanfitness=gp.results.history.meanfitness(1:gp.state.count);
gp.results.history.std_devfitness=gp.results.history.std_devfitness(1:gp.state.count);
gp.results.history.runningbestfitness=gp.results.history.runningbestfitness(1:gp.state.count);


%reset warning status to user's
warning(gp.info.div0state.state,'MATLAB:divideByZero');
warning(gp.info.log0state.state,'MATLAB:log:logOfZero');
gp.info=rmfield(gp.info,'div0state');
gp.info=rmfield(gp.info,'log0state');

if ~gp.runcontrol.quiet
    disp('GPTIPS run complete. ');
    disp(['Best fitness acheived: ' num2str(gp.results.best.fitness)]);
    disp('-----------------------------------------------------------');
end