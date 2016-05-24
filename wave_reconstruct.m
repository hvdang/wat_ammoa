% wave_reconstruct.m
% Wavelet trconstruction function

% Feb 01, 2014
% Writeen by Hieu V. Dang



function w_image = wave_reconstruct(block,C,S,HT3,HT2,HT1,HT0,VT3,VT2,VT1,VT0,DT3,DT2,DT1,DT0,A1)

% reconstruct H1
  H1 = HT3; V1 = VT3; D1 = DT3; H2 = HT2; V2=VT2; D2 = DT2; H3=HT1; V3 = VT1;
  D3 = DT1; H4 = HT0; V4 = VT0; D4 =DT0;
  l1 = size(HT3,1);
l13 = floor(l1/3);
  kkk=0;
  for i=1:l13
      for j=1:l13
          H1((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk+j);
      end
      kkk= kkk+l13;
  end
  H{1} = H1;
  
  % Reconstruct V1
  kkk1 = kkk;
  for i=1:l13
      for j=1:l13
          V1((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk1+j);
      end
      kkk1 = kkk1+l13;
  end
  V{1} = V1;
  
  % reconstruct D1
  kkk2=kkk1;
  for i=1:l13
      for j=1:l13
          D1((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk2+j);
      end
      kkk2=kkk2+l13;
  end
  D{1} = D1;
  
  % Reconstruct H2
  l23 = floor(size(HT2,1)/3);
  kkk3 = kkk2;
  for i=1:l23
      for j=1:l23
          H2((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk3+j);
      end
      kkk3=kkk3+l23;
  end
  H{2} = H2;
  
  % reconstruc V2
  kkk4 = kkk3;
  for i=1:l23
      for j=1:l23
          V2((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk4+j);
      end
      kkk4=kkk4+l23;
  end
  V{2} = V2;
  % Reconstruct D2
  kkk5 = kkk4;
  for i=1:l23
      for j=1:l23
          D2((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk5+j);
      end
      kkk5=kkk5+l23;
  end
  D{2} = D2;
  
  % Reconstruct H3
  l33 = floor(size(HT1,1)/3);
  kkk6=kkk5;
  for i=1:l33
      for j=1:l33
          H3((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk6+j);
      end
      kkk6=kkk6+l33;
  end
  H{3} = H3;
  
  % Reconstruct V3
  kkk7=kkk6;
  for i=1:l33
      for j=1:l33
          V3((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk7+j);
      end
      kkk7=kkk7+l33;
  end
  V{3} = V3;
  % recontrsuct D3
  kkk8 = kkk7;
  for i=1:l33
      for j=1:l33
          D3((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk8+j);
      end
      kkk8 = kkk8+l33;
  end
  D{3} = D3;
  
  % reconstruct H4
  l43 = floor(size(HT0,1)/3);
  kkk9 = kkk8;
  for i=1:l43
      for j=1:l43
          H4((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk9+j);
      end
      kkk9=kkk9+l43;
  end
  H{4} = H4;
  
  % Reconstruct V4
  kkk10 = kkk9;
  for i=1:l43
      for j=1:l43
          V4((i-1)*3+1:i*3,(j-1)*3+1:j*3) = block(:,:,kkk10+j);
      end
      kkk10 = kkk10+l43;
  end
  V{4}=V4;
  D{4} = D4;
  
%% Reconstruction and wavelet decomposition
C1=C;
kkkk=0;
for i=1:S(1)
   for j=1:S(1)
       C1(kkkk+j) = A1(j,i);
   end
        kkkk = kkkk+j;
end
 
% for matrix H1
 kkkk1=kkkk;
 nlevel = 4;
 for ilevel = 2:nlevel+1 
     H1 = H{ilevel-1};
     for i=1:S(ilevel)
         for j=1:S(ilevel)
             C1(kkkk1+j)= H1(j,i);
         end
         kkkk1=kkkk1+S(ilevel);
     end
          
     % for matrix V
     V1 = V{ilevel-1};
     kkkk2=kkkk1;
     for i=1:S(ilevel)
         for j=1:S(ilevel)
              C1(kkkk2+j) = V1(j,i);
         end
         kkkk2=kkkk2+S(ilevel);
     end
     
     % for matrix D
     D1 = D{ilevel-1};
     kkkk3=kkkk2;
     for i=1:S(ilevel)
         for j=1:S(ilevel)
              C1(kkkk3+j)=D1(j,i);
         end
         kkkk3=kkkk3+S(ilevel);
     end
     kkkk1 = kkkk3;
 end
  
 % Wavelet reconstruction
  w_image = waverec2(C1,S,'sym2');