% replace_population.m
% May 12, 2014
% Written by Hieu V. Dang

function f = replace_population(inter_population,Nvar,Nfun,Npop)


N_inter0 = size(inter_population,1);

K = Nvar + Nfun;

%% Check whether overlaped solutions
indx = [];
for i=1:N_inter0
    a = inter_population(i,1:K);
    for j=1:N_inter0
        if j~=i && isempty(find(indx==j))&& isempty(find(indx==i))
            b = inter_population(j,1:K);
            if isequal(a,b) 
                indx = [indx j];
            end
       end
   end
end
Lindx = length(indx);
dif = N_inter0 - Npop;
%if Lindx < dif
% inter_population(indx,K+1) = max(inter_population(:,K+1))+1;
%else
%    inter_population(indx(1:dif),:) = [];
%end
%inter_population(indx,:) = [];

N_inter = size(inter_population,1);


%% 
% Sort the populations based on the Pareto rank
[~,index] = sort(inter_population(:,K+1));
sorted_inter_population = inter_population(index,:);
%for i=1:N_inter
%    sorted_inter_population(i,:) = inter_population(index(i),:);
%end

% Find the maximum rank in the current population
max_rank = max(inter_population(:,K+1));

% Start adding each front based on rank and crowding distance until te
% whole population is filled
previous_index = 0;
for i=1:max_rank
    % Get the index for current rank
    current_index = max(find(sorted_inter_population(:,K+1)==i));
    % Check to see if the population is filled if all the individuals with
    % rank i is added to the population
    if current_index > Npop
        % If so find the number of individuals with current rank i
        remaining = Npop - previous_index;
        % Get information about the individuals in the current rank i
        temp_pop = sorted_inter_population(previous_index+1:current_index,:);
        % Sort the individuals with rank i in the descending order based on
        % the relative infor distance
        [~,temp_sort_index] = sort(temp_pop(:,K+3),'descend');
        % Start filling individuals into the population in descending order
        % until the population is filled
        for j=1:remaining
            f(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
       % return;
    %elseif current_index < Npop
        % Add all the individuals with rank i into the population
     %   f(previous_index + 1:current_index,:) = sorted_inter_population(previous_index+1:current_index,:);
    else
        % Add all the individuals with rank i into the population
        f(previous_index+1:current_index,:)= sorted_inter_population(previous_index+1:current_index,:);
        %return
    end
    % Get the index for the last added individual
    previous_index = current_index;
end

