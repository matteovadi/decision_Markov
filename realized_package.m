%% realized_package

function [h] = realized_package(u1,u2)

% Creo una confezione solo se l'input è diverso da (0,0)
if u1 == 0 && u2 == 0
   h = 0;
else 
   h = -1; 
end
      
end