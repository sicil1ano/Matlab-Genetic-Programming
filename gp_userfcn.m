function gp=gp_userfcn(gp)
%GP_USERFCN Calls a user defined function once per generation if one has been
%specified in the field GP.USERDATA.USER_FCN.
% 
%   Remarks:
%   The user defined function must accept (as 1st) and return (as 2nd) the 
%   GP structure as arguments.
%
%   Example:
%   In symbolic regression the function regressmulti_fitfun_validate can be
%   called once per generation to evaluate the best individual so far on
%   a validation ('holdout') data set.
%
%   v1.0
%
%   (c) Dominic Searson 2009 

if ~isempty(gp.userdata.user_fcn)
    [dummy,gp]=feval(gp.userdata.user_fcn,gp);
end
