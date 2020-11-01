%% punto6 %% 
clear all
close
clc

%% Parametri del problema:
[x,S,R,g1,g2,alpha,epsilon,delta,N_w,p1,p2,pr] = problem_setup_6a();
%[x,S,R,g1,g2,alpha,epsilon,delta,N_w,p1,p2,pr] = problem_setup_6b();
%[x,S,R,g1,g2,alpha,epsilon,delta,N_w,p1,p2,pr] = problem_setup_6c();

%% Inizializzazione:
U_aux = zeros(S+1,2,S+1); % input con 2 componenti
V_aux = zeros(S+1,1,S+1,2); 
% V_aux(:,:,:,1) = 1; % nel caso si volesse inizializzare a valori diversi da 0 (è V0_s) 
err = 1000; 
k = 0; % numero dell'iterazione

%% Value iteration algorithm
while err > delta 
      k = k+1;
    
      % Aggiungo una nuova serie di colonne (due per U_aux e 1 per V_aux) alle matrici prima definite
      U_aux(:,:,:,k) = 0; % iterazione precedente per U_aux è k-1, quella attuale è k              
      V_aux(:,:,:,k+1) = 0; % iterazione precednte per V_aux è k, quella attuale è k+1 (si è inserito V0_s nella prima colonna di V_aux)
      
      % Per ogni stato (coppia di componenti)
      for x1 = 1:S+1
          for x2 = 1:S+1
               
         % Si tengono in considerazione i vari vincoli sugli input (dati dalla necessità di prendere 2 pezzi per ogni confezione da realizzare)        
              
              if (x1-1)+(x2-1) < 2 % x = (0,0) || (1,0) || (0,1)
                 
                  % Si inizializzano i vettori degli expected stage cost (E_z) e delle approssimazioni della optimal value function (E_V)
                  N_input = 1;
                  [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);
                  % Per ogni input ammissibile in questi stati    
                  u1 = 0;
                  u2 = 0;
                  u = [u1,u2]; % in questo caso solo u = (0,0)
                  [h] = realized_package(u1,u2); 
                  % Calcolo dell'expected stage cost e alpha * value_function
                  [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);
                  E_z = sum(z(:,1));
                  E_V = sum(V(:,1));
                  % Identificazione dell'input ottimale e del realtivo valore della value function associato
                  u_star = u;
                  V_star = min(E_z+E_V); % unico valore in questo caso 
                  U_aux(x2,:,x1,k) = u_star; % storage di u_star
                  V_aux(x2,1,x1,k+1) = V_star; % storage di V_star
                                       
              elseif x1 == (0+1) && x2 >= (2+1) % x = (x1 = 0,x2 >= 2)
               
                     % Si inizializzano i vettori degli expected stage cost (E_z) e delle approssimazioni della optimal value function (E_V)
                     N_input = 2;
                     [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);
                     % Per ogni input ammissibile in questi stati    
                     for u2 = 0:2:2
                         u1 = 0;
                         u = [u1,u2];
                         [h] = realized_package(u1,u2);
                         % Calcolo dell'expected stage cost e alpha * value_function
                         [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);
                         if u2 == 0
                            E_z(1,1) = sum(z(:,1));  
                            E_V(1,1) = sum(V(:,1));
                         else
                            E_z(2,1) = sum(z(:,1));
                            E_V(2,1) = sum(V(:,1));
                         end
                     end
                     % Identificazione dell'input ottimale e del realtivo valore della value function associato               
                     [V_star, U_star] = min(E_z+E_V); 
                     if U_star == 1
                        u_star = [0,0];
                     else
                        u_star = [0,2];
                     end
                     U_aux(x2,:,x1,k) = u_star;
                     V_aux(x2,1,x1,k+1) = V_star;
 
              elseif x2 == (0+1) && x1 >= (2+1) % x = (x1 >= 2,x2 = 0)
               
                     N_input = 2;
                     [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);                         
                     for u1 = 0:2:2
                         u2 = 0;
                         u = [u1,u2];
                         [h] = realized_package(u1,u2);                         
                         [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);
                         if u1 == 0
                            E_z(1,1) = sum(z(:,1));  
                            E_V(1,1) = sum(V(:,1));
                         else
                            E_z(2,1) = sum(z(:,1));
                            E_V(2,1) = sum(V(:,1));
                         end
                     end                     
                     [V_star, U_star] = min(E_z+E_V); 
                     if U_star == 1
                        u_star = [0,0];
                     else
                        u_star = [2,0];
                     end                     
                     U_aux(x2,:,x1,k) = u_star;
                     V_aux(x2,1,x1,k+1) = V_star;
                      
              elseif x1 == (1+1) && x2 == (1+1) % x = (x1 = 1,x2 = 1)
               
                     N_input = 2;
                     [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);                         
                     for u1 = 0:1:1 
                         if u1 == 0
                            u2 = 0;
                         else
                            u2 = 1;
                         end
                         u = [u1,u2];
                         [h] = realized_package(u1,u2);
                         [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                         
                         if u1 == 0
                            E_z(1,1) = sum(z(:,1));  
                            E_V(1,1) = sum(V(:,1));
                         else
                            E_z(2,1) = sum(z(:,1));
                            E_V(2,1) = sum(V(:,1));
                         end
                     end                     
                     [V_star, U_star] = min(E_z+E_V); 
                     if U_star == 1
                        u_star = [0,0];
                     else
                         u_star = [1,1];
                     end                   
                     U_aux(x2,:,x1,k) = u_star;
                     V_aux(x2,1,x1,k+1) = V_star;
        
                      
              elseif x1 == (1+1) && x2 >= (2+1) % x = (x1 = 1,x2 >= 2 )

                     N_input = 3;
                     [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);
                     for u1 = 0:1:1 
                         if u1 == 0
                            for u2 = 0:2:2
                                u = [u1,u2];
                                [h] = realized_package(u1,u2);
                                [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                                
                                if u2 == 0
                                   E_z(1,1) = sum(z(:,1));  
                                   E_V(1,1) = sum(V(:,1));
                                else
                                    E_z(2,1) = sum(z(:,1));                                     
                                    E_V(2,1) = sum(V(:,1));
                                end            
                            end
                         else
                             u2 = 1;
                             u = [u1,u2];
                             [h] = realized_package(u1,u2);
                             [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                                
                             E_z(3,1) = sum(z(:,1));
                             E_V(3,1) = sum(V(:,1));
                         end
                     end                     
                     [V_star, U_star] = min(E_z+E_V);
                     if U_star == 1
                        u_star = [0,0];
                     elseif U_star == 2
                            u_star = [0,2];
                     else
                         u_star = [1,1];
                     end                     
                     U_aux(x2,:,x1,k) = u_star;
                     V_aux(x2,1,x1,k+1) = V_star;
                     
                        
              elseif x2 == (1+1) && x1 >= (2+1) % x = (x1 >= 2, x2 = 1)

                     N_input = 3;
                     [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);
                     for u2 = 0:1:1 
                         if u2 == 0
                            for u1 = 0:2:2
                                u = [u1,u2];
                                [h] = realized_package(u1,u2);
                                [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                                                                                         
                                if u1 == 0
                                   E_z(1,1) = sum(z(:,1));  
                                   E_V(1,1) = sum(V(:,1));
                                else
                                    E_z(2,1) = sum(z(:,1));                                     
                                    E_V(2,1) = sum(V(:,1));
                                end            
                            end
                         else
                             u1 = 1;
                             u = [u1,u2];
                             [h] = realized_package(u1,u2);
                             [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                                
                             E_z(3,1) = sum(z(:,1));
                             E_V(3,1) = sum(V(:,1));
                         end
                     end   
                     [V_star, U_star] = min(E_z+E_V);
                     if U_star == 1
                        u_star = [0,0];
                     elseif U_star == 2
                            u_star = [2,0];
                     else
                         u_star = [1,1];
                     end             
                     U_aux(x2,:,x1,k) = u_star;
                     V_aux(x2,1,x1,k+1) = V_star;
                                      
              else % in tutti gli altri casi 

                   N_input = 4;
                   [z,V,E_z,E_V] = initialization_expectedvalues(N_input,N_w);
                   for u1 = 0:1:2
                       if u1 == 0
                          for u2 = 0:2:2
                              u = [u1,u2];
                              [h] = realized_package(u1,u2);
                              [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                                
                              if u2 == 0
                                 E_z(1,1) = sum(z(:,1));      % u = (0,0)
                                 E_V(1,1) = sum(V(:,1));
                              else
                                  E_z(2,1) = sum(z(:,1));      % u = (0,2)                               
                                  E_V(2,1) = sum(V(:,1));
                              end  
                          end                              
                       elseif u1 == 1
                              u2 = 1;
                              u = [u1,u2];
                              [h] = realized_package(u1,u2);
                              [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k); 
                              E_z(3,1) = sum(z(:,1));  % u = (1,1)
                              E_V(3,1) = sum(V(:,1));                             
                       else
                            u2 = 0;
                            u = [u1,u2];
                            [h] = realized_package(u1,u2);
                            [z,V] = expected_cost(x,x1,x2,S,u1,u2,g1,g2,R,h,alpha,z,V,V_aux,pr,k);                              
                            E_z(4,1) = sum(z(:,1));  % u = (2,0)
                            E_V(4,1) = sum(V(:,1));
                       end
                   end                 
                  [V_star, U_star] = min(E_z+E_V);
                  if U_star == 1
                     u_star = [0,0];
                  elseif U_star == 2
                     u_star = [0,2];
                  elseif U_star == 3
                     u_star = [1,1];
                  else 
                     u_star = [2,0];
                  end
                  U_aux(x2,:,x1,k) = u_star;
                  V_aux(x2,1,x1,k+1) = V_star; 
              end
          end
      end
      
    % Calcolo dell'errore per questa iterazione
    err = max(abs(V_aux(:,:,:,k+1) - V_aux(:,:,:,k))); 
    
end

%% Plots:

% Dislpay dei parametri:
disp('  ');
disp(['***** Parametri del problema *****'])
disp(['Capacità massima di ogni cesto: S = ', num2str(S)])
disp(['Probabilità di avere un nuovo pezzo nel cesto 1: p1 = ', num2str(p1)])
disp(['Probabilità di avere un nuovo pezzo nel cesto 2: p2 = ', num2str(p2)])
disp(['Costo per ogni pezzo rigettato: R = ', num2str(R)])
disp(['Holding cost unitario per il cesto 1: g1 = ', num2str(g1)])
disp(['Holding cost unitario per il cesto 2: g2 = ', num2str(g2)])
disp(['Fattore di sconto: alpha = ', num2str(alpha)])
disp('  ');

% Identificazione della policy ottimale
U = U_aux(:,:,:,end); % policy ottimale
U_optimal = zeros(S+1,S+1); % per la rappresentazione grafica
for j = 1:S+1
    for b = 1:S+1
        if U(j,:,b) == [0,0]
           U_optimal(j,b) = 1;
        elseif U(j,:,b) == [0,2]
           U_optimal(j,b) = 2;
        elseif U(j,:,b) == [2,0]
           U_optimal(j,b) = 3;
        else
           U_optimal(j,b) = 4;
        end
    end
end
[m n] = size(U_optimal); % m => C2 (righe) & n => C1 (colonne)
figure(1)
pcolor([0.5:n+0.5],[0.5:m+0.5],10*[ [U_optimal zeros(m,1)]; zeros(1,n+1)])
xlabel('# pezzi nel cesto 1')
ylabel('# pezzi nel cesto 2')
title('Optimal policy \mu: non confezionare (celeste), 2 pezzi da C1 (senape), 2 pezzi da C2 (turchese), 1 pezzo da C1 e 1 da C2 (giallo) ')
axis(0.5+[0 n 0 m]);
