%% montecarlo_discounted_cost %% 

function [z,w1,w2] = montecarlo_discounted_cost(x1,x2,u1,u2,R,S,pr,g1,g2,t,z,alpha)

[h] = realized_package(u1,u2);
[w1,w2] = next_wt(pr);
[R1,R2] = rejected(x1,x2,R,w1,w2,S);         
c1 = (g1* (x1)^2) + R1;
c2 = (g2* (x2)^2) + R2;
z(t,1) = alpha^(t-1)*(c1 + c2 + h); 

end 
