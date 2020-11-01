%% montecarlo_euristic_policy_punto2 %%
clear all
close 
clc

%% Parametri ed inizializzazione
[R,g1,g2,alpha,S,pr,z,T,Q,x_curr,x_next,u_distr,u] = montecarlo_setup();
J_euristic = zeros(Q,1);

%% Simulazione Monte Carlo
for q = 1:Q
    for t = 1:T+1  
        if t ~= 1
           x_curr(t,:) = x_next(t-1,:);    
        end
        x1 = x_curr(t,1);
        x2 = x_curr(t,2);
        % Input per ogni stato seguendo l'euristica 
        if (x1 + x2) <= 1 
            u1 = 0; % celeste
            u2 = 0;
            u_distr(t,:,q) = 1; % valori da 1 a 4 per avere unica colonna 
        
        elseif x1 == 0 && x2 >= 2
               u1 = 0; % turchese
               u2 = 2;
               u_distr(t,:,q) = 2;
     
        elseif x2 == 0 && x1 >= 2
               u1 = 2; % senape
               u2 = 0;
               u_distr(t,:,q) = 3;
        
        else 
            u1 = 1; % giallo
            u2 = 1;
            u_distr(t,:,q) = 4;

        end
        % Immagazzinamento degli input (monodimensionali) in un unico vettore colonna 
        if q ==  1 % tranne che per la prima iterazione
           u = u_distr(:,:,q);
        else
            u = [u; u_distr(t,:,q)];
        end
        % Calcolo del costo scontato per lo stato corrente
        [z,w1,w2] = montecarlo_discounted_cost(x1,x2,u1,u2,R,S,pr,g1,g2,t,z,alpha);
        % Generazione del prossimo stato sulla base dell'input  
        [x_next] = next_state_montecarlo(x1,x2,w1,w2,S,u1,u2,t,x_next);

    end
    J_euristic(q,1) = sum(z); % costo complessivo scontato per la q-esima iterazione
end

%% Stima del valore medio e della dev. std del costo complessivo scontato per la policy euristica
mJ_euristic = mean(J_euristic); % costo complessivo scontato medio
sigmaJ_euristic = std(J_euristic); % deviazione standard del costo complessivo scontato

%% Stima della distribuzione del costo complessivo scontato seguendo la policy euristica
figure(1)
hold on
subplot(2,1,1)
nbins = round(2*(Q^(1/3))); % numero di bins per la creazione degli istogrammi
histogram(J_euristic, nbins, 'Normalization', 'probability', 'FaceColor','g','FaceAlpha', 1)
xlabel('Costo complessivo scontato')
ylabel('Probabilità') 
title(['Distribuzione del costo complessivo (scontato) per la policy euristica'])
grid;
subplot(2,1,2)
[fJ,xJ] = ecdf(J_euristic); % fJ = cdf empirica di J_euristic in corrispondenza dei valori xJ 
stairs(xJ,fJ,'b','LineWidth',2)
xlabel('Costo complessivo scontato')
ylabel('Distribuzione di probabilità') 
grid;
hold off

%% Stima della distribuzione degli ingressi 
figure(2)
hold on
subplot(2,1,1)
input = [1:4];
nu = (hist(u,input))/((T+1)*Q); % frequenza relativa di u
stem(input,nu,'LineWidth',3,'MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',6);
grid;
xlabel('Ingressi ammissibili')
ylabel('Probabilità')
xlim([0 5])
ylim([0 1])
title(['Distribuzione degli ingressi per la policy euristica'])
legend(' Input (0,0) = 1   Input (0,2) = 2   Input (2,0) = 3   Input (1,1) = 4 ','Location','northwest')
subplot(2,1,2)
[fu,xu] = ecdf(u);
stairs(xu,fu,'r','LineWidth',2)
grid;
xlabel('Ingressi ammissibili')
ylabel('Distribuzione di probabilità')
xlim([0 5])
ylim([0 1])
hold off

%% Display della policy euristica e salvataggio per confronto nel punto 5
U = 4*ones(S+1,S+1);
U(1,1) = 1;
U(1,2) = 1;
U(2,1) = 1;
U(3:end,1) = 2;
U(1,3:end) = 3;
[m, n] = size(U); % m => C2 (righe) & n => C1 (colonne)
figure(3)
pcolor([0.5:n+0.5],[0.5:m+0.5],10*[ [U zeros(m,1)]; zeros(1,n+1)])
xlabel('# pezzi nel cesto 1')
ylabel('# pezzi nel cesto 2')
title('Policy euristica \mu: non confezionare (celeste), 2 pezzi da C1 (senape), 2 pezzi da C2 (turchese), 1 pezzo da C1 e 1 da C2 (giallo) ')
axis(0.5+[0 n 0 m]);

disp(' ');
disp('******** Policy euristica ********')
disp(['Orizzonte temporale T = ' num2str(T) ])
disp(['Numero di simulazioni Q = ' num2str(Q)])
disp(['Condizione iniziale x0 = (' num2str(x_curr(1,1)) ',' num2str(x_curr(1,2)) ')'])
disp(['Fattore di sconto alpha = ' num2str(alpha,'%.3f')])
disp(' ');
disp(['Costo complessivo medio scontato per la policy euristica = ', num2str(mJ_euristic)])
disp(['Deviazione standard del costo complessivo scontato per la policy euristica = ', num2str(sigmaJ_euristic)])
disp(' ');

save('euristica_montecarlo.mat', 'J_euristic', 'mJ_euristic', 'sigmaJ_euristic')
