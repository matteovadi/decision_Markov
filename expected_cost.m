%% expected_cost %%

function [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k)
% Per ogni possibile coppia di valori di w = (w1,w2)
  for w2 = 0:1:1
      for w1 = 0:1:1 
          [x_next,R1,R2] = next_state(x,x1,x2,u1,u2,R,w1,w2,S);
          if w1 == 0 && w2 == 0
             c1 = (g1* x_next(1,1)^2) + R1;
             c2 = (g2* x_next(1,2)^2) + R2;
             z(1,:) = (c1 + c2 + h)*pr(1,1);
             V(1,:) = alpha*(V_aux(x_next(1,2)+1,1,x_next(1,1)+1,k)*pr(1,1));
          elseif w1 == 1 && w2 == 0
                 c1 = (g1* x_next(2,1)^2) + R1;
                 c2 = (g2* x_next(2,2)^2) + R2;
                 z(2,:) = (c1 + c2 + h)*pr(2,1);
                 V(2,:) = alpha*(V_aux(x_next(2,2)+1,1,x_next(2,1)+1,k)*pr(2,1));
          elseif w1 == 0 && w2 == 1
                 c1 = (g1* x_next(3,1)^2) + R1;
                 c2 = (g2* x_next(3,2)^2) + R2;
                 z(3,:) = (c1 + c2 + h)*pr(3,1); 
                 V(3,:) = alpha*(V_aux(x_next(3,2)+1,1,x_next(3,1)+1,k)*pr(3,1));
          elseif w1 == 1 && w2 == 1
                 c1 = (g1* x_next(4,1)^2) + R1;
                 c2 = (g2* x_next(4,2)^2) + R2;
                 z(4,:) = (c1 + c2 + h)*pr(4,1);   
                 V(4,:) = alpha*(V_aux(x_next(4,2)+1,1,x_next(4,1)+1,k)*pr(4,1));
          end
      end
  end

end

