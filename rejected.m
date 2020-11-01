%% rejected

function [R1,R2] = rejected(x1,x2,R,w1,w2,S)
% Per considerare R o meno in ogni stage cost  
if x1 == S && x2 ~= S && w1 == 1 
   R1 = R;
   R2 = 0;
elseif x1 ~= S && x2 == S && w2 == 1
       R1 = 0;
       R2 = R;
elseif x1 == S && x2 == S && w1 == 1 && w2 == 1
       R1 = R;
       R2 = R;
elseif x1 == S && x2 == S && w1 == 0 && w2 == 1
       R1 = 0;
       R2 = R;
elseif x1 == S && x2 == S && w1 == 1 && w2 == 0
       R1 = R;
       R2 = 0;
else
    R1 = 0;
    R2 = 0;
end
