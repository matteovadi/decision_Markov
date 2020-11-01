%% problem_setup_3 %% 

function [x,S,R,g1,g2,alpha,epsilon,delta,N_w,p1,p2,pr] = problem_setup_3()

% Costi unitari: 
R = 10; % costo per ogni pezzo scartato
g1 = 0.01; % costo per ogni pezzo all'interno del cestello 1
g2 = 0.01; % costo per ogni pezzo all'interno del cestello 2 

% Stato del sistema: xt = (x1t,x2t) appartiene a X = {(x1t,x2t): x1t = 0,1,..,S && x2t = 0,1,..,S}
D = 2; % dimensione del vettore stato --> per la creazione della matrice multidimensionale dello stato
S = 9; % capacità massima di ogni cesto
x = zeros(S+1,D,S+1); % matrice stato multimensionale
for d = 1:D
    for q = 1:(S+1)
        if d == 1
           x(:,d,q) = q-1;
        else
           x(q,d,:) = q-1;
        end
    end
end

% Parametri per lo "stop signal":
alpha = 0.95; % fattore di sconto 
epsilon = 1; % parametro per accuratezza dell'approssimazione --> trial and error
delta = ((1-alpha)*epsilon)/alpha; % parametro di confronto con la differenza tra le ultime due approssimazioni di V_star

% Parametri legati alla variabile aleatoria wt = (w1t,w2t) appartiene a W = {(0,0),(1,0),(0,1),(1,1)}
N_w = 4; % numero di possibili stati successivi diversi sulla base di w per ogni input ammissibile
p1 = 0.85;
p2 = 0.95;
p_C1 = [(1-p1), p1];
p_C2 = [(1-p2), p2];
pr = [p_C1(1,1)*p_C2(1,1); 
      p_C1(1,2)*p_C2(1,1); 
      p_C1(1,1)*p_C2(1,2); 
      p_C1(1,2)*p_C2(1,2)]; % riempimenti indipendenenti, probabilità dell'intersezione = prodotto delle probabilità 

end



