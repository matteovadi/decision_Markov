%% montecarlo_optimal_policy_punto5 %%
clear all
close 
clc
load('euristica_montecarlo.mat')

%% Parametri ed inizializzazione
[R,g1,g2,alpha,S,pr,z,T,Q,x_curr,x_next,u_distr,u] = montecarlo_setup();
J_star = zeros(Q,1);

%% Simulazione Monte Carlo
for q = 1:Q
    for t = 1:T+1  
        if t ~= 1
           x_curr(t,:) = x_next(t-1,:);    
        end
        x1 = x_curr(t,1);
        x2 = x_curr(t,2);  
        % Ingressi ottimali per ogni stato 
        if (x1 - x2) >= 2
            u1 = 2; % senape
            u2 = 0;
            
        elseif (x2 - x1) >= 1 && (x1 + x2) ~= sum([8,9]) && (x1 + x2) ~= sum([0,1]) % [x1,x2] ~= [8,9] && [x1,x2] ~= [0,1]
               u1 = 0; % turchese
               u2 = 2;
               
        elseif (x1 + x2) <= 1 
               u1 = 0; % celeste
               u2 = 0;
               
        elseif (x1 - x2) == 1 && (x1 + x2) ~= sum([1,0]) || x1 == x2 && (x1 + x2) ~= sum([0,0])|| (x1 + x2) == sum([8,9])
               u1 = 1; % giallo
               u2 = 1;
           
        end 
        % Calcolo del costo scontato per lo stato corrente
        [z,w1,w2] = montecarlo_discounted_cost(x1,x2,u1,u2,R,S,pr,g1,g2,t,z,alpha);
        % Generazione del prossimo stato sulla base dell'input ottimale 
        [x_next] = next_state_montecarlo(x1,x2,w1,w2,S,u1,u2,t,x_next);

    end
    J_star(q,1) = sum(z); % costo complessivo scontato per la q-esima iterazione
end

%% Stima del valore medio e della deviazione standard per la policy ottimale
mJ_optimal = mean(J_star); % costo complessivo scontato medio 
sigmaJ_optimal = std(J_star); % deviazione standard del costo complessivo scontato

%% Stima della distribuzione del costo complessivo scontato seguendo la policy ottimale e comparazione con la policy euristica 
nbins = round(2*(Q^(1/3))); % numero di bins per la creazione degli istogrammi
figure
hold on
histogram(J_star, nbins, 'Normalization', 'probability', 'FaceColor', 'r','FaceAlpha', 1)
histogram(J_euristic, nbins, 'Normalization', 'probability', 'FaceColor', 'g', 'FaceAlpha', 0.7)
xlabel('Costo complessivo scontato')
ylabel('Probabilità') 
title(['Confronto tra la policy ottimale (rosso) e quella euristica (verde)'])
hold off

%% Display
disp('******** Confronto tra policy ottimale e policy euristica ********')
disp('******************************************************************');
disp(['Orizzonte temporale T = ' num2str(T) ]);
disp(['Numero di simulazioni Q = ' num2str(Q)])
disp(['Condizione iniziale x0 = (' num2str(x_curr(1,1)) ',' num2str(x_curr(1,2)) ')'])
disp(['Fattore di sconto alpha = ' num2str(alpha,'%.3f')])
disp(' ');
disp('*********** Costo complessivo medio (scontato) ***********' )
disp(['Policy ottimale = ' num2str(mJ_optimal)]); 
disp(['Policy euristica = ' num2str(mJ_euristic)]); 
disp(' ');
disp('*********** Deviazione standard del costo complessivo (scontato) ***********' )
disp(['Policy ottimale = ' num2str(sigmaJ_optimal)]); 
disp(['Policy euristica = ' num2str(sigmaJ_euristic)]);
disp(' ');


