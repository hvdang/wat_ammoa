% realmutation.m version 22
% Feb 01, 2014
% Written by Hieu V. Dang

function f = realmutation(chromosome,M,V,mum,l_limit,u_limit,I,Wbits,MNW,posi_key)

pop = size(chromosome,1);

for i=1:pop
    rnd = rand;
    % For each chromosome find whether to do mutation or not
   if (rnd < 0.05)
    for j=1:V
        rnd = rand;
        % For each variable find whether to do mutation or not
        y = chromosome(i,j);
        if(rnd < 0.5)
            yL = l_limit(j);
            yU = u_limit(j);
            
            if(y > yL)
                % Calculate delta
                if((y-yL) < (yU-y))
                    delta = (y-yL)/(yU-yL);
                else
                    delta = (yU - y)/(yU-yL);
                end
                
                rnd = rand;
                
                indi = 1/(mum+1);
                
                if(rnd <= 0.5)
                    xy = 1 - delta;
                    val = 2*rnd + (1-2*rnd)*(xy^(mum+1));
                    deltaq = val^indi - 1;
                else
                    xy = 1-delta;
                    val = 2*(1-rnd) + 2*(rnd - 0.5)*(xy^(mum+1));
                    deltaq = 1 - val^indi;
                end
                
                % Change the value for the parent
                y = y + deltaq*(yU - yL);
                
                if(y < yL) y = yL; end
                if(y > yU) y = yU; end
                
                child(i,j) = y;
            else
                xy = rand(1);
                child(i,j) = xy*(yU - yL) + yL;
            end
        else
            child(i,j) = y;
        end
    end
    chromosome(i,1:V) = child(i,1:V);
    chromosome(i,V+1:M+V) = evaluate_objectives(chromosome(i,1:V),V,I,Wbits,MNW,posi_key); 
   end
end
f = chromosome;


                
                    
    