function [file]=renderLatex(gp,ind,dpi)
%RENDERLATEX GPTIPS post-run function to render LaTeX version of simplified
%multigene symbolic regression expressions and display resulting image file.
%
%   Intended to render as a PNG image the simplified overall multigene 
%   symbolic regression expressions created with GPTIPS using the 
%   REGRESSMULTI_FITFUN fitness function.
%
%   It is assumed that the overall symbolic model is a linear superposition 
%   of the M genes weighted by regression coefficients plus a bias 
%   (offset) term.
%   I.e.
%   ypred = c0 + c1*tree1 + ... + cM*treeM'
%   where c0 = bias and c1, ..., cM are the gene weights.
%
%   RENDERLATEX(GP,IND) renders the LaTeX version of population member with 
%   population index IND in the GPTIPS datastructure GP. The image file is 
%   created in the current directory with the name gptips_model.png
%
%   RENDERLATEX(GP,''BEST'') renders the LaTeX version of the best 
%   individual of the run.
%
%   RENDERLATEX(GP,''VALBEST'') renders the LaTex version of the best
%   individual of the run on the holdout validation data set (if it exists).
%
%   FILE = RENDERLATEX(GP,''BEST'') does the above and returns the path of 
%   the resulting image file as FILE.
%
%   FILE = RENDERLATEX(GP,''BEST'',DPI) does the above and returns the path of the
%   resulting image file as FILE. The image will be rendered as a PNG file
%   with DPI (dots per sq. inch) resolution. Default is 600.
%
%   Remarks:
%   Uses an HTTP request to the CGI LateX interpreter available at
%   http://sciencesoft.at/latex/ which, at time of writing, works ok.
% 
%   REQUIRES SYMBOLIC MATH TOOLBOX TO GENERATE IMAGE.
%
%   Known problems:
%   A error will be thrown if you are behind a proxy and have not set
%   Matlab up to use the proxy. To do this go to the Matlab File menu --> 
%   Preferences --> Web.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also GPPRETTY, REGRESSMULTI_FITFUN, POPBROWSER, GPREFORMAT, SYM, PRETTY, LATEX

if nargin < 3
 dpi=600;   
end

if nargin<2
    disp('Usage is RENDERLATEX(GP,IND) where IND is the population index of the desired individual');
    disp('or RENDERLATEX(GP,''BEST'') to use the best individual in the population. ');
    return;
end



if license('test','symbolic_toolbox')

    
    %check resolution settings
    dpi=round(dpi);
    
    if dpi>720
    disp('Maximum DPI is currently 720');
    return;
    end
    
    if dpi<120
        disp('Minimum DPI is currently 120')
    end
    
    
    %simplify, get latex code and call web based rendering
    [le,fle]= gppretty(gp,ind);
    str = ['http://sciencesoft.at/image/latexurl/image.png?dpi=' int2str(dpi) '&src=' strrep(fle,' ','%20')];
    file = urlwrite(str,'gptips_model.png');
    if license('test','image_toolbox')
        figure;
        imshow(file);
    else
    picdata=imread('gptips_model.png');
    h=image(picdata);
    axis equal;
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    end
else

    disp('You need the Symbolic Math Toolbox to use this function.');
end