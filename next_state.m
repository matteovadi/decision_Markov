%% next_state

function [x_next,R1,R2] = next_state(x,x1,x2,u1,u2,R,w1,w2,S)

if x1 == (S+1) && x2 ~= (S+1) && w1 == 1 
   R1 = R;
   R2 = 0;
elseif x1 ~= (S+1) && x2 == (S+1) && w2 == 1
       R1 = 0;
       R2 = R;
elseif x1 == (S+1) && x2 == (S+1) && w1 == 1 && w2 == 1
       R1 = R;
       R2 = R;
elseif x1 == (S+1) && x2 == (S+1) && w1 == 0 && w2 == 1
       R1 = 0;
       R2 = R;
elseif x1 == (S+1) && x2 == (S+1) && w1 == 1 && w2 == 0
       R1 = R;
       R2 = 0;
else
    R1 = 0;
    R2 = 0;
end

% Identificazione del prossimo stato
    if R1 == R && R2 ~= R 
       x_next = [x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1); x(x2-u2+w2,:,x1-u1); x(x2-u2+w2,:,x1-u1)];
    elseif R2 == R && R1 ~= R
           x_next = [x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1+w1); x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1+w1)];
    elseif R1 == R && R2 == R
           x_next = [x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1)];
    elseif R1 ~= R && R2 ~= R
           x_next = [x(x2-u2,:,x1-u1); x(x2-u2,:,x1-u1+w1); x(x2-u2+w2,:,x1-u1); x(x2-u2+w2,:,x1-u1+w1)];
    end 
end