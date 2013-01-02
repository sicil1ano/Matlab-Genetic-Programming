function [fitness,gp,ypredtrain,fitness_test,ypredtest,pvals]=regressmulti_fitfun(evalstr,gp)
%REGRESSMULTI_FITFUN GPTIPS fitness function to perform multigene
%non-linear symbolic regression on data comprising one output y and
%multiple inputs x1, ..xn.
%
%   Fitness function for multigene symbolic regression.
%
%   [FITNESS,GP]=REGRESSMULTI_FITFUN(EVALSTR,GP) returns the FITNESS of
%   the symbolic expression(s) in the cell array EVALSTR using information
%   contained in the GP data structure. In this case FITNESS is the root
%   mean squared prediction error on the training data set.
%
%   [FITNESS,GP,YPREDTRAIN,FITNESS_TEST,YPREDTEST,PVALS]=REGRESSMULTI_FITFUN(EVALSTR,GP)
%   may be used post-run to compute the fitness value FITNESS_TEST on the test data set
%   as well as the prediction of the model on the training data YPREDTRAIN and the
%   testing data YPREDTEST. The statistical p-values are returned as PVALS
%   (PVALS only computed if the Statistics Toolbox is present, otherwise an
%   empty variable is returned).
%
%   Remarks:
%   Each observation of the response variable y is assumed to be a
%   non-linear function of the corresponding observations of the predictor
%   variables x1,..xn.
%
%   Training data:
%   The user's GPTIPS configuration file should populate the following
%   required fields for the training data assuming 'Ntrain' observations on
%   the input and output data:
%   GP.USERDATA.XTRAIN should be a (Ntrain X n) matrix where the ith column
%   contains the Ntrain observations of the ith input variable xi.
%   GP.USERDATA.YTRAIN should be a (Ntrain x 1) vector containing the
%   corresponding observations of the response variable y.
%
%   Testing data:
%   The following fields are optional and may be used, post-run, to see how
%   well evolved models generalise to an unseen test data set with Ntest
%   observations. They do not affect the model building process.
%   GP.USERDATA.XTEST should be a (Ntest X n) matrix where the ith column
%   contains the Ntest observations of the ith input variable xi.
%   GP.USERDATA.YTEST should be a (Ntest x 1) vector containing the
%   corresponding observations of the response variable y.
%
%
%   How multigene symbolic regression works:
%   In multigene symbolic regression, each prediction of y is formed by the
%   weighted output of each of the trees/genes in the multigene individual
%   plus a bias term. The number (M) and structure of the trees is evolved
%   automatically during a GPTIPS run (subject to user defined constraints).
%
%   i.e. ypredtrain = c0 + c1*tree1 + ... + cM*treeM
%
%   where c0 = bias term
%         c1,..,cM are the weights
%         M is the number of genes/trees comprising the current individual
%
%   The weights (i.e. regression coefficients) are automatically determined
%   by a least squares procedure for each multigene individual and are
%   stored in GP.FITNESS.RETURNVALUES for future use.
%
%
%   Note:
%   Because the GP structure is modified within this
%   function (i.e. the field GP.FITNESS.RETURNVALUES is used to store
%   the computed weighting coefficients for each gene) the GP structure
%   must be returned as an output argument.
%
%   This fitness function is used for multigene symbolic regression for
%   GPDEMO2, GPDEMO3 and GPDEMO4 (the configuration files for these are
%   GPDEMO2_CONFIG.M, GPDEMO3_CONFIG.M and GPDEMO4_CONFIG.M respectively)
%   but it can and should be used for the user's own non-linear regression
%   problems.
%
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also REGRESSMULTI_FITFUN_VALIDATE, GPDEMO2_CONFIG, GPDEMO3_CONFIG,
%   GPDEMO4_CONFIG, GPDEMO2, GPDEM03, GPDEMO4




% process evalstr with regex to allow direct access to data matrices
pat='x(\d+)';

if gp.userdata.scale
    evalstr=regexprep(evalstr,pat,'gp.userdata.xtrainS(:,$1)');
    y=gp.userdata.ytrainS;
else
    evalstr=regexprep(evalstr,pat,'gp.userdata.xtrain(:,$1)');
    y=gp.userdata.ytrain;
end


num_data_points=size(y,1);
num_genes=length(evalstr);


%set up a matrix to store the tree outputs plus a bias column of ones
gene_outputs=ones(num_data_points,num_genes+1);


