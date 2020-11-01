%% next_wt %%

function [w1,w2] = next_wt(pr)
% Generazione casuale di w (coppia di componenti, w1 e w2) sulla base della pmf (pr)
w = randsample([1,2,3,4],1,true,pr');
    if w == 1
        w1 = 0;
        w2 = 0;
    elseif w == 2
           w1 = 1;
           w2 = 0;
    elseif w == 3
           w1 = 0;
           w2 = 1;  
    else
           w1 = 1;
           w2 = 1;
    end
end