function gp=rungp(config_file)
%RUNGP Runs GPTIPS using the specified parameter file.
%
%   GP=RUNGP('yourfile') or GP=RUNGP(@yourfile) runs GPTIPS using the
%   parameters contained in the file yourfile.m and returns the results in
%   the GP data structure.  Post run analysis commands may then be
%   run on this structure, e.g. SUMMARY(GP) or RUNTREE(GP,'BEST').
%
%   Demos:
%   Use 'gpdemo1' at the commmand line for a demonstration of simple symbolic
%   regression (not multigene).
%
%   For demos involving multigene symbolic regression see gpdemo2,
%   gpdemo3 and gpdemo4.
%
%    ----------------------------------------------------------------------
%
%    Copyright (C) 2010  Dominic Searson
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%   ----------------------------------------------------------------------
%
%   See also: GPDEMO1, GPDEMO2, GPDEMO3, GPDEMO4
%
%   v1.0 10th January, 2010.

% if no config supplied then report error
if nargin<1
    disp('Cannot execute. To run GPTIPS a configuration m file must be ');
    disp('specified, e.g. gp=rungp(''quartic_poly'') ');
    return;
end

% generate prepared data structure with some default parameter values
gp=gpdefaults();

% run user configuration file
gp=feval(config_file,gp);

% perform error checks
gp=gpcheck(gp);

% perform initialisation
gp=gpinit(gp);

% Set and store the the PRNG seed
gp.info.PRNGseed=sum(100*clock);
rand('twister',gp.info.PRNGseed);

% main generation loop
for count= 1:gp.runcontrol.num_gen

    if count==1;

        % generate the initial population
        gp=initbuild(gp);

        % calculate fitnesses of population members
        gp=evalfitness(gp);

        % update run statistics
        gp=updatestats(gp);

        % call user defined function (if defined)
        gp=gp_userfcn(gp);

        % display current stats on screen
        displaystats(gp);

    else

        % use crossover, mutation etc. to generate a new population
        gp=popbuild(gp);

        % calculate fitnesses of population members
        gp=evalfitness(gp);

        % update run statistics
        gp=updatestats(gp);

        % call user defined function
        gp=gp_userfcn(gp);

        % display current stats on screen
        displaystats(gp);

    end;

    %save gp structure
    if  gp.runcontrol.savefreq && ~mod(gp.state.count-1,gp.runcontrol.savefreq)
        save gptips_tmp gp
    end

    % break out of generation loop if termination required
    if gp.state.terminate
        disp('Fitness criterion met. Terminating run.');
        break;
    end

end;  %end generation loop


% finalise the run
gp=gpfinalise(gp);
