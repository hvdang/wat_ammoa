% realcrossover.m version 22
% Feb 01, 2014
% Written by Hieu V. Dang

function f = realcrossover(parent_chromosome,M,V,mu,l_limit,u_limit,I,Wbits,MNW,posi_key)

N = size(parent_chromosome,1);
%clear kk1 kk2;
%child_1 = zeros(N,M+V,kk2);
%child_2 = zeros(N,M+V,kk2); child = zeros(N,M+V,kk2);


y=1;n=1; ncross = 0;  %ncross_p=0; %child = [];child_1 = []; child_2 = [];
for i=1:N
    rnd = rand(1);
   if y >= N
       y = y-N+1;
       n = n-N+1;
   end
           
               
   %Check whether the cross-over to be performed
    if (rnd < 0.8)
        
        % Loop over no of variables
        
        for j=1:V
            %select two parents
            par1 = parent_chromosome(y,j);
            par2 = parent_chromosome(y+1,j);
                                  
            yL = l_limit(j);
            yU = u_limit(j);
                               
            rnd = rand;
            % Check whether variable is selected or not
            if (rnd <= 0.8)
                
                ncross = ncross + 1;
                % Variable selected
                if(abs(par1-par2) > 0.000001)
                    if(par2 > par1)
                        y2 = par2;
                        y1 = par1;
                    else
                        y2 = par1;
                        y1 = par2;
                    end
                    if((y1-yL) > (yU - y2))
                        beta = 1 + (2*(yU-y2)/(y2-y1));
                    else
                        beta = 1 + (2*(y1-yL)/(y2-y1));
                    end
                    
                    % Find alpha
                    expp = mu + 1;
                    beta = 1/beta;
                    alpha = 2 - beta^expp;
                    
                    rnd = rand;
                    if(rnd <= 1/alpha)
                        alpha = alpha*rnd;
                        expp = 1/(mu+1);
                        betaq = alpha^expp;
                    else
                        alpha = alpha*rnd;
                        alpha = 1/(2-alpha);
                        expp = 1/(mu+1);
                        betaq = alpha^expp;
                    end
                    
                    % Generating two children
                    child1 = 0.5*((y1+y2) - betaq*(y2-y1));
                    child2 = 0.5*((y1+y2) + betaq*(y2-y1));
                else
                    betaq = 1;
                    y1 = par1;
                    y2 = par2;
                    
                    % Generating two children
                    child1 = 0.5*((y1+y2) - betaq*(y2-y1));
                    child2 = 0.5*((y1+y2) + betaq*(y2-y1));
                end
                
                if(child1 < yL) child1 = yL; end
                if(child1 > yU) child1 = yU; end
                if(child2 < yL) child2 = yL; end
                if(child2 > yU) child2 = yU; end
            else
                % Copying the children to parents
                child1 = par1;
                child2 = par2;
            end
            child_1(i,j) = child1;
            child_2(i,j) = child2;
            
        end
        
        % Evaluate the objective function for the offspring
        child_1(i,V+1:M+V) = evaluate_objectives(child_1(i,1:V),V,I,Wbits,MNW,posi_key);
        child_2(i,V+1:M+V) = evaluate_objectives(child_2(i,1:V),V,I,Wbits,MNW,posi_key);
        
        child(n,1:M+V) = child_1(i,1:M+V);
        child(n+1,1:M+V) = child_2(i,1:M+V);
        %n = n+2;
    else
        child(n,1:M+V) = parent_chromosome(y,1:M+V);
        child(n+1,1:M+V) = parent_chromosome(y+1,1:M+V);
    end
    n = n+2;
    y = y+2;
  
end

 f = child;       
        
            
                
                    
                    
                    