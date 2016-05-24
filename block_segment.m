% block_segment.m

% this function to implement 3x3 segmentation

% Written by Hieu V. Dang


function block = block_segment(HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1)

%% Level 4
% Divide HT3 to 3x3 non-overlapping blocks
l1 = size(HT3,1);
l13 = floor(l1/3);
kk=0; 
for i=1:l13
    for j=1:l13
        block(:,:,kk+j) = HT3((i-1)*3+1:i*3,(j-1)*3+1:j*3);
    end
    kk = kk + l13;
end

 % Devide VT3 to 3x3 non-overlapping blocks
 kk1 = kk;
  for i=1:l13
     for j=1:l13
         block(:,:,kk1+j) = VT3((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk1 = kk1+l13;
  end

% Devide DT3 to 3x3 non-overlapping blocks
 kk2 = kk1;
  for i=1:l13
     for j=1:l13
         block(:,:,kk2+j) = DT3((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk2 = kk2+l13;
  end
  
 %% Level 3
 
 % Devide HT2 to 3x3 block
 l23 = floor(size(HT2,1)/3);
 kk3 = kk2;
  for i=1:l23
     for j=1:l23
         block(:,:,kk3+j) = HT2((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk3 = kk3+l23;
  end
  
  % Divide VT2 to 3x3 block
  kk4 = kk3;
  for i=1:l23
     for j=1:l23
         block(:,:,kk4+j) = VT2((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk4 = kk4+l23;
  end
  
  % Divide DT2 into 3x3 block
  kk5 = kk4;
  for i=1:l23
     for j=1:l23
         block(:,:,kk5+j) = DT2((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk5 = kk5+l23;
  end
    
%% Level 2
% Divide HT1 to 3x3 blocks
 l33 = floor(size(HT1,1)/3);
 kk6 = kk5;
  for i=1:l33
     for j=1:l33
         block(:,:,kk6+j) = HT1((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk6 = kk6+l33;
  end
  
 % Divide VT1 to 3x3 blocks
 kk7 = kk6;
  for i=1:l33
     for j=1:l33
         block(:,:,kk7+j) = VT1((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk7 = kk7+l33;
  end

 % Divide DT1 to 3x3 blocks
 kk8 = kk7;
  for i=1:l33
     for j=1:l33
         block(:,:,kk8+j) = DT1((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk8 = kk8+l33;
  end
  
 %% Level 1
 % Divide HT0 to 3x3 blocks
 l43 = floor(size(HT0,1)/3);
 kk9 = kk8;
  for i=1:l43
     for j=1:l43
         block(:,:,kk9+j) = HT0((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk9 = kk9+l43;
  end
  
  % Divide VT0 into 3x3 block
  kk10 = kk9;
  for i=1:l43
     for j=1:l43
         block(:,:,kk10+j) = VT0((i-1)*3+1:i*3,(j-1)*3+1:j*3);
     end
     kk10 = kk10+l43;
  end