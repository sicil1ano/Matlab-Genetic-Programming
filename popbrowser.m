function popbrowser(gp)
%POPBROWSER GPTIPS graphical utility to browse the results of a run.
%
%   POPBROWSER(GP) shows a scatterplot of the current population on the axes 
%   fitness vs number of nodes.
%   Clicking on a point reveals the population index of the corresponding
%   GP individual(s). The individual(s) in the population with the "best"
%   fitness is highlighted with a red circle. Non-dominated Individuals 
%   (in the pareto sense) are plotted as green circles.
%
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also: SUMMARY, RUNTREE


if nargin<1
    error ('Usage is popbrowser(gp)');
end


pb=figure('visible','off');
set(pb,'name','GPTIPS Population browser');
ax1=gca;

set(ax1 ,'box','on')


axes(ax1);

%plot all members
bluedots=plot(ax1,gp.fitness.numnodes,gp.fitness.values,'bo');
set(bluedots,'markerfacecolor','blue','markeredgecolor','black');
hold on;

%find "best"
best_fit=gp.results.best.fitness;
best_node=gp.results.best.numnodes;


plot(ax1,best_node,best_fit,'ro','linewidth',2,'markersize',8);

ylabel(ax1,'Fitness');
xlabel(ax1,'Total number of nodes');


%highlight models on the pareto optimal front with green circles
xrank=ndfsort([gp.fitness.values gp.fitness.numnodes]);
greendots=plot(ax1,gp.fitness.numnodes(xrank==1),gp.fitness.values(xrank==1),'go');
set(greendots,'markerfacecolor','green','markeredgecolor','black');

hold off;



title(ax1,['GPTIPS run (timestamp): ' gp.info.stop_time '. Fitness function: ' ...
    func2str(gp.fitness.fitfun)],'interpreter','none');


set(pb,'userdata',gp);
set(pb,'numbertitle','off');
set(pb,'visible','on');

axes(ax1);



%enable datacursor mode
dcm_obj = datacursormode(gcf);
set(dcm_obj,'UpdateFcn',@disp_indiv);
set(dcm_obj,'SnapToDataVertex','on');
set(dcm_obj,'enable','on');

grid on;
drawnow;

function [txt]=disp_indiv(empt,event_obj)


gp=get(gcbf,'userdata');
a=get(event_obj);

b=get(a.Target);

if strcmp(b.Type,'line')
    numnodes=a.Position(1);
    fitness=a.Position(2);


    %locate in population
    fit_ind=find(gp.fitness.values==fitness);
    node_ind=find(gp.fitness.numnodes==numnodes);

    ind=intersect(fit_ind,node_ind);

    n_ind=numel(ind);

    txt=cell(n_ind+1,1);
    txt{1}='Individual(s) index: ';
    for i=1:n_ind
        txt{i+1}=int2str(ind(i));
    end





else
    txt='';
end
