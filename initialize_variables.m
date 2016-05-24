% initialize_variables.m version 22
% Feb 01, 2014
% Written by Hieu V. Dang

function population = initialize_variables(Npop,Nvar,Nfun,min_range,max_range,I,Wbits,MNW,hvs_kw)

min = min_range;
max = max_range;

K = Nvar + Nfun; % array consists of V decision variables and MO objectives

%% Initialize each chromosome
population = zeros(Npop,K);
for i = 1: Npop
    % Initialize the decision variables based on the minimum and maximum
    % possible values.
    
    for j=1:Nvar
        population(i,j) = min(j)+ (max(j) - min(j))*rand(1);
    end
    
     
    % MO objectives are then stored at the end of each chromosome
    population(i,Nvar+1:K) = evaluate_objectives(population(i,:),Nvar,I,Wbits,MNW,hvs_kw);

end
