% crowd_distance.m
% May 14, 2014
% Written by Hieu V. Dang

function f = crowd_distance(population,Nvar,Nfun)

%Npop = size(population,1);

K = Nvar+Nfun;


max_rank = max(population(:,K+1));

previous_index=0;
for i=1:max_rank
    % find the index for current rank
    %temp_pop = [];
    current_index = max(find(population(:,K+1)==i));
    
    temp_pop = population(previous_index+1:current_index,:);
    %temp_pop1 = population(previous_index+1:current_index,:);
    
    for j=1:Nfun
        % sorting based on objective
        [~,index_obj] = sort(temp_pop(:,Nvar+j));
        
        sorted_based_objective = [];
        for k=1:length(index_obj)
            sorted_based_objective(k,:) = temp_pop(index_obj(k),:);
        end
        
        fmax = sorted_based_objective(length(index_obj),Nvar+j);
        fmin = sorted_based_objective(1,Nvar+j);
        
        temp_pop(index_obj(length(index_obj)),K+1+j) = Inf;
        temp_pop(index_obj(1),K+1+j) = Inf;
        
        for k=2:length(index_obj)-1
            next_obj = sorted_based_objective(k+1,Nvar+j);
            previous_obj = sorted_based_objective(k-1,Nvar+j);
            if (fmax - fmin == 0)
                temp_pop(index_obj(k),K+1+j) = Inf;
            else
                temp_pop(index_obj(k),K+1+j) = 100*(next_obj - previous_obj)/(fmax - fmin);
            end
        end
    end
    distance = zeros(current_index,1);
    for j = 1:Nfun
        distance(:,1) = distance(:,1) + temp_pop(:,K+1+j);
    end
    temp_pop(:,K+3) = distance;
    y = temp_pop(:,1:K+3);
    z(previous_index+1:current_index,:) = y;
end
f = z();
    
    