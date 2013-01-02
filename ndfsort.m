function xrank=ndfsort(x)
%NDFSORT Implementation of Deb et al.'s fast non dominated sorting
%algorithm for 2 objectives only.
%
%   [XRANK]=NDFSORT(X) performed on a N x 2 matrix X where N is the number
%   of solutions and there are 2 objectives separates out the solutions
%   into different levels (ranks) of non-domination. The returned vector
%   XRANK contains the rank of the corresponding solutions. Solutions with
%   rank 1 come from the first non-dominated front, those with rank 2 from 
%   the the front of solutions that are only dominated by one other 
%   solution and so on.
%
%   Remarks:
%   Uses the sorting method described on page 184 of:
%   "A fast and elitist multiobjective genetic algorithm: NSGA-II"
%   by Kalyanmoy Deb, Amrit Pratap, Sameer Agarwal, T. Meyarivan
%   IEEE Transactions on Evolutionary Computation VOL. 6, NO. 2, APRIL
%   2002, pp. 182-197
%
%   (c) Dominic Searson 2009
%
%   v1.0


P=size(x,1);

np=zeros(P,1); %current domination level


xrank=np;  %rank vector

F(1).contains=[]; % F(1) contains rank 1 solutions, F(2) rank 2 solutions etc.

for p=1:P
    S(p).dominates=[]; %S(1).dominates contains the solutions that solution 1 strongly dominates
    for q=1:P

        if doesx1Domx2(x(p,:),x(q,:))
            S(p).dominates=[S(p).dominates q];
        elseif doesx1Domx2(x(q,:),x(p,:))
            np(p)=np(p)+1;
        end


    end

    if np(p)==0
        xrank(p)=1;
        F(1).contains=[F(1).contains p];
    end

end

i=1;
while true

    if length(F)~=i
        break
    end

    sizeF=length(F(i).contains);

    Q=[];


    for k=1:sizeF

        for l=1:length( S(F(i).contains(k)).dominates )
            %current solution
            q=S(F(i).contains(k)).dominates(l);
            np(q)=np(q)-1;

            if np(q)==0
                xrank(q)=i+1;
                Q=[Q q];
            end

        end
    end
    i=i+1;
    if ~isempty(Q)
        F(i).contains=Q;
    end


end



function result=doesx1Domx2(x1,x2)
%Returns true if first solution dominates second, false otherwise.

result=false;

if x1(1)<x2(1) && x1(2)<x2(2)
    result=true;
end


function result=doesx1Domx2_3d(x1,x2)
%Returns true if first solution dominates second, false otherwise.

result=false;

if x1(1)< x2(1) && x1(2)< x2(2) && x1(3) < x2(3)
    result=true;
end
