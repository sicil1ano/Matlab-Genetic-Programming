function [son,daughter]=crossover(mum,dad,gp)
%CROSSOVER GPTIPS function to crossover 2 GP expressions to produce 2 new
%GP expressions.
%
%   [SON,DAUGHTER]=CROSSOVER(MUM,DAD,GP) uses standard subtree
%   crossover on the expressions MUM and DAD to produce the offspring
%   expressions SON and DAUGHTER.
%
%   (c) Dominic Searson 2009
%
%   v1.0
%
%   See also MUTATE


% select random crossover nodes in mum and dad expressions
m_position=picknode(mum,0,gp);
d_position=picknode(dad,0,gp);


% extract main and subtree expressions
[m_main,m_sub]=extract(m_position,mum);
[d_main,d_sub]=extract(d_position,dad);

%combine to form 2 new GPtrees
daughter=strrep(m_main,'$',d_sub);
son=strrep(d_main,'$',m_sub);

