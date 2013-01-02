function gpmodel2mfile(varargin)
%GPMODEL2MFILE Utility function to convert a multigene symbolic regression 
%model to a standalone M file.
%
%    GPMODEL2MFILE(GP, 'BEST','FILENAME') converts the "best" model in the
%    population to a function in FILENAME.M
%  
%    GPMODEL2MFILE(GP, 'VALBEST','FILENAME') converts the "best" model, 
%    as evaluated on the holdout validation data, to a function in 
%    FILENAME.M
%
%    GPMODEL2MFILE(GP, IND,'FILENAME') converts the model with index IND in
%    the population to a function in FILENAME.M
%
%    Remarks:
%    This function is designed for use with multigene symbolic models
%    created with the REGRESSMULTI_FITFUN fitness function.
%
%    If the model was built using data scaled by the GPSCALE function then
%    the required scaling data is saved into a MAT file called
%    FILENAME_SCALINGDATA.MAT. This is then loaded and applied when the 
%    model is run on new data.
%
%    Note:
%    Requires Symbolic Math Toolbox.
%
%   (c) Dominic Searson 2009
%
%   v1.0

if license('test','symbolic_toolbox')

 filename=varargin{end};
    
 [gene_latex_expr,full_latex_expr,expr_sym]=gppretty(varargin{1:end-1});


gp=varargin{1}; 
 

% Vectorise the whole multigene model and extract to string
vectorized_model_str=['ypred=' vectorize(expr_sym)];

% replace x1,x2,x3 etc with x(:,1), x(:,2), x(:,3) etc. 
pat='x(\d+)';
vectorized_model_str=regexprep(vectorized_model_str,pat,'x(:,$1)');

if strcmp(filename(end-1:end),'.m')
    filename=filename(1:end-2);
end

%now open file and write m file header etc
fid=fopen([filename '.m'],'w');

fprintf(fid,['function ypred=' filename '(x)']);
fprintf(fid,'\n');
fprintf(fid,['%%'   upper(varargin{end}) ' This model file was automatically generated by the GPTIPS function gpmodel2mfile on ' datestr(now)]);
fprintf(fid,'\n\n');


%if the model was built using data scaled with gpscale then scale inputs using loaded scaling parameters
if gp.userdata.scale
   mux = gp.userdata.mux;
   muy = gp.userdata.muy;
   sigmax = gp.userdata.sigmax;
   sigmay = gp.userdata.sigmay;
   removed_xcols=gp.userdata.removed_scaled_xcolumns;
   eval(['save ' filename '_scalingdata.mat mux muy sigmax sigmay removed_xcols;']);
   fprintf(fid, ['load ' filename '_scalingdata.mat; \n']); 
   fprintf(fid, '\nx(:,removed_xcols) = []; \n'); 
   fprintf(fid, '\nx = (x- repmat(mux,size(x,1),1) )./ repmat(sigmax,size(x,1),1);  \n\n'); 
end


fprintf(fid,[vectorized_model_str ';']);
fprintf(fid,'\n');

%if the data was scaled with gpscale then unscale using stored scaling parameters
if gp.userdata.scale
   fprintf(fid, '\nypred = ypred * sigmay  +  muy;'); 
end
fclose(fid);

disp(['Model sucessfully written to ' filename '.m']);

else 
  disp('The Symbolic Math Toolbox is required to use this function.');
    
end
