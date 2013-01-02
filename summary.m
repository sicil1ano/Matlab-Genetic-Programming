function summary(gp,plotlog)
%SUMMARY GPTIPS function to plot summary information from a GPTIPS run.
%
%   Remarks:
%   By default,log(fitness) is plotted rather than raw fitness when all
%   best fitness history values are > 0.
%   Use SUMMARY(GP,FALSE) to plot raw fitness values.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: RUNTREE, POPBROWSER



if nargin<1
    disp('Usage is SUMMARY(GP) to plot log fitness vlaues or SUMMARY(GP,FALSE) to plot raw fitness values.');
    return;
end

if nargin<2 
    plotlog=true;
end


if any(gp.results.history.bestfitness<=0)
    plotlog=false;
end

h=figure;
set(h,'name',['GPTIPS summary of run with timestamp: ' gp.info.stop_time '. Fitness function: ' ...
    func2str(gp.fitness.fitfun)],'numbertitle','off');




if plotlog
subplot(2,1,1);plot([0:1:gp.state.count-1],log(gp.results.history.runningbestfitness),'bx-');
ylabel('Log Fitness');
else
 subplot(2,1,1);plot([0:1:gp.state.count-1],gp.results.history.runningbestfitness,'bx-');
ylabel('Fitness');   
end
xlabel('Generation');

legend('Best fitness');
title(['Best fitness: ' num2str(gp.results.best.fitness) ' found at generation ' num2str(gp.results.best.foundatgen)]);



subplot(2,1,2);
hold on;
plot([0:1:gp.state.count-1],gp.results.history.meanfitness+gp.results.history.std_devfitness,'r:');hold on;
plot([0:1:gp.state.count-1],gp.results.history.meanfitness-gp.results.history.std_devfitness,'r:');
plot([0:1:gp.state.count-1],gp.results.history.meanfitness,'rx-');
legend('Mean fitness (+ - 1 std. dev)');
xlabel('Generation');
ylabel('Fitness');
hold off;

