
% tabu_search_stage2.m
% Local search 2
% August 4, 2014,
% Written by Hieu V. Dang

function [improved_population] = tabu_search_stage2(population,Nvar,Nfun,min_range,max_range,I,Wbits,MNW,hvs_kw)

K = Nvar + Nfun;

%if rand(1) <0.5 % check probability of local search at stage 1

Npop= size(population,1);
n = floor(Npop/3);
maxIters = 5*n;
nTL = n; % length of tabu list
TL = zeros(nTL,K); % Tabu list

% Generate the random normalized weight vector
    Zn = rand(1);
    lamda = zeros(1,Nfun);
    lamda(1) = 1-Zn^(1/(Nfun-1));
    temp=0;
    for j=2:Nfun-1
        temp = temp + lamda(j-1);
        lamda(j) = (1-temp)*(1-Zn/(1/(Nfun-j)));
    end
    lamda(Nfun) = 1 - temp - lamda(Nfun-1);

    %lamda = [1 1];

if rand(1) < 0.45 %probability ò tabu search
    
       
    % select the best offspring as the initial population for local search
    rEntropy = zeros(1,Npop);
    for i=1:Npop
        rEntropy(i) = sum(lamda.*population(i,Nvar+1:K));
    end
    [~,minEntropy] = min(rEntropy);
    %clear temp;
    
    initial_offspring = population(minEntropy,1:K);
    x = initial_offspring;
    
    init_w_objs = sum(lamda.*x(Nvar+1:K));
    better_w_objs = init_w_objs;
    
    %Tabu list setting
    inTL = 1;
    TL(inTL,1:K) = x(1:K);
    
    
    %%%%%Main loop%%%%%%%
    S = zeros(n,K);
    fv = zeros(1,n);
    itrc = 0;
    while(itrc < maxIters)
        
        
        S = initialize_variables(n,Nvar,Nfun,min_range,max_range,I,Wbits,MNW,hvs_kw);
        for i=1:n
            fv(i) = sum(lamda.*S(i,Nvar+1:K));
        end
        
        % Search for better neighbors
        for i=1:n
            % check S is in the TL
            flag_tl = 0;
            for j=1:nTL
                if isequal(S(i,1:Nvar),TL(i,1:Nvar))==1
                    flag_tl = flag_tl +1;
                end
            end
            
            b_flag =0;
            if(fv(i) < better_w_objs) && (flag_tl==0)
                xnew = S(i,1:K);
                fnew = fv(i);
                b_flag=1;
            else
                xnew = x(1:K);
                fnew = better_w_objs;
            end
            
            % update Tabulist
            if (inTL < nTL) && (b_flag==1)
                inTL = inTL +1;
                TL(inTL,1:K) = xnew;
            elseif (inTL >= nTL) && (b_flag==1) 
                inTL = 1;
                TL(inTL,1:K) = xnew;
            end
        end
        x(1:K) = xnew(1:K);
        better_w_objs = fnew;
        itrc = itrc +1;
    end
end % end if

% Sort the TL
w_objs = zeros(1,nTL);
for i=1:nTL
    w_objs(i) = sum(lamda.*TL(i,Nvar+1:K));
end
indx = find(w_objs~=0);
[~,tl_index] = sort(w_objs(indx));

TL_sort = TL(tl_index,:);
%improved_population = TL_sorted(1:n,1:K);
if length(tl_index) < n
    improved_population = TL_sort;        
else
    improved_population = TL_sort(1:n,:);
end


