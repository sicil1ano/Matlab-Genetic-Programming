function [gp]=gpscale(gp)
%GPSCALE creates scaled user data matrices for use with
%regressmulti_fitfun.
%
%   [GP]=gpscale(GP) modifies the GP structure and scales
%   GP.USERDATA.XTRAIN and GP.USERDATA.YTRAIN fields to
%   zero mean and unit variance/sdev. The scaled data is then stored in the
%   fields GP.USERDATA.XTRAINS and GP.USERDATA.YTRAINS.
%
%   The scaling parameters are then used to
%   form the scaled fields GP.USERDATA.XTESTS, GP.USERDATA.YTESTS
%   and GP.USERDATA.XVALS, GP.USERDATA.YVALS (if holdout data exists).
%
%   The scaling parameters are written to the following fields:
%   GP.USERDATA.MUX (means of columns of GP.USERDATA.XTRAIN)
%   GP.USERDATA.SIGMAX = (sdevs of columns of GP.USERDATA.XTRAIN)
%   GP.USERDATA.MUY = (mean of GP.USERDATA.YTRAIN)
%   GP.USERDATA.SIGMAY = (sdevs of columns of GP.USERDATA.YTRAIN)
%
%   Remarks:
%   Any columns of GP.USERDATA.XTRAIN that have zero variance are
%   removed from GP.USERDATA.XTRAINS. The column indices of the removed
%   columns are stored in GP.USERDATA.REMOVED_SCALED_XCOLUMNS and are used,
%   for example, by GPMODEL2MFILE when creating a standalone model file.
%
%
%   (c) Dominic Searson 2009
%
%   v1.0

gp.userdata.scale = true;

%get data
xtrain=gp.userdata.xtrain;
ytrain = gp.userdata.ytrain;

% check that test data is present
if (~isfield(gp.userdata,'xtest')) || (~isfield(gp.userdata,'ytest')) || ...
        isempty(gp.userdata.xtest) || isempty(gp.userdata.ytest)
    usetest=false;
else
    usetest=true;
    xtest = gp.userdata.xtest;
    ytest = gp.userdata.ytest;
end



% check that validation data is present
if (~isfield(gp.userdata,'xval')) || (~isfield(gp.userdata,'yval')) || ...
        isempty(gp.userdata.xval) || isempty(gp.userdata.yval)
    useval=false;
else
    useval=true;
    xval = gp.userdata.xval;
    yval = gp.userdata.yval;
end

% First try to scale input training data
[xtrainS,mux,sigmax]=scalematrix(xtrain);

%check & get rid of any columns with zero variance/sdev
zv_ind=find(sigmax==0);
xtrain(:,zv_ind)=[];
if usetest
    xtest(:,zv_ind)=[];
end
if useval
    xval(:,zv_ind)=[];
end

[gp.userdata.xtrainS,mux,sigmax]=scalematrix(xtrain);
if usetest
    gp.userdata.xtestS = (xtest-repmat(mux,size(xtest,1),1))./repmat(sigmax,size(xtest,1),1);
end
if useval
    gp.userdata.xvalS = (xval-repmat(mux,size(xval,1),1))./repmat(sigmax,size(xval,1),1);
end

%Scale outputs
[gp.userdata.ytrainS,muy,sigmay]=scalematrix(ytrain);
if usetest
    gp.userdata.ytestS = (ytest-repmat(muy,size(ytest,1),1))./repmat(sigmay,size(ytest,1),1);
end
if useval
    gp.userdata.yvalS = (yval-repmat(muy,size(yval,1),1))./repmat(sigmay,size(yval,1),1);
end

gp.userdata.mux = mux;
gp.userdata.sigmax = sigmax;
gp.userdata.muy = muy;
gp.userdata.sigmay = sigmay;

if ~isempty(zv_ind)
    disp('GPSCALE warning: The following columns of the scaled input data have been removed because they have zero variance: ');
    disp(num2str(zv_ind));
    gp.userdata.removed_scaled_xcolumns=zv_ind;
else
    gp.userdata.removed_scaled_xcolumns=[];
end

function [z,mu,sigma]=scalematrix(x)

mu =mean(x);
sigma=std(x);

z = x-repmat(mu,size(x,1),1);
z=   z ./(repmat(sigma,size(x,1),1));