%eval each gene in the current individual
for i=1:num_genes
    ind=i+1;
    eval(['gene_outputs(:,ind)=' evalstr{i} ';']);

    %check for nonsensical answers and break out early with an 'inf' if so
    if  any(isnan(gene_outputs(:,ind))) || any(isinf(gene_outputs(:,ind)))
        fitness=Inf;
        return
    end

end


if ~gp.state.run_completed %i.e. only calc. weighting coeffs during an actual run


    % if data sampling is enabled only fit regression coeffs on random (per
    % generation) sub-sample of training data
    if gp.userdata.datasampling

        %if new generation then specify a new random subset of training data
        if gp.state.current_individual==1
            rand_vec = rand(num_data_points,1);
            gp.userdata.y_select = (rand_vec<=0.75);
        end

        %get subset of training data
        gene_outputs_sampled=gene_outputs(gp.userdata.y_select,:);

        %prepare LS matrix
        prj=gene_outputs_sampled'*gene_outputs_sampled;

        %compute gene weights on subset only
        try
            theta=pinv(prj)*gene_outputs_sampled'*y(gp.userdata.y_select);
        catch
            fitness=Inf;
            return;
        end

    else


        %prepare LS matrix
        prj=gene_outputs'*gene_outputs;

        %calculate coeffs using SVD least squares on full training data set
        try
            theta=pinv(prj)*gene_outputs'*y;
        catch
            fitness=Inf;
            return;
        end

    end

    %assign poor fitness if any NaN or Inf
    if any(isinf(theta)) || any(isnan(theta))
        fitness=Inf;
        return;
    end

    %write coeffs to returnvalues field for storage
    gp.fitness.returnvalues{gp.state.current_individual}=theta;

else % if post-run, get stored coeffs from return value field

    theta=gp.fitness.returnvalues{gp.state.current_individual};
end


%calc. prediction of full training data set using the estimated weights
ypredtrain=gene_outputs*theta;

%unscale before reporting fitness, if required
if gp.userdata.scale
    ypredtrain= (ypredtrain.*gp.userdata.sigmay)+gp.userdata.muy;
end

%calculate RMS prediction error (fitness)
fitness=sqrt(mean((gp.userdata.ytrain-ypredtrain).^2));







%---------- below is code for post run evaluation of individuals, it is not executed during a GPTIPS run--------------------




if gp.state.run_completed
    gp.userdata.showgraphs=true;
elseif gp.state.count==1
    gp.userdata.showgraphs=false;
end

