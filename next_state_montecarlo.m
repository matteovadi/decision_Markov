%% next_state_montecarlo %% 

function [x_next] = next_state_montecarlo(x1,x2,w1,w2,S,u1,u2,t,x_next)
% Generazione del prossimo stato sulla base dello stato corrente, dell'input e della realizzazione di w
    if x1 == S && x2 ~= S && w1 == 1 
       x_next(t,1) = x1 - u1;
       x_next(t,2) = x2 - u2 + w2; 
    elseif x1 ~= S && x2 == S && w2 == 1
           x_next(t,1) = x1 - u1 + w1;
           x_next(t,2) = x2 - u2;            
    elseif x1 == S && x2 == S
           x_next(t,1) = x1 - u1;
           x_next(t,2) = x2 - u2; 
    else
         x_next(t,1) = x1 - u1 + w1;
         x_next(t,2) = x2 - u2 + w2;
    end
    
end

