%% montecarlo_setup %%

function [R,g1,g2,alpha,S,pr,z,T,Q,x_curr,x_next,u_distr,u] = montecarlo_setup()

T = 100; % orizzonte temporale 
Q = 500; % numero di simulazioni 
S = 9; % capacità massima di ogni cesto 
alpha = 0.95; % fattore di sconto

% Costi unitari: 
R = 10; % costo per ogni pezzo scartato
g1 = 0.01; % costo per ogni pezzo all'interno del cesto 1
g2 = 0.01; % costo per ogni pezzo all'interno del cesto 2 

% Parametri legati alla variabile aleatoria wt = (w1t,w2t) appartiene a W = {(0,0),(1,0),(0,1),(1,1)}
p1 = 0.85;
p2 = 0.95;
p_C1 = [(1-p1), p1];
p_C2 = [(1-p2), p2];
pr = [p_C1(1,1)*p_C2(1,1); 
      p_C1(1,2)*p_C2(1,1); 
      p_C1(1,1)*p_C2(1,2); 
      p_C1(1,2)*p_C2(1,2)]; % riempimenti indipendenti, probabilità dell'intersezione = prodotto delle probabilità  

% Inizializzazione di vettori utili e definizione stato iniziale 
u_distr = zeros(T+1,1,Q); % input ad ogni istante temporale per la q-esima iterazione
u = zeros(T+1,1); % utile per la sistemazione in colonna degli input
z = zeros(T+1,1); % vettore degli stage cost
x_curr = zeros(T+1,2); % da 1 a 101 invece che da 0 a 100
x_next = zeros(T+1,2);
x_curr(1,:) = [3,6]; % stato iniziale 

end