if gp.userdata.showgraphs

    %compute variation explained for training data
    varexp_train=100*(1- sum( (gp.userdata.ytrain-ypredtrain).^2 )/sum( (gp.userdata.ytrain-mean(gp.userdata.ytrain)).^2 ) );

    plot_validation=0;


    %first,check if validation data is present, if so need to plot that too
    if (isfield(gp.userdata,'xval')) && (isfield(gp.userdata,'yval')) && ...
            ~isempty(gp.userdata.xval) && ~isempty(gp.userdata.yval)


        plot_validation=1;

        evalstr=strrep(evalstr,'.xtrain','.xval');

        if gp.userdata.scale
            yval=gp.userdata.yvalS;
        else
            yval=gp.userdata.yval;
        end


        num_data_points=length(yval);

        %set up a matrix to store the tree outputs plus a bias column of ones
        gene_outputs_val=zeros(num_data_points,num_genes+1);
        gene_outputs_val(:,1)=ones;


        %eval each tree
        for i=1:num_genes
            ind=i+1;
            eval(['gene_outputs_val(:,ind)=' evalstr{i} ';']);
        end

        ypredval=gene_outputs_val*theta; %create the prediction  on the validation data

        %unscale for fitness and stats reporting
        if gp.userdata.scale
            ypredval= (ypredval.*gp.userdata.sigmay)+gp.userdata.muy;
        end

        fitness_val=sqrt(mean((gp.userdata.yval-ypredval).^2));

        %compute variation explained for validation data
        varexp_val=100*(1- sum( (gp.userdata.yval-ypredval).^2 )/sum( (gp.userdata.yval-mean(gp.userdata.yval)).^2 ) ) ;

        evalstr=strrep(evalstr,'.xval','.xtrain');
    end






    %generate prediction on test data (if present)

    if (isfield(gp.userdata,'xtest')) && (isfield(gp.userdata,'ytest')) && ...
            ~isempty(gp.userdata.xtest) && ~isempty(gp.userdata.ytest)


        evalstr=strrep(evalstr,'.xtrain','.xtest');


        if gp.userdata.scale
            ytest=gp.userdata.ytestS;
        else
            ytest=gp.userdata.ytest;
        end

        num_data_points=length(ytest);

        %set up a matrix to store the tree outputs plus a bias column of ones
        gene_outputs_test=zeros(num_data_points,num_genes+1);
        gene_outputs_test(:,1)=ones;


        %eval each tree
        for i=1:num_genes
            ind=i+1;
            eval(['gene_outputs_test(:,ind)=' evalstr{i} ';']);
        end

        ypredtest=gene_outputs_test*theta; %create the prediction  on the testing data

        %now unscale  for plotting and stats reporting
        if gp.userdata.scale
            ypredtest= (ypredtest.*gp.userdata.sigmay)+gp.userdata.muy;
        end

        fitness_test=sqrt(mean((gp.userdata.ytest-ypredtest).^2));

        %compute variation explained for test data
        varexp_test=100*(1- sum( (gp.userdata.ytest-ypredtest).^2 )/sum( (gp.userdata.ytest-mean(gp.userdata.ytest)).^2 ) );


        % model prediction
        f=figure('name','GPTIPS Multigene regression. Model prediction of individual.','numbertitle','off');
        subplot(2+plot_validation,1,1);
        plot(ypredtrain,'r');
        hold on;
        plot(gp.userdata.ytrain);
        ylabel('y');
        xlabel('Data point');
        legend('Predicted y (training values)','Actual y (training values)');
        title(['RMS training set error: ' num2str(fitness) ' Variation explained: ' num2str(varexp_train) ' %']);
        hold off


        subplot(2+plot_validation,1,2);
        plot(ypredtest,'r');
        hold on;
        plot(gp.userdata.ytest);
        ylabel('y');
        xlabel('Data point');
        legend('Predicted y (test values)','Actual y (test values)');
        title(['RMS test set error: ' num2str(fitness_test) ' Variation explained: ' num2str(varexp_test) ' %']);
        hold off


        %scatterplot
        s=figure('name','GPTIPS Multigene regression. Prediction scatterplot of individual.','numbertitle','off');
        subplot(2+plot_validation,1,1);
        minval=min([gp.userdata.ytrain;ypredtrain]);
        maxval=max([gp.userdata.ytrain;ypredtrain]);
        scatter(gp.userdata.ytrain,ypredtrain);
        axis ([minval maxval minval maxval]);
        l1=line([minval maxval], [minval maxval]);
        set(l1,'color','black');
        box on;grid on;
        ylabel('Predicted');
        xlabel('Actual');
        title(['RMS training set error: ' num2str(fitness) ' Variation explained: ' num2str(varexp_train) ' %']);



        subplot(2+plot_validation,1,2);
        minval=min([gp.userdata.ytest;ypredtest]);
        maxval=max([gp.userdata.ytest;ypredtest]);
        scatter(gp.userdata.ytest,ypredtest);
        axis ([minval maxval minval maxval]);
        l2=line([minval maxval], [minval maxval]);
        set(l2,'color','black');
        box on;grid on;
        ylabel('Predicted');
        xlabel('Actual');
        title(['RMS test set error: ' num2str(fitness_test) ' Variation explained: ' num2str(varexp_test) ' %']);

        if plot_validation

            figure(f);
            subplot(3,1,3);
            plot(ypredval,'r');
            hold on;
            plot(gp.userdata.yval);
            ylabel('y');
            xlabel('Data point');
            legend('Predicted y (validation values)','Actual y (validation values)');
            title(['RMS validation set error: ' num2str(fitness_val) ' Variation explained: ' num2str(varexp_val) ' %']);
            hold off;

            figure(s);
            subplot(3,1,3);
            minval=min([gp.userdata.yval;ypredval]);
            maxval=max([gp.userdata.yval;ypredval]);
            scatter(gp.userdata.yval,ypredval);
            axis ([minval maxval minval maxval]);
            l3=line([minval maxval], [minval maxval]);
            set(l3,'color','black');
            box on;grid on;
            title(['RMS validation set error: ' num2str(fitness_val) ' Variation explained: ' num2str(varexp_val) ' %']);
            ylabel('Predicted');
            xlabel('Actual');



        end


    else %if no test data just show training data


        if plot_validation


            f=figure('name','GPTIPS Multigene regression. Model prediction of individual.','numbertitle','off');
            train_ax=subplot(2,1,1);
            plot(train_ax,ypredtrain,'r');
            hold on;
            plot(train_ax,gp.userdata.ytrain);
            ylabel('y');
            xlabel('Data point');
            legend('Predicted y (training values)','Actual y (training values)');
            title(['RMS training set error: ' num2str(fitness) ' Variation explained: ' num2str(varexp_train) ' %']);
            hold off

            val_ax=subplot(2,1,2);
            plot(val_ax,ypredval,'r');
            hold on;
            plot(val_ax,gp.userdata.yval);
            ylabel('y');
            xlabel('Data point');
            legend('Predicted y (validation values)','Actual y (validation values)');
            title(['RMS validation set error: ' num2str(fitness_val) ' Variation explained: ' num2str(varexp_val) ' %']);
            hold off

            %scatterplot
            figure('name','GPTIPS Multigene regression. Prediction scatterplot of individual.','numbertitle','off');
            subplot(2,1,1);
            minval=min([gp.userdata.ytrain;ypredtrain]);
            maxval=max([gp.userdata.ytrain;ypredtrain]);
            scatter(gp.userdata.ytrain,ypredtrain);
            axis ([minval maxval minval maxval]);
            l1=line([minval maxval], [minval maxval]);
            set(l1,'color','black');
            box on;grid on;
            ylabel('Predicted');
            xlabel('Actual');
            title(['RMS training set error: ' num2str(fitness) ' Variation explained: ' num2str(varexp_train) ' %']);



            subplot(2,1,2);
            minval=min([gp.userdata.yval;ypredval]);
            maxval=max([gp.userdata.yval;ypredval]);
            scatter(gp.userdata.yval,ypredval);
            axis ([minval maxval minval maxval]);
            l3=line([minval maxval], [minval maxval]);
            set(l3,'color','black');
            box on;grid on;
            title(['RMS validation set error: ' num2str(fitness_val) ' Variation explained: ' num2str(varexp_val) ' %']);
            ylabel('Predicted');
            xlabel('Actual');

            disp('No test set data found.');



        else



            f=figure('name','GPTIPS Multigene regression. Model prediction of individual.','numbertitle','off');
            plot(ypredtrain,'r');
            hold on;
            plot(gp.userdata.ytrain);
            ylabel('y');
            xlabel('Data point');
            legend('Predicted y (training values)','Actual y (training values)');
            title(['RMS training set error: ' num2str(fitness) ' Variation explained: ' num2str(varexp_train) ' %']);
            hold off


            %scatterplot
            figure('name','GPTIPS Multigene regression. Prediction scatterplot of individual.','numbertitle','off');
            minval=min([gp.userdata.ytrain;ypredtrain]);
            maxval=max([gp.userdata.ytrain;ypredtrain]);
            scatter(gp.userdata.ytrain,ypredtrain);
            axis ([minval maxval minval maxval]);
            l1=line([minval maxval], [minval maxval]);
            set(l1,'color','black');
            box on;grid on;
            ylabel('Predicted');
            xlabel('Actual');
            title(['RMS training set error: ' num2str(fitness) ' Variation explained: ' num2str(varexp_train) ' %']);


            disp('No test set data found.');


        end

        fitness_test=[];
        ypredtest=[];

    end




    %Display statistical analysis of model term significance (if stats
    %toolbox is present and graphs are enabled)

    if license('test','statistics_toolbox')
        % Regress tree outputs (and bias) against y train data and get stats
        stats=regstats(y,gene_outputs(:,2:end));
        pvals=stats.tstat.pval;
    else
        pvals=[];
    end

    if  license('test','statistics_toolbox')



        %generate x labels for bar graphs
        gene_labels={'Bias'};
        for i=1:num_genes
            gene_labels{i+1}=['Gene ' int2str(i)];
        end

        %plot gene weights and offset
        statfig=figure;
        coeffs_ax=subplot(2,1,1);
        set(statfig,'name','Statistical properties of multigene model (on training data)','numbertitle','off');
        bar(coeffs_ax,stats.beta); shading faceted;
        set(coeffs_ax,'xtick',1:(num_genes+1));
        set(coeffs_ax,'xticklabel',gene_labels);
        title(coeffs_ax,'Gene weights');



        %plot p-vals
        pvals_ax=subplot(2,1,2);
        bar(pvals_ax,stats.tstat.pval); shading faceted;
        set(pvals_ax,'xtick',1:(num_genes+1));
        set(pvals_ax,'xticklabel',gene_labels);
        title(pvals_ax,'P value (low = significant)');
        xlabel(['R squared = ' num2str(stats.rsquare) ' Adj. R squared = ' num2str(stats.adjrsquare)]);

    end
    figure(f);
else
    ypredtest=[];
    pvals=[];
    fitness_test=[];
end
